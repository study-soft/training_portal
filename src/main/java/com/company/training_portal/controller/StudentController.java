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

import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;

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
    public String showQuizStart(@PathVariable("quizId") Long quizId, Model model) {
        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

        Integer questionsNumber = questionDao.findQuestionsNumber(quizId);
        model.addAttribute("questionsNumber", questionsNumber);

        Integer quizScore = questionDao.findQuizScore(quizId);
        model.addAttribute("quizScore", quizScore);

//        List<Question> questions = questionDao.findQuestions(quizId, QuestionType.ONE_ANSWER);
//        if (questions.isEmpty()) {
//            questions = questionDao.findQuestions(quizId, QuestionType.FEW_ANSWERS);
//            if (questions.isEmpty()) {
//                questions = questionDao.findQuestions(quizId, QuestionType.ACCORDANCE);
//                if (questions.isEmpty()) {
//                    questions = questionDao.findQuestions(quizId, QuestionType.SEQUENCE);
//                    if (questions.isEmpty()) {
//                        questions = questionDao.findQuestions(quizId, QuestionType.NUMBER);
//                    }
//                }
//            }
//        }
//        List<Long> questionIds = questions.stream()
//                .map(Question::getQuestionId)
//                .collect(Collectors.toList());
//        int index = new Random().nextInt(questionIds.size());
//        Long firstQuestionId = questionIds.get(index);
//        model.addAttribute("firstQuestionId", firstQuestionId);

        return "start-quiz";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/{currentQuestion}", method = RequestMethod.GET)
    public String showQuestion(@PathVariable("quizId") Long quizId,
                               @PathVariable("currentQuestion") Integer currentQuestion,
                               HttpSession session, Model model) {
        model.addAttribute("currentQuestion", currentQuestion);

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

        session.setAttribute("questions", questions);

        Question firstQuestion = questions.get(currentQuestion);
        QuestionType firstQuestionType = firstQuestion.getQuestionType();
        Long firstQuestionId = firstQuestion.getQuestionId();
        switch (firstQuestionType) {
            case ONE_ANSWER:
                List<AnswerSimple> oneAnswer = answerSimpleDao.findAnswersSimple(firstQuestionId);
                model.addAttribute("answers", oneAnswer);
                break;
            case FEW_ANSWERS:
                List<AnswerSimple> fewAnswers = answerSimpleDao.findAnswersSimple(firstQuestionId);
                model.addAttribute("answers", fewAnswers);
                break;
            case ACCORDANCE:
                AnswerAccordance answerAccordance = answerAccordanceDao.findAnswerAccordance(firstQuestionId);
                Collections.shuffle(answerAccordance.getLeftSide());
                Collections.shuffle(answerAccordance.getRightSide());
                model.addAttribute("answers", answerAccordance);
                break;
            case SEQUENCE:
                AnswerSequence answerSequence = answerSequenceDao.findAnswerSequence(firstQuestionId);
                Collections.shuffle(answerSequence.getCorrectList());
                model.addAttribute("answers", answerSequence);
                break;
            case NUMBER:
                AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(firstQuestionId);
                model.addAttribute("answers", answerNumber);
                break;
        }

        return "question";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/answers", method = RequestMethod.GET)
    public String showAnswers(@PathVariable("quizId") Long quizId, Model model) {
        List<Question> questionsOneAnswer = questionDao.findQuestions(quizId, QuestionType.ONE_ANSWER);
        List<Question> questionsFewAnswers = questionDao.findQuestions(quizId, QuestionType.FEW_ANSWERS);
        List<Question> questionsAccordance = questionDao.findQuestions(quizId, QuestionType.ACCORDANCE);
        List<Question> questionsSequence = questionDao.findQuestions(quizId, QuestionType.SEQUENCE);
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
}