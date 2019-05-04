package com.studysoft.trainingportal.controller;

import com.studysoft.trainingportal.dao.*;
import com.studysoft.trainingportal.model.*;
import com.studysoft.trainingportal.model.enums.QuestionType;
import com.studysoft.trainingportal.model.enums.StudentQuizStatus;
import com.studysoft.trainingportal.util.Utils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
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

    /**
     * Попередня ініціалізація вікторини. Проводиться перемішування питань, установлюється дата старту,
     * а також зберігається інформація про вікторину у HTTP-сесію, для того, щоб не робити додаткових запитів
     * до БД під час проходження вікторини
     *
     * @param securityUser об'єкт, що містить інформацію про користувача, авторизованого в системі
     * @param studentId    ID авторизованого користувача у HTTP-сесії
     * @param quizId       ID вікторини, яку збирається пройти користувач
     * @param session      інтерфейс для роботи з HTTP-сесією
     * @param model        інтерфейс для додавання атрибутів до моделі на UI
     * @return проводить перенапрямлення HTTP-запиту на /quizzes/{quizID}/passing для проходження вікторини
     */
    @RequestMapping(value = "/quizzes/{quizId}/initialize", method = RequestMethod.GET)
    public String initializeQuiz(@AuthenticationPrincipal SecurityUser securityUser,
                                 @ModelAttribute("userId") Long studentId,
                                 @PathVariable("quizId") Long quizId,
                                 HttpSession session,
                                 ModelMap model) {
        List<Question> questionsOneAnswer = questionDao.findQuestions(quizId, QuestionType.ONE_ANSWER);
        List<Question> questionsFewAnswers = questionDao.findQuestions(quizId, QuestionType.FEW_ANSWERS);
        List<Question> questionsAccordance = questionDao.findQuestions(quizId, QuestionType.ACCORDANCE);
        List<Question> questionsSequence = questionDao.findQuestions(quizId, QuestionType.SEQUENCE);
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

        session.setAttribute(SessionAttributes.CURRENT_QUIZ, quizDao.findQuiz(quizId));
        session.setAttribute(SessionAttributes.QUESTIONS, questions);
        session.setAttribute(SessionAttributes.RESULT, 0D);
        session.setAttribute(SessionAttributes.QUESTIONS_NUMBER, questions.size());
        session.setAttribute(SessionAttributes.CURRENT_QUESTION_SERIAL, 0);
        LocalDateTime startDate = LocalDateTime.now();
        session.setAttribute(SessionAttributes.START_DATE, startDate);

        List<String> userRoles = securityUser.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
        if (userRoles.contains("ROLE_STUDENT")) {
            quizDao.editStartDate(startDate, studentId, quizId);
        }

        model.clear();

        return "redirect:/quizzes/" + quizId + "/passing";
    }

    /**
     * Ініціалізація першого питання та перевірка часу відведеного на проходження вікторини
     *
     * @param studentId             ID авторизованого користувача у HTTP-сесії
     * @param quizId                ID вікторини, яку проходить користувач
     * @param quiz                  вікторина, яку проходить користувач, зберігається у HTTP-сесії
     * @param currentQuestionSerial порядковий номер поточного питання, зберігається у HTTP-сесії
     * @param questions             питання вікторини, зберігаються у HTTP-сесії
     * @param startDate             дата початку проходження вікторини, зберігається у HTTP-сесії
     * @param session               інтерфейс для роботи з HTTP-сесією
     * @param model                 інтерфейс для додавання атрибутів до моделі на UI
     * @return quiz_passing/question.jsp або перенапрямлення HTTP-запиту на /quizzes/{quizId}/time-up,
     * якщо сплинув час, відведений на проходження вікторини
     */
    @SuppressWarnings("Duplicates")
    @RequestMapping(value = "/quizzes/{quizId}/passing", method = RequestMethod.GET)
    public String showCurrentQuestionGet(@ModelAttribute("userId") Long studentId,
                                         @PathVariable("quizId") Long quizId,
                                         @SessionAttribute(value = SessionAttributes.CURRENT_QUIZ, required = false)
                                                 Quiz quiz,
                                         @SessionAttribute(value = SessionAttributes.CURRENT_QUESTION_SERIAL, required = false)
                                                 Integer currentQuestionSerial,
                                         @SessionAttribute(value = SessionAttributes.QUESTIONS, required = false)
                                                 List<Question> questions,
                                         @SessionAttribute(value = SessionAttributes.START_DATE, required = false)
                                                 LocalDateTime startDate,
                                         HttpSession session, ModelMap model) {
        if (questions == null) {
            throw new EmptyResultDataAccessException(1);
        }

        Question currentQuestion = questions.get(currentQuestionSerial);
        QuestionType currentQuestionType = currentQuestion.getQuestionType();
        Long currentQuestionId = currentQuestion.getQuestionId();

        setAnswers(currentQuestionType, currentQuestionId, session, model);

        if (quiz.getPassingTime() != null) {
            LocalDateTime currentTime = LocalDateTime.now();
            Duration studentPassingTime = Duration.between(startDate, currentTime);
            Duration passingTime = quiz.getPassingTime();
            if (studentPassingTime.compareTo(passingTime) > 0) {
                model.clear();
                return "redirect:/quizzes/" + quizId + "/time-up";
            }
            Duration timeLeft = passingTime.minus(studentPassingTime);
            session.setAttribute(SessionAttributes.TIME_LEFT, timeLeft);
        }

        return "quiz_passing/question";
    }

    /**
     * Ініціалізація поточного питання вікторини та обробка результатів попереднього питання в залежності
     * від його типу. Також проводиться перевірка часу відведеного на проходження вікторини
     *
     * @param studentId             ID авторизованого користувача у HTTP-сесії
     * @param studentAnswers        відповідь користувача на попереднє питання
     * @param quizId                ID вікторини, яку проходить користувач
     * @param quiz                  вікторина, яку проходить користувач, зберігається у HTTP-сесії
     * @param currentQuestionSerial порядковий номер поточного питання, зберігається у HTTP-сесії
     * @param questions             питання вікторини, зберігаються у HTTP-сесії
     * @param result                поточний результат вікторини, яку проходить користувач, зберігається у HTTP-сесії
     * @param startDate             дата початку проходження вікторини, зберігається у HTTP-сесії
     * @param session               інтерфейс для роботи з HTTP-сесією
     * @param model                 інтерфейс для додавання атрибутів до моделі на UI
     * @return quiz_passing/question.jsp або перенапрямлення HTTP-запиту на /quizzes/{quizId}/time-up,
     * якщо сплинув час, відведений на проходження вікторини
     */
    @SuppressWarnings("Duplicates")
    @RequestMapping(value = "/quizzes/{quizId}/passing", method = RequestMethod.POST)
    public String showCurrentQuestionPost(@ModelAttribute("userId") Long studentId,
                                          @RequestParam Map<String, String> studentAnswers,
                                          @PathVariable("quizId") Long quizId,
                                          @SessionAttribute(SessionAttributes.CURRENT_QUIZ) Quiz quiz,
                                          @SessionAttribute(SessionAttributes.CURRENT_QUESTION_SERIAL)
                                                  Integer currentQuestionSerial,
                                          @SessionAttribute(SessionAttributes.QUESTIONS) List<Question> questions,
                                          @SessionAttribute(SessionAttributes.RESULT) Double result,
                                          @SessionAttribute(SessionAttributes.START_DATE) LocalDateTime startDate,
                                          HttpSession session, ModelMap model) {
        session.setAttribute(SessionAttributes.CURRENT_QUESTION_SERIAL, ++currentQuestionSerial);

        /**
         * Check whether time is up
         */
        if (quiz.getPassingTime() != null) {
            LocalDateTime currentTime = LocalDateTime.now();
            Duration studentPassingTime = Duration.between(startDate, currentTime);
            Duration passingTime = quiz.getPassingTime();
            if (studentPassingTime.compareTo(passingTime) > 0) {
                model.clear();
                return "redirect:/quizzes/" + quizId + "/time-up";
            }
            Duration timeLeft = passingTime.minus(studentPassingTime);
            session.setAttribute(SessionAttributes.TIME_LEFT, timeLeft);
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
                    session.setAttribute(SessionAttributes.RESULT, result);
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
                            result += ((double) prevQuestionScore) / countOfCorrect;
                        }
                    }
                    session.setAttribute(SessionAttributes.RESULT, result);
                }
                break;
            case ACCORDANCE:
                @SuppressWarnings("unchecked")
                List<String> rightSide = (List<String>) session.getAttribute(SessionAttributes.ACCORDANCE_LIST);
                logger.info(">>> rightSide from session: " + rightSide);
                for (int i = 0; i < 4; i++) {
                    String answer = studentAnswers.get("accordance" + i);
                    if (answer != null && answer.equals(rightSide.get(i))) {
                        result += ((double) prevQuestionScore) / 4;
                    }
                }
                session.setAttribute(SessionAttributes.RESULT, result);
                session.removeAttribute(SessionAttributes.ACCORDANCE_LIST);
                break;
            case SEQUENCE:
                AnswerSequence answerSequence = answerSequenceDao.findAnswerSequence(prevQuestionId);
                List<String> correctList = answerSequence.getCorrectList();
                logger.info(">>> correctList: " + correctList);
                for (int i = 0; i < 4; i++) {
                    String answer = studentAnswers.get("sequence" + i);
                    if (answer != null && answer.equals(correctList.get(i))) {
                        result += ((double) prevQuestionScore) / 4;
                    }
                }
                session.setAttribute(SessionAttributes.RESULT, result);
                break;
            case NUMBER:
                AnswerNumber answerNumber =
                        answerNumberDao.findAnswerNumber(prevQuestionId);
                String correct = answerNumber.getCorrect().toString();
                String answer = studentAnswers.get("number");
                if (answer != null && answer.equals(correct)) {
                    result += prevQuestionScore;
                    session.setAttribute(SessionAttributes.RESULT, result);
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

        session.setAttribute(SessionAttributes.CURRENT_QUESTION_SERIAL, currentQuestionSerial);

        return "quiz_passing/question";
    }

    /**
     * Обробка дій користувача, якщо він намагається пройти іншу вікторину, не закінчивши першу
     *
     * @param quizId ID поточної вікторини, яку проходить користувач
     * @return quiz_passing/continue.jsp
     */
    @RequestMapping(value = "/quizzes/{quizId}/continue", method = RequestMethod.GET)
    public String continuePassing(@PathVariable("quizId") Long quizId) {
        return "quiz_passing/continue";
    }

    /**
     * Обробка результату, якщо сплив час, відведений на проходження вікторини. Збереження результату до БД,
     * інкремент спроби на одиницю та відображення сторінки вітань з результатами
     *
     * @param securityUser          об'єкт, що містить інформацію про користувача, авторизованого в системі
     * @param studentId             ID авторизованого користувача у HTTP-сесії
     * @param quizId                ID вікторини, яку проходить користувач
     * @param result                поточний результат вікторини, яку проходить користувач, зберігається у HTTP-сесії
     * @param currentQuestionSerial порядковий номер поточного питання, зберігається у HTTP-сесії
     * @param timeLeft              час, який залишився для проходження вікторини, зберігається у HTTP-сесії
     * @param startDate             дата початку проходження вікторини, зберігається у HTTP-сесії
     * @param session               інтерфейс для роботи з HTTP-сесією
     * @param model                 інтерфейс для додавання атрибутів до моделі на UI
     * @return quiz_passing/time-up.jsp
     */
    @RequestMapping(value = "/quizzes/{quizId}/time-up", method = RequestMethod.GET)
    public String showTimeUp(@AuthenticationPrincipal SecurityUser securityUser,
                             @ModelAttribute("userId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             @SessionAttribute(value = SessionAttributes.RESULT, required = false)
                                     Double result,
                             @SessionAttribute(value = SessionAttributes.CURRENT_QUESTION_SERIAL, required = false)
                                     Integer currentQuestionSerial,
                             @SessionAttribute(value = SessionAttributes.TIME_LEFT, required = false) Duration timeLeft,
                             @SessionAttribute(value = SessionAttributes.START_DATE, required = false) LocalDateTime startDate,
                             HttpSession session, Model model) {
        showResult(securityUser, studentId, quizId, result,
                currentQuestionSerial, timeLeft, startDate, session, model);
        return "quiz_passing/time-up";
    }

    /**
     * Обробка результату при успішному проходженні вікторини. Збереження результату до БД,
     * інкремент спроби на одиницю та відображення сторінки вітань з результатами
     *
     * @param securityUser          об'єкт, що містить інформацію про користувача, авторизованого в системі
     * @param studentId             ID авторизованого користувача у HTTP-сесії
     * @param quizId                ID вікторини, яку проходить користувач
     * @param result                поточний результат вікторини, яку проходить користувач, зберігається у HTTP-сесії
     * @param currentQuestionSerial порядковий номер поточного питання, зберігається у HTTP-сесії
     * @param timeLeft              час, який залишився для проходження вікторини, зберігається у HTTP-сесії
     * @param startDate             дата початку проходження вікторини, зберігається у HTTP-сесії
     * @param session               інтерфейс для роботи з HTTP-сесією
     * @param model                 інтерфейс для додавання атрибутів до моделі на UI
     * @return quiz_passing/congratulations.jsp
     */
    @RequestMapping(value = "/quizzes/{quizId}/congratulations", method = RequestMethod.GET)
    public String showResult(@AuthenticationPrincipal SecurityUser securityUser,
                             @ModelAttribute("userId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             @SessionAttribute(value = SessionAttributes.RESULT, required = false) Double result,
                             @SessionAttribute(value = SessionAttributes.CURRENT_QUESTION_SERIAL, required = false)
                                     Integer currentQuestionSerial,
                             @SessionAttribute(value = SessionAttributes.TIME_LEFT, required = false) Duration timeLeft,
                             @SessionAttribute(value = SessionAttributes.START_DATE, required = false) LocalDateTime startDate,
                             HttpSession session, Model model) {
        List<String> userRoles = securityUser.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
        if (userRoles.contains("ROLE_STUDENT")) {
            StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
            if (result == null) {
                PassedQuiz quiz;
                try {
                    quiz = quizDao.findPassedQuiz(studentId, quizId);
                } catch (EmptyResultDataAccessException e) {
                    quiz = quizDao.findClosedQuiz(studentId, quizId);
                }
                model.addAttribute("quiz", quiz);
                model.addAttribute("status", status);
                return "quiz_passing/congratulations";
            }
            if (!status.equals(StudentQuizStatus.CLOSED)) {   // Check if teacher close quiz while student is passing it
                Integer attempt = quizDao.findAttempt(studentId, quizId);
                Integer roundedResult = Utils.roundOff(result * (1 - 0.1 * attempt));
                attempt++;
                LocalDateTime finishDate = LocalDateTime.now();
                quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                        finishDate, attempt, StudentQuizStatus.PASSED);
            }
            PassedQuiz quiz = quizDao.findPassedQuiz(studentId, quizId);
            model.addAttribute("quiz", quiz);
            model.addAttribute("currentQuestionSerial", currentQuestionSerial);
        } else if (userRoles.contains("ROLE_TEACHER")) {
            if (result == null) {
                model.addAttribute("quizId", quizId);
                return "quiz_passing/just-passed";
            }
            Integer roundedResult = Utils.roundOff(result);
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
                    .timeSpent(Duration.between(startDate, finishDate))
                    .build();
            model.addAttribute("quiz", passedQuiz);
            model.addAttribute("currentQuestionSerial", currentQuestionSerial);
        }
        session.removeAttribute(SessionAttributes.RESULT);
        session.removeAttribute(SessionAttributes.QUESTIONS);
        session.removeAttribute(SessionAttributes.QUESTIONS_NUMBER);
        session.removeAttribute(SessionAttributes.CURRENT_QUIZ);
        session.removeAttribute(SessionAttributes.CURRENT_QUESTION_SERIAL);
        session.removeAttribute(SessionAttributes.TIME_LEFT);
        session.removeAttribute(SessionAttributes.START_DATE);

        return "quiz_passing/congratulations";
    }

    //    INTERNALS===================================================================

    private void setAnswers(QuestionType questionType, Long questionId, HttpSession session, ModelMap model) {
        switch (questionType) {
            case ONE_ANSWER:
                List<AnswerSimple> oneAnswer = answerSimpleDao.findAnswersSimple(questionId);
                Collections.shuffle(oneAnswer);
                model.addAttribute("answers", oneAnswer);
                break;
            case FEW_ANSWERS:
                List<AnswerSimple> fewAnswers = answerSimpleDao.findAnswersSimple(questionId);
                Collections.shuffle(fewAnswers);
                model.addAttribute("answers", fewAnswers);
                break;
            case ACCORDANCE:
                AnswerAccordance answerAccordance = answerAccordanceDao.findAnswerAccordance(questionId);
                int seed = new Random().nextInt();
                Collections.shuffle(answerAccordance.getLeftSide(), new Random(seed));
                Collections.shuffle(answerAccordance.getRightSide(), new Random(seed));
                List<String> originRightSide = new ArrayList<>(answerAccordance.getRightSide());
                session.setAttribute(SessionAttributes.ACCORDANCE_LIST, originRightSide);
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
