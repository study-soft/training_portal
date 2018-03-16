package com.company.training_portal.controller;

import com.company.training_portal.dao.*;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.QuestionType;
import com.company.training_portal.model.enums.StudentQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

import static com.company.training_portal.controller.SessionAttributes.*;
import static com.company.training_portal.controller.SessionAttributes.QUESTIONS_NUMBER;
import static com.company.training_portal.model.enums.QuestionType.*;

@Controller
public class QuizController {

    private QuizDao quizDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;

    private Logger logger = Logger.getLogger(QuizController.class);

    @Autowired
    public QuizController(QuizDao quizDao,
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

    @ModelAttribute("studentId")
    public Long getStudentId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/start", method = RequestMethod.GET)
    public String showQuizStart(@ModelAttribute("studentId") Long studentId,
                                @PathVariable("quizId") Long quizId,
                                @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                        Integer currentQuestionSerial,
                                ModelMap model) {
        if (currentQuestionSerial != null) {
            model.clear();
            return "redirect:/student/quizzes/continue";
        }
        OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(studentId, quizId);
        model.addAttribute("openedQuiz", openedQuiz);
        return "start-quiz";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/initialize", method = RequestMethod.GET)
    public String initializeQuiz(@ModelAttribute("studentId") Long studentId,
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

        LocalDateTime startDate = LocalDateTime.now();
        quizDao.editStartDate(startDate, studentId, quizId);

        model.clear();

        return "redirect:/student/quizzes/" + quizId + "/passing";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/passing", method = RequestMethod.GET)
    public String showCurrentQuestionGet(@ModelAttribute("studentId") Long studentId,
                                         @PathVariable("quizId") Long quizId,
                                         @SessionAttribute(CURRENT_QUESTION_SERIAL)
                                                 Integer currentQuestionSerial,
                                         @SessionAttribute(QUESTIONS) List<Question> questions,
                                         HttpSession session, ModelMap model) {

        Question currentQuestion = questions.get(currentQuestionSerial);
        QuestionType currentQuestionType = currentQuestion.getQuestionType();
        Long currentQuestionId = currentQuestion.getQuestionId();

        setAnswers(currentQuestionType, currentQuestionId, session, model);

        return "question";
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/student/quizzes/{quizId}/passing", method = RequestMethod.POST)
    public String showCurrentQuestionPost(@ModelAttribute("studentId") Long studentId,
                                          @RequestParam Map<String, String> studentAnswers,
                                          @PathVariable("quizId") Long quizId,
                                          @SessionAttribute(CURRENT_QUIZ) Quiz quiz,
                                          @SessionAttribute(CURRENT_QUESTION_SERIAL)
                                                  Integer currentQuestionSerial,
                                          @SessionAttribute(QUESTIONS) List<Question> questions,
                                          @SessionAttribute(RESULT) Double result,
                                          HttpSession session, ModelMap model) {
        session.setAttribute(CURRENT_QUESTION_SERIAL, ++currentQuestionSerial);

        LocalDateTime startTime = quizDao.findStartDate(studentId, quizId);
        LocalDateTime currentTime = LocalDateTime.now();
        Duration studentPassingTime = Duration.between(startTime, currentTime);
        Duration passingTime = quiz.getPassingTime();
        if (studentPassingTime.compareTo(passingTime) > 0) {
            model.clear();
            return "redirect:/student/quizzes/" + quizId + "/time-up";
        }
        Duration timeLeft = passingTime.minus(studentPassingTime);
        session.setAttribute(TIME_LEFT, timeLeft);

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
                List<String> rightSide = (List<String>) session.getAttribute(ACCORDANCE_LIST);
                for (int i = 0; i < 4; i++) {
                    if (studentAnswers.get("accordance" + i).equals(rightSide.get(i))) {
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
                    if (studentAnswers.get("sequence" + i).equals(correctList.get(i))) {
                        result += ((double) prevQuestionScore) / 4;
                    }
                }
                session.setAttribute(RESULT, result);
                break;
            case NUMBER:
                AnswerNumber answerNumber =
                        answerNumberDao.findAnswerNumber(prevQuestionId);
                String correct = answerNumber.getCorrect().toString();
                if (studentAnswers.get("number").equals(correct)) {
                    result += prevQuestionScore;
                    session.setAttribute(RESULT, result);
                }
                break;
        }

        if (currentQuestionSerial == questions.size()) {
            model.clear();
            return "redirect:/student/quizzes/" + quizId + "/congratulations";
        }

        Question question = questions.get(currentQuestionSerial);
        QuestionType questionType = question.getQuestionType();
        Long questionId = question.getQuestionId();

        setAnswers(questionType, questionId, session, model);

        session.setAttribute(CURRENT_QUESTION_SERIAL, currentQuestionSerial);

        return "question";
    }

    @RequestMapping("/student/quizzes/continue")
    public String continuePassing(Model model) {
        return "quiz-continue";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/repass", method = RequestMethod.GET)
    public String showQuizRepass(@ModelAttribute("studentId") Long studentId,
                                 @PathVariable("quizId") Long quizId,
                                 @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                         Integer currentQuestionSerial,
                                 ModelMap model) {
        if (currentQuestionSerial != null) {
            model.clear();
            return "redirect:/student/quizzes/continue";
        }
        PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
        model.addAttribute("passedQuiz", passedQuiz);
        return "repass-quiz";
    }

    @RequestMapping("/student/quizzes/{quizId}/time-up")
    public String showTimeUp(@ModelAttribute("studentId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             @SessionAttribute(RESULT) Double result,
                             @SessionAttribute(CURRENT_QUESTION_SERIAL) Integer currentQuestionSerial,
                             HttpSession session, Model model) {
        showResult(studentId, quizId, result, currentQuestionSerial, session, model);
        return "time-up";
    }

    @RequestMapping("/student/quizzes/{quizId}/congratulations")
    public String showResult(@ModelAttribute("studentId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             @SessionAttribute(RESULT) Double result,
                             @SessionAttribute(CURRENT_QUESTION_SERIAL) Integer currentQuestionSerial,
                             HttpSession session, Model model) {
        Integer roundedResult = roundOff(result);
        Integer attempt = quizDao.findAttempt(studentId, quizId) + 1;
        LocalDateTime finishDate = LocalDateTime.now();
        quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                finishDate, attempt, StudentQuizStatus.PASSED);
        PassedQuiz quiz = quizDao.findPassedQuiz(studentId, quizId);
        model.addAttribute("quiz", quiz);
        model.addAttribute("currentQuestionSerial", currentQuestionSerial);
        session.removeAttribute(RESULT);
        session.removeAttribute(QUESTIONS);
        session.removeAttribute(QUESTIONS_NUMBER);
        session.removeAttribute(CURRENT_QUIZ);
        session.removeAttribute(CURRENT_QUESTION_SERIAL);
        session.removeAttribute(TIME_LEFT);
        return "quiz-congratulations";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/answers", method = RequestMethod.GET)
    public String showAnswers(@PathVariable("quizId") Long quizId, Model model) {
        List<Question> questionsOneAnswer = questionDao.findQuestions(quizId, ONE_ANSWER);
        List<Question> questionsFewAnswers = questionDao.findQuestions(quizId, FEW_ANSWERS);
        List<Question> questionsAccordance = questionDao.findQuestions(quizId, ACCORDANCE);
        List<Question> questionsSequence = questionDao.findQuestions(quizId, SEQUENCE);
        List<Question> questionsNumber = questionDao.findQuestions(quizId, QuestionType.NUMBER);
        model.addAttribute("questionsOneAnswer", questionsOneAnswer);
        model.addAttribute("questionsFewAnswers", questionsFewAnswers);
        model.addAttribute("questionsAccordance", questionsAccordance);
        model.addAttribute("questionsSequence", questionsSequence);
        model.addAttribute("questionsNumber", questionsNumber);

        Map<Long, List<AnswerSimple>> quizAnswersSimple = new HashMap<>();
        Map<Long, AnswerAccordance> quizAnswersAccordance = new HashMap<>();
        Map<Long, AnswerSequence> quizAnswersSequence = new HashMap<>();
        Map<Long, AnswerNumber> quizAnswersNumber = new HashMap<>();
        List<Question> tests = new ArrayList<>();
        tests.addAll(questionsOneAnswer);
        tests.addAll(questionsFewAnswers);
        for (Question question : tests) {
            Long questionId = question.getQuestionId();
            List<AnswerSimple> answersSimple = answerSimpleDao.findAnswersSimple(questionId);
            quizAnswersSimple.put(questionId, answersSimple);
        }
        for (Question question : questionsAccordance) {
            Long questionId = question.getQuestionId();
            AnswerAccordance answerAccordance = answerAccordanceDao.findAnswerAccordance(questionId);
            quizAnswersAccordance.put(questionId, answerAccordance);
        }
        for (Question question : questionsSequence) {
            Long questionId = question.getQuestionId();
            AnswerSequence answerSequence = answerSequenceDao.findAnswerSequence(questionId);
            quizAnswersSequence.put(questionId, answerSequence);
        }
        for (Question question : questionsNumber) {
            Long questionId = question.getQuestionId();
            AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(questionId);
            quizAnswersNumber.put(questionId, answerNumber);
        }

        model.addAttribute("quizAnswersSimple", quizAnswersSimple);
        model.addAttribute("quizAnswersAccordance", quizAnswersAccordance);
        model.addAttribute("quizAnswersSequence", quizAnswersSequence);
        model.addAttribute("quizAnswersNumber", quizAnswersNumber);

        return "answers";
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
                session.setAttribute(ACCORDANCE_LIST, answerAccordance.getRightSide());
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

    private int roundOff(double value) {
        return (value * 10) % 10 >= 5 ? (int) value + 1 : (int) value;
    }
}
