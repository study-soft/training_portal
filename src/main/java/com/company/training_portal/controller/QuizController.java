package com.company.training_portal.controller;

import com.company.training_portal.dao.*;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.QuestionType;
import com.company.training_portal.validator.QuizValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.company.training_portal.controller.SessionAttributes.*;
import static com.company.training_portal.controller.SessionAttributes.QUESTIONS_NUMBER;
import static com.company.training_portal.model.enums.QuestionType.*;
import static com.company.training_portal.model.enums.StudentQuizStatus.PASSED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.UNPUBLISHED;
import static com.company.training_portal.util.Utils.roundOff;
import static com.company.training_portal.util.Utils.timeUnitsToDuration;

@Controller
public class QuizController {

    private QuizDao quizDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;
    private QuizValidator quizValidator;

    private Logger logger = Logger.getLogger(QuizController.class);

    @Autowired
    public QuizController(QuizDao quizDao,
                          QuestionDao questionDao,
                          AnswerSimpleDao answerSimpleDao,
                          AnswerAccordanceDao answerAccordanceDao,
                          AnswerSequenceDao answerSequenceDao,
                          AnswerNumberDao answerNumberDao,
                          QuizValidator quizValidator) {
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
        this.quizValidator = quizValidator;
    }

    @ModelAttribute("userId")
    public Long getUserId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    //    STUDENT ZONE===============================================================

    @RequestMapping(value = "/student/quizzes/{quizId}/start", method = RequestMethod.GET)
    public String showQuizStart(@ModelAttribute("userId") Long studentId,
                                @PathVariable("quizId") Long quizId,
                                @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                        Integer currentQuestionSerial,
                                ModelMap model) {
        if (currentQuestionSerial != null) {
            model.clear();
            return "redirect:/quizzes/" + quizId + "continue";
        }
        OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(studentId, quizId);
        model.addAttribute("openedQuiz", openedQuiz);
        return "student_quiz/start";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/repass", method = RequestMethod.GET)
    public String showQuizRepass(@ModelAttribute("userId") Long studentId,
                                 @PathVariable("quizId") Long quizId,
                                 @SessionAttribute(value = CURRENT_QUESTION_SERIAL, required = false)
                                         Integer currentQuestionSerial,
                                 ModelMap model) {
        if (currentQuestionSerial != null) {
            model.clear();
            return "redirect:/quizzes/continue";
        }
        PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
        model.addAttribute("passedQuiz", passedQuiz);
        return "student_quiz/repass";
    }

    @RequestMapping("/student/quizzes/{quizId}/answers")
    public String showAnswers(@PathVariable("quizId") Long quizId, ModelMap model) {
        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);
        Integer numberOfQuestions = questionDao.findQuestionsNumber(quizId);
        model.addAttribute("numberOfQuestions", numberOfQuestions);

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

        return "student_quiz/answers";
    }

    //    TEACHER ZONE===============================================================

    @RequestMapping("/teacher/quizzes/{quizId}/questions")
    public String showQuestions(@PathVariable("quizId") Long quizId, ModelMap model) {
        showAnswers(quizId, model);
        Quiz quiz = quizDao.findQuiz(quizId);
        if (quiz.getTeacherQuizStatus().equals(PUBLISHED)) {
            return "student_quiz/answers";
        }
        return "teacher_quiz/questions";
    }

    @RequestMapping(value = "/teacher/quizzes/create", method = RequestMethod.GET)
    public String showCreateQuiz(Model model) {
        model.addAttribute("quiz", new Quiz());
        return "teacher_quiz/quiz-create";
    }

    @RequestMapping(value = "/teacher/quizzes/create", method = RequestMethod.POST)
    public String createQuiz(@ModelAttribute("userId") Long teacherId,
                             @ModelAttribute("quiz") Quiz quiz,
                             @RequestParam(value = "enabled", required = false)
                                     String enabled,
                             @RequestParam(value = "hours", required = false)
                                     String hours,
                             @RequestParam(value = "minutes", required = false)
                                     String minutes,
                             @RequestParam(value = "seconds", required = false)
                                     String seconds,
                             BindingResult bindingResult, ModelMap model,
                             RedirectAttributes redirectAttributes) {
        quizValidator.validate(quiz, bindingResult);
        if (enabled != null) {
            quizValidator.validatePassingTime(hours, minutes, seconds, bindingResult);
        }

        if (quizDao.quizExistsByName(quiz.getName())) {
            bindingResult.rejectValue("name", "quiz.name.exists");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("hours", hours);
            model.addAttribute("minutes", minutes);
            model.addAttribute("seconds", seconds);
            return "teacher_quiz/quiz-create";
        }

        Duration passingTime = null;
        if (enabled != null) {
            passingTime = timeUnitsToDuration(
                    hours.isEmpty() ? 0 : Integer.valueOf(hours),
                    minutes.isEmpty() ? 0 : Integer.valueOf(minutes),
                    seconds.isEmpty() ? 0 : Integer.valueOf(seconds));
        }
        LocalDate creationDate = LocalDate.now();
        Quiz newQuiz = new Quiz.QuizBuilder()
                .name(quiz.getName())
                .description(quiz.getDescription().isEmpty() ? null : quiz.getDescription())
                .explanation(quiz.getExplanation().isEmpty() ? null : quiz.getExplanation())
                .creationDate(creationDate)
                .passingTime(passingTime)
                .authorId(teacherId)
                .questionsNumber(0)
                .score(0)
                .teacherQuizStatus(UNPUBLISHED)
                .build();

        Long newQuizId = quizDao.addQuiz(newQuiz);
        redirectAttributes.addFlashAttribute("createSuccess", true);
        model.clear();

        return "redirect:/teacher/quizzes/" + newQuizId;
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/delete", method = RequestMethod.POST)
    public String deleteQuiz(@PathVariable("quizId") Long quizId,
                             @RequestParam("deletedQuiz") String deletedQuiz,
                             RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("deletedQuiz", deletedQuiz);
        quizDao.deleteUnpublishedQuiz(quizId);
        return "redirect:/teacher/quizzes";
    }

    //    QUIZ PASSING ZONE===========================================================

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

    @SuppressWarnings({"unchecked", "Duplicates"})
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
            Integer attempt = quizDao.findAttempt(studentId, quizId);
            Integer roundedResult = roundOff(result * (1 - 0.1 * attempt));
            attempt++;
            LocalDateTime finishDate = LocalDateTime.now();
            quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                    finishDate, attempt, PASSED);
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
