package com.company.training_portal.controller;

import com.company.training_portal.dao.*;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.QuestionType;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.company.training_portal.controller.SessionAttributes.*;
import static com.company.training_portal.controller.SessionAttributes.QUESTIONS_NUMBER;
import static com.company.training_portal.model.enums.QuestionType.*;
import static com.company.training_portal.model.enums.StudentQuizStatus.CLOSED;
import static com.company.training_portal.model.enums.StudentQuizStatus.PASSED;
import static com.company.training_portal.util.Utils.roundOff;

@Controller
public class QuizPassingController {

    private QuizDao quizDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;

    private Logger logger = Logger.getLogger(QuizPassingController.class);

    @Autowired
    public QuizPassingController(QuizDao quizDao,
                                 QuestionDao questionDao,
                                 AnswerSimpleDao answerSimpleDao,
                                 AnswerAccordanceDao answerAccordanceDao,
                                 AnswerSequenceDao answerSequenceDao,
                                 AnswerNumberDao answerNumberDao) {
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
    }

    @ModelAttribute("userId")
    public Long getUserId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping(value = "/quizzes/{quizId}/initialize", method = RequestMethod.GET)
    public String initializeQuiz(@ModelAttribute("userId") Long studentId,
                                 @PathVariable("quizId") Long quizId,
                                 HttpSession session,
                                 ModelMap model) {
        List<Question> questionsOneAnswer = questionDao.findQuestions(quizId, ONE_ANSWER);
        List<Question> questionsFewAnswers = questionDao.findQuestions(quizId, FEW_ANSWERS);
        List<Question> questionsAccordance = questionDao.findQuestions(quizId, ACCORDANCE);
        List<Question> questionsSequence = questionDao.findQuestions(quizId, SEQUENCE);
        List<Question> questionsNumber = questionDao.findQuestions(quizId, QuestionType.NUMBER);

        Collections.shuffle(questionsOneAnswer);
        Collections.shuffle(questionsFewAnswers);
        Collections.shuffle(questionsAccordance);
        Collections.shuffle(questionsSequence);
        Collections.shuffle(questionsNumber);

        List<Question> questions = new ArrayList<>(questionsOneAnswer);
        questions.addAll(questionsFewAnswers);
        questions.addAll(questionsAccordance);
        questions.addAll(questionsSequence);
        questions.addAll(questionsNumber);

        session.setAttribute(CURRENT_QUIZ, quizDao.findQuiz(quizId));
        session.setAttribute(QUESTIONS, questions);
        session.setAttribute(RESULT, 0D);
        session.setAttribute(QUESTIONS_NUMBER, questions.size());
        session.setAttribute(CURRENT_QUESTION_SERIAL, 0);
        session.setAttribute(START_TIME, LocalDateTime.now());

        LocalDateTime startDate = LocalDateTime.now();
        quizDao.editStartDate(startDate, studentId, quizId);

        model.clear();

        return "redirect:/quizzes/" + quizId + "/passing";
    }

    @SuppressWarnings("Duplicates")
    @RequestMapping(value = "/quizzes/{quizId}/passing", method = RequestMethod.GET)
    public String showCurrentQuestionGet(@ModelAttribute("userId") Long studentId,
                                         @PathVariable("quizId") Long quizId,
                                         @SessionAttribute(value = CURRENT_QUIZ, required = false)
                                                 Quiz quiz,
                                         @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                                 Integer currentQuestionSerial,
                                         @SessionAttribute(value = QUESTIONS, required = false)
                                                 List<Question> questions,
                                         @SessionAttribute(value = START_TIME, required = false)
                                                 LocalDateTime startTime,
                                         HttpSession session, ModelMap model) {

        Question currentQuestion = questions.get(currentQuestionSerial);
        QuestionType currentQuestionType = currentQuestion.getQuestionType();
        Long currentQuestionId = currentQuestion.getQuestionId();

        setAnswers(currentQuestionType, currentQuestionId, session, model);

        if (quiz.getPassingTime() != null) {
            LocalDateTime currentTime = LocalDateTime.now();
            Duration studentPassingTime = Duration.between(startTime, currentTime);
            Duration passingTime = quiz.getPassingTime();
            if (studentPassingTime.compareTo(passingTime) > 0) {
                model.clear();
                return "redirect:/quizzes/" + quizId + "/time-up";
            }
            Duration timeLeft = passingTime.minus(studentPassingTime);
            session.setAttribute(TIME_LEFT, timeLeft);
        }

        return "quiz_passing/question";
    }

    @SuppressWarnings("Duplicates")
    @RequestMapping(value = "/quizzes/{quizId}/passing", method = RequestMethod.POST)
    public String showCurrentQuestionPost(@ModelAttribute("userId") Long studentId,
                                          @RequestParam Map<String, String> studentAnswers,
                                          @PathVariable("quizId") Long quizId,
                                          @SessionAttribute(CURRENT_QUIZ) Quiz quiz,
                                          @SessionAttribute(CURRENT_QUESTION_SERIAL)
                                                  Integer currentQuestionSerial,
                                          @SessionAttribute(QUESTIONS) List<Question> questions,
                                          @SessionAttribute(RESULT) Double result,
                                          @SessionAttribute(START_TIME) LocalDateTime startTime,
                                          HttpSession session, ModelMap model) {
        session.setAttribute(CURRENT_QUESTION_SERIAL, ++currentQuestionSerial);

        if (quiz.getPassingTime() != null) {
            LocalDateTime currentTime = LocalDateTime.now();
            Duration studentPassingTime = Duration.between(startTime, currentTime);
            Duration passingTime = quiz.getPassingTime();
            if (studentPassingTime.compareTo(passingTime) > 0) {
                model.clear();
                return "redirect:/quizzes/" + quizId + "/time-up";
            }
            Duration timeLeft = passingTime.minus(studentPassingTime);
            session.setAttribute(TIME_LEFT, timeLeft);
        }

        Question prevQuestion = questions.get(currentQuestionSerial - 1);
        QuestionType prevQuestionType = prevQuestion.getQuestionType();
        Integer prevQuestionScore = prevQuestion.getScore();
        Long prevQuestionId = prevQuestion.getQuestionId();

        logger.info("Student answers map: " + studentAnswers);

        switch (prevQuestionType) {
            case ONE_ANSWER:
                boolean oneAnswer = Boolean.valueOf(studentAnswers.get("oneAnswer"));
                if (oneAnswer) {
                    result += prevQuestionScore;
                    session.setAttribute(RESULT, result);
                }
                break;
            case FEW_ANSWERS:
                List<AnswerSimple> fewAnswers = answerSimpleDao.findAnswersSimple(prevQuestionId);
                long countOfCorrect = fewAnswers.stream()
                        .filter(AnswerSimple::isCorrect)
                        .count();
                Collection<String> answers = studentAnswers.values();
                if (answers.size() <= countOfCorrect) {
                    for (String answer : answers) {
                        if (answer.equals("true")) {
                            result += prevQuestionScore / countOfCorrect;
                        }
                    }
                    session.setAttribute(RESULT, result);
                }
                break;
            case ACCORDANCE:
                // This cast is correct because the array we're creating
                // is of the same type as the one passed in, which is List<String>
                @SuppressWarnings("unchecked")
                List<String> rightSide = (List<String>) session.getAttribute(ACCORDANCE_LIST);
                for (int i = 0; i < 4; i++) {
                    String answer = studentAnswers.get("accordance" + i);
                    if (answer != null && answer.equals(rightSide.get(i))) {
                        result += ((double) prevQuestionScore) / 4;
                    }
                }
                session.setAttribute(RESULT, result);
                session.removeAttribute(ACCORDANCE_LIST);
                break;
            case SEQUENCE:
                AnswerSequence answerSequence = answerSequenceDao.findAnswerSequence(prevQuestionId);
                List<String> correctList = answerSequence.getCorrectList();
                logger.info("get session attribute SEQUENCE_LIST: " + correctList);
                for (int i = 0; i < 4; i++) {
                    String answer = studentAnswers.get("sequence" + i);
                    if (answer != null && answer.equals(correctList.get(i))) {
                        result += ((double) prevQuestionScore) / 4;
                    }
                }
                session.setAttribute(RESULT, result);
                break;
            case NUMBER:
                AnswerNumber answerNumber =
                        answerNumberDao.findAnswerNumber(prevQuestionId);
                String correct = answerNumber.getCorrect().toString();
                String answer = studentAnswers.get("number");
                if (answer != null && answer.equals(correct)) {
                    result += prevQuestionScore;
                    session.setAttribute(RESULT, result);
                }
                break;
        }

        if (currentQuestionSerial == questions.size()) {
            model.clear();
            return "redirect:/quizzes/" + quizId + "/congratulations";
        }

        Question question = questions.get(currentQuestionSerial);
        QuestionType questionType = question.getQuestionType();
        Long questionId = question.getQuestionId();

        setAnswers(questionType, questionId, session, model);

        session.setAttribute(CURRENT_QUESTION_SERIAL, currentQuestionSerial);

        return "quiz_passing/question";
    }

    @RequestMapping("/quizzes/{quizId}/continue")
    public String continuePassing(@PathVariable("quizId") Long quizId) {
        return "quiz_passing/continue";
    }

    @RequestMapping("/quizzes/{quizId}/time-up")
    public String showTimeUp(@AuthenticationPrincipal SecurityUser securityUser,
                             @ModelAttribute("userId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             @SessionAttribute(value = RESULT, required = false)
                                     Double result,
                             @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                     Integer currentQuestionSerial,
                             @SessionAttribute(value = TIME_LEFT, required = false) Duration timeLeft,
                             HttpSession session, Model model) {
        showResult(securityUser, studentId, quizId, result,
                currentQuestionSerial, timeLeft, session, model);
        return "quiz_passing/time-up";
    }

    @RequestMapping("/quizzes/{quizId}/congratulations")
    public String showResult(@AuthenticationPrincipal SecurityUser securityUser,
                             @ModelAttribute("userId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             @SessionAttribute(value = RESULT, required = false) Double result,
                             @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                     Integer currentQuestionSerial,
                             @SessionAttribute(value = TIME_LEFT, required = false) Duration timeLeft,
                             HttpSession session, Model model) {
        List<String> userRoles = securityUser.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
        if (userRoles.contains("ROLE_STUDENT")) {
            if (result == null) {
                PassedQuiz quiz = quizDao.findPassedQuiz(studentId, quizId);
                model.addAttribute("quiz", quiz);
                return "quiz_passing/congratulations";
            }
            // Check if teacher close quiz while student is passing it
            if (!quizDao.findStudentQuizStatus(studentId, quizId).equals(CLOSED)) {
                Integer attempt = quizDao.findAttempt(studentId, quizId);
                Integer roundedResult = roundOff(result * (1 - 0.1 * attempt));
                attempt++;
                LocalDateTime finishDate = LocalDateTime.now();
                quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                        finishDate, attempt, PASSED);
            }
            PassedQuiz quiz = quizDao.findPassedQuiz(studentId, quizId);
            model.addAttribute("quiz", quiz);
            model.addAttribute("currentQuestionSerial", currentQuestionSerial);
        } else if (userRoles.contains("ROLE_TEACHER")) {
            if (result == null) {
                model.addAttribute("quizId", quizId);
                return "quiz_passing/just-passed";
            }
            Integer roundedResult = roundOff(result);
            LocalDateTime finishDate = LocalDateTime.now();
            Quiz quiz = quizDao.findQuiz(quizId);
            PassedQuiz passedQuiz = new PassedQuiz.PassedQuizBuilder()
                    .quizId(quiz.getQuizId())
                    .quizName(quiz.getName())
                    .description(quiz.getDescription())
                    .explanation(quiz.getExplanation())
                    .result(roundedResult)
                    .score(quiz.getScore())
                    .questionsNumber(quiz.getQuestionsNumber())
                    .attempt(1)
                    .passingTime(quiz.getPassingTime())
                    .finishDate(finishDate)
                    .timeSpent(quiz.getPassingTime().minus(timeLeft))
                    .build();
            model.addAttribute("quiz", passedQuiz);
            model.addAttribute("currentQuestionSerial", currentQuestionSerial);
        }
        session.removeAttribute(RESULT);
        session.removeAttribute(QUESTIONS);
        session.removeAttribute(QUESTIONS_NUMBER);
        session.removeAttribute(CURRENT_QUIZ);
        session.removeAttribute(CURRENT_QUESTION_SERIAL);
        session.removeAttribute(TIME_LEFT);

        return "quiz_passing/congratulations";
    }

    //    INTERNALS===================================================================

    private void setAnswers(QuestionType questionType, Long questionId, HttpSession session, ModelMap model) {
        switch (questionType) {
            case ONE_ANSWER:
                List<AnswerSimple> oneAnswer = answerSimpleDao.findAnswersSimple(questionId);
                model.addAttribute("answers", oneAnswer);
                break;
            case FEW_ANSWERS:
                List<AnswerSimple> fewAnswers = answerSimpleDao.findAnswersSimple(questionId);
                model.addAttribute("answers", fewAnswers);
                break;
            case ACCORDANCE:
                AnswerAccordance answerAccordance = answerAccordanceDao.findAnswerAccordance(questionId);
                int seed = new Random().nextInt();
                Collections.shuffle(answerAccordance.getLeftSide(), new Random(seed));
                Collections.shuffle(answerAccordance.getRightSide(), new Random(seed));
                List<String> originRightSide = new ArrayList<>(answerAccordance.getRightSide());
                session.setAttribute(ACCORDANCE_LIST, originRightSide);
                Collections.shuffle(answerAccordance.getRightSide());
                model.addAttribute("answers", answerAccordance);
                break;
            case SEQUENCE:
                AnswerSequence answerSequence = answerSequenceDao.findAnswerSequence(questionId);
                Collections.shuffle(answerSequence.getCorrectList());
                model.addAttribute("answers", answerSequence);
                break;
            case NUMBER:
                AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(questionId);
                model.addAttribute("answers", answerNumber);
                break;
        }
    }
}
