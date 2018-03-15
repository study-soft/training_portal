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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.List;

import static com.company.training_portal.controller.SessionAttributes.*;
import static com.company.training_portal.model.enums.QuestionType.*;

@Controller
@SessionAttributes("studentId")
public class StudentController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;

    private static final Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    public StudentController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             QuestionDao questionDao,
                             AnswerSimpleDao answerSimpleDao,
                             AnswerAccordanceDao answerAccordanceDao,
                             AnswerSequenceDao answerSequenceDao,
                             AnswerNumberDao answerNumberDao) {
        this.userDao = userDao;
        this.groupDao = groupDao;
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

    @RequestMapping(value = "/student", method = RequestMethod.GET)
    public String showStudentHome(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        Group group = null;
        String authorName = null;
        if (student.getGroupId() != 0) {
            group = groupDao.findGroup(student.getGroupId());
            authorName = userDao.findUserName(group.getAuthorId());
        }

        model.addAttribute("student", student);
        model.addAttribute("authorName", authorName);
        model.addAttribute("group", group);

        return "student";
    }

    @RequestMapping(value = "/student/{studentId}", method = RequestMethod.GET)
    public String showStudentInfo(@PathVariable("studentId") Long studentId,
                                  Model model) {
        User student = userDao.findUser(studentId);
        model.addAttribute("student", student);

        Group group = groupDao.findGroup(student.getGroupId());
        model.addAttribute("group", group);

        List<OpenedQuiz> openedQuizzes = quizDao.findOpenedQuizzes(studentId);
        List<PassedQuiz> passedQuizzes = quizDao.findPassedQuizzes(studentId);
        List<PassedQuiz> finishedQuizzes = quizDao.findFinishedQuizzes(studentId);
        model.addAttribute("openedQuizzes", openedQuizzes);
        model.addAttribute("passedQuizzes", passedQuizzes);
        model.addAttribute("finishedQuizzes", finishedQuizzes);

        return "student-info";
    }

    @RequestMapping(value = "/student/group", method = RequestMethod.GET)
    public String showGroup(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();
        Group group = groupDao.findGroup(groupId);
        model.addAttribute("group", group);

        String authorName = userDao.findUserName(group.getAuthorId());
        model.addAttribute("authorName", authorName);

        Integer studentsNumber = groupDao.findStudentsNumberInGroup(groupId);
        model.addAttribute("studentsNumber", studentsNumber);

        List<User> students = userDao.findStudents(groupId);
        model.addAttribute("students", students);

        return "group";
    }

    @RequestMapping(value = "/student/teachers", method = RequestMethod.GET)
    public String showStudentTeachers(@ModelAttribute("studentId") Long studentId, Model model) {
        List<Quiz> quizzes = quizDao.findStudentQuizzes(studentId);
        HashSet<User> teachers = new HashSet<>();
        for (Quiz quiz : quizzes) {
            teachers.add(userDao.findUser(quiz.getAuthorId()));
        }

        model.addAttribute("teachers", teachers);

        return "student-teachers";
    }

    @RequestMapping(value = "/student/teachers/{teacherId}", method = RequestMethod.GET)
    public String showTeacherDetails(@ModelAttribute("studentId") Long studentId,
                                     @PathVariable("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        model.addAttribute("teacher", teacher);

        List<Quiz> quizzes =
                quizDao.findQuizzes(studentId, teacherId);
        model.addAttribute("quizzes", quizzes);

        List<StudentQuizStatus> statusList = new ArrayList<>();
        for (Quiz quiz : quizzes) {
            StudentQuizStatus status =
                    quizDao.findStudentQuizStatus(studentId, quiz.getQuizId());
            statusList.add(status);
        }
        model.addAttribute("statusList", statusList);

        return "teacher-info";
    }

    @RequestMapping(value = "/student/quizzes", method = RequestMethod.GET)
    public String showStudentQuizzes(@ModelAttribute("studentId") Long studentId, Model model) {
        List<OpenedQuiz> openedQuizzes
                = quizDao.findOpenedQuizzes(studentId);
        model.addAttribute("openedQuizzes", openedQuizzes);

        List<PassedQuiz> passedQuizzes
                = quizDao.findPassedQuizzes(studentId);
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> finishedQuizzes
                = quizDao.findFinishedQuizzes(studentId);
        model.addAttribute("finishedQuizzes", finishedQuizzes);

        return "student-quizzes";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}", method = RequestMethod.GET)
    public String showStudentQuiz(@ModelAttribute("studentId") Long studentId,
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
        StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
        if (status.equals(StudentQuizStatus.OPENED)) {
            OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(studentId, quizId);
            model.addAttribute("openedQuiz", openedQuiz);
            return "opened-quiz";
        }
        if (status.equals(StudentQuizStatus.PASSED)) {
            PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
            model.addAttribute("passedQuiz", passedQuiz);
            return "passed-quiz";
        }
        if (status.equals(StudentQuizStatus.FINISHED)) {
            PassedQuiz finishedQuiz = quizDao.findFinishedQuiz(studentId, quizId);
            model.addAttribute("finishedQuiz", finishedQuiz);
            return "finished-quiz";
        }
        return "hello"; // todo: add error-page
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/start", method = RequestMethod.GET)
    public String showQuizStart(@ModelAttribute("studentId") Long studentId,
                                @PathVariable("quizId") Long quizId, Model model) {
        OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(studentId, quizId);
        model.addAttribute("openedQuiz", openedQuiz);
        return "start-quiz";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/repass", method = RequestMethod.GET)
    public String showQuizRepass(@ModelAttribute("studentId") Long studentId,
                                 @PathVariable("quizId") Long quizId, Model model) {
        PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
        model.addAttribute("passedQuiz", passedQuiz);
        return "repass-quiz";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/{currentQuestion}", method = RequestMethod.GET)
    public String showFirstQuestion(@PathVariable("quizId") Long quizId,
                                    @PathVariable("currentQuestion") Integer currentQuestion,
                                    HttpSession session, Model model) {
        model.addAttribute("currentQuestion", currentQuestion);

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

        session.setAttribute(QUESTIONS, questions);
        session.setAttribute(RESULT, 0D);
        session.setAttribute(QUESTIONS_NUMBER, questions.size());

        Question firstQuestion = questions.get(currentQuestion);
        QuestionType firstQuestionType = firstQuestion.getQuestionType();
        Long firstQuestionId = firstQuestion.getQuestionId();

        setAnswers(firstQuestionType, firstQuestionId, session, model);

        return "question";
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/student/quizzes/{quizId}/{currentQuestion}", method = RequestMethod.POST)
    public String showCurrentQuestion(@RequestParam Map<String, String> studentAnswers,
                                      @PathVariable("quizId") Long quizId,
                                      @PathVariable("currentQuestion") Integer currentQuestion,
                                      @SessionAttribute(QUESTIONS) List<Question> questions,
                                      @SessionAttribute(RESULT) Double result,
                                      HttpSession session, Model model) {
        Question prevQuestion = questions.get(currentQuestion - 1);
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
                if (answers.size() == countOfCorrect) {
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

        if (currentQuestion == questions.size()) {
            Integer score = questionDao.findQuizScore(quizId);
            model.addAttribute("score", score);
            return "quiz-congratulations";
        }

        Question question = questions.get(currentQuestion);
        QuestionType questionType = question.getQuestionType();
        Long questionId = question.getQuestionId();

        setAnswers(questionType, questionId, session, model);

        return "question";
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

    @RequestMapping(value = "/student/results", method = RequestMethod.GET)
    public String showStudentResults(@ModelAttribute("studentId") Long studentId, Model model) {
        List<PassedQuiz> passedQuizzes =
                quizDao.findPassedQuizzes(studentId);
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> finishedQuizzes =
                quizDao.findFinishedQuizzes(studentId);
        model.addAttribute("finishedQuizzes", finishedQuizzes);

        return "student-results";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/finished", method = RequestMethod.POST)
    public String finishQuiz(@ModelAttribute("studentId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             Model model) {
        quizDao.finishQuiz(studentId, quizId);
        PassedQuiz finishedQuiz = quizDao.findFinishedQuiz(studentId, quizId);
        model.addAttribute("finishedQuiz", finishedQuiz);
        return "quiz-finished";
    }


    @RequestMapping(value = "/student/compare-results", method = RequestMethod.GET)
    public String showCompareResults(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        List<Quiz> groupQuizzes = quizDao.findPassedAndFinishedGroupQuizzes(student.getGroupId());
        model.addAttribute("groupQuizzes", groupQuizzes);
        return "compare-results";
    }

    @RequestMapping(value = "/student/compare-results/{quizId}")
    public String compareQuizResults(@ModelAttribute("studentId") Long studentId,
                                     @PathVariable("quizId") Long quizId,
                                     Model model) {

        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

        User student = userDao.findUser(studentId);
        List<User> studentsInGroup = userDao.findStudents(student.getGroupId());
        model.addAttribute("studentsInGroup", studentsInGroup);

        List<PassedQuiz> studentsQuizzes = new ArrayList<>();
        List<StudentQuizStatus> statusList = new ArrayList<>();
        for (User currentStudent : studentsInGroup) {
            Long currentStudentId = currentStudent.getUserId();
            StudentQuizStatus status = quizDao.findStudentQuizStatus(currentStudentId, quizId);
            statusList.add(status);
            if (status.equals(StudentQuizStatus.PASSED)) {
                PassedQuiz passedQuiz = quizDao.findPassedQuiz(currentStudentId, quizId);
                studentsQuizzes.add(passedQuiz);
            }
            if (status.equals(StudentQuizStatus.FINISHED)) {
                PassedQuiz finishedQuiz = quizDao.findFinishedQuiz(currentStudentId, quizId);
                studentsQuizzes.add(finishedQuiz);
            }
        }
        model.addAttribute("studentsQuizzes", studentsQuizzes);
        model.addAttribute("statusList", statusList);

        return "compare-quiz-results";
    }

//    INTERNALS===================================================================

    private void setAnswers(QuestionType questionType, Long questionId, HttpSession session, Model model) {
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
}