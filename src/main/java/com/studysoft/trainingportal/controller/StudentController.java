package com.studysoft.trainingportal.controller;

import com.studysoft.trainingportal.dao.*;
import com.studysoft.trainingportal.model.*;
import com.studysoft.trainingportal.model.enums.QuestionType;
import com.studysoft.trainingportal.model.enums.StudentQuizStatus;
import com.studysoft.trainingportal.validator.UserValidator;
import com.studysoft.trainingportal.util.Utils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@SessionAttributes("studentId")
@PreAuthorize("hasRole('ROLE_STUDENT')")
public class StudentController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;
    private UserValidator userValidator;

    private static final Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    public StudentController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             QuestionDao questionDao,
                             AnswerSimpleDao answerSimpleDao,
                             AnswerAccordanceDao answerAccordanceDao,
                             AnswerSequenceDao answerSequenceDao,
                             AnswerNumberDao answerNumberDao,
                             UserValidator userValidator) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
        this.userValidator = userValidator;
    }

    @ModelAttribute("studentId")
    public Long getStudentId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    // STUDENT GENERAL ===============================================================

    @RequestMapping("/student")
    public String showStudentHome(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        student.setPassword(Utils.maskPassword(student.getPassword()));
        Group group = null;
        String authorName = null;
        if (student.getGroupId() != 0) {
            group = groupDao.findGroup(student.getGroupId());
            authorName = userDao.findUserName(group.getAuthorId());
            Integer numberOfStudents = groupDao.findStudentsNumberInGroup(student.getGroupId());
            model.addAttribute("numberOfStudents", numberOfStudents);
        }

        model.addAttribute("student", student);
        model.addAttribute("authorName", authorName);
        model.addAttribute("group", group);

        return "student_general/student";
    }

    @RequestMapping(value = "/student/edit-profile", method = RequestMethod.GET)
    public String showEditProfile(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        model.addAttribute("user", student);
        model.addAttribute("dateOfBirth", student.getDateOfBirth());
        return "edit-profile";
    }

    @RequestMapping(value = "/student/edit-profile", method = RequestMethod.POST)
    public String editProfile(@ModelAttribute("studentId") Long studentId,
                              @RequestParam("newPassword") String newPassword,
                              @ModelAttribute("user") User editedStudent,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes, ModelMap model) {
        logger.info("Get student information from model attribute: " + editedStudent);
        User oldStudent = userDao.findUser(studentId);

        String newPasswordIncorrectMsg = null;
        if (!newPassword.isEmpty()) {
            newPasswordIncorrectMsg = userValidator.validateNewPassword(newPassword);
        }
        userValidator.validateEmail(editedStudent.getEmail(), bindingResult);
        userValidator.validatePhoneNumber(editedStudent.getPhoneNumber(), bindingResult);
        userValidator.validateFirstName(editedStudent.getFirstName(), bindingResult);
        userValidator.validateLastName(editedStudent.getLastName(), bindingResult);
        userValidator.validateDateOfBirth(editedStudent.getDateOfBirth(), bindingResult);

        String editedEmail = editedStudent.getEmail();
        String email = oldStudent.getEmail();
        if (!editedEmail.equals(email) && userDao.userExistsByEmail(editedEmail)) {
            bindingResult.rejectValue("email", "user.email.exists");
        }
        String editedPhoneNumber = editedStudent.getPhoneNumber();
        String phoneNumber = oldStudent.getPhoneNumber();
        if (!editedPhoneNumber.equals(phoneNumber) && userDao.userExistsByPhoneNumber(editedPhoneNumber)) {
            bindingResult.rejectValue("phoneNumber", "user.phoneNumber.exists");
        }
        String inputPassword = editedStudent.getPassword();
        String password = oldStudent.getPassword();
        if (!newPassword.isEmpty() && !inputPassword.equals(password)) {
            bindingResult.rejectValue("password", "user.password.incorrect-old");
            model.addAttribute("newPassword", newPassword);
        }

        if (bindingResult.hasErrors() || newPasswordIncorrectMsg != null) {
            model.addAttribute("user", editedStudent);
            model.addAttribute("newPasswordIncorrect", newPasswordIncorrectMsg);
            return "edit-profile";
        }

        userDao.editUser(oldStudent.getUserId(), editedStudent.getFirstName(), editedStudent.getLastName(),
                editedStudent.getEmail(), editedStudent.getDateOfBirth(), editedStudent.getPhoneNumber(),
                newPassword.isEmpty() ? oldStudent.getPassword() : newPassword);

        User newTeacher = userDao.findUser(studentId);
        if (!newTeacher.equals(oldStudent)) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
        }
        model.clear();
        return "redirect:/student";
    }

    @RequestMapping("/student/{groupMateId}")
    public String showStudentInfo(@ModelAttribute("studentId") Long studentId,
                                  @PathVariable("groupMateId") Long groupMateId,
                                  Model model) {
        if (checkGroupMateAccessDenied(studentId, groupMateId)) {
            throw new AccessDeniedException("Access denied to group mate page");
        }

        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();
        User groupMate = userDao.findUser(groupMateId);
        model.addAttribute("student", groupMate);

        if (groupId != 0) {
            Group group = groupDao.findGroup(groupId);
            model.addAttribute("group", group);
        }

        List<OpenedQuiz> openedQuizzes = new ArrayList<>();
        List<PassedQuiz> passedQuizzes = new ArrayList<>();
        List<PassedQuiz> closedQuizzes = new ArrayList<>();
        List<Long> commonQuizIds = quizDao.findCommonQuizIds(studentId, groupMateId);
        for (Long quizId : commonQuizIds) {
            StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
            switch (status) {
                case OPENED:
                    openedQuizzes.add(quizDao.findOpenedQuiz(studentId, quizId));
                    break;
                case PASSED:
                    passedQuizzes.add(quizDao.findPassedQuiz(studentId, quizId));
                    break;
                case CLOSED:
                    closedQuizzes.add(quizDao.findClosedQuiz(studentId, quizId));
            }
        }
        model.addAttribute("openedQuizzes", openedQuizzes);
        model.addAttribute("passedQuizzes", passedQuizzes);
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "student_general/student-info";
    }

    // STUDENT GROUP =================================================================

    @RequestMapping("/student/group")
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

        return "student_general/group";
    }

    // STUDENT TEACHERS ==============================================================

    @RequestMapping("/student/teachers")
    public String showStudentTeachers(@ModelAttribute("studentId") Long studentId, Model model) {
        List<Quiz> quizzes = quizDao.findStudentQuizzes(studentId);
        HashSet<User> teachers = new HashSet<>();
        for (Quiz quiz : quizzes) {
            teachers.add(userDao.findUser(quiz.getAuthorId()));
        }

        model.addAttribute("teachers", teachers);

        return "student_general/teachers";
    }

    @RequestMapping("/student/teachers/{teacherId}")
    public String showTeacherDetails(@ModelAttribute("studentId") Long studentId,
                                     @PathVariable("teacherId") Long teacherId, Model model) {
        if (checkTeacherAccessDenied(studentId, teacherId)) {
            throw new AccessDeniedException("Access denied to teacher page");
        }

        User teacher = userDao.findUser(teacherId);
        model.addAttribute("teacher", teacher);

        List<Quiz> quizzes =
                quizDao.findQuizzes(studentId, teacherId);
        model.addAttribute("quizzes", quizzes);

        List<String> statusList = new ArrayList<>();
        for (Quiz quiz : quizzes) {
            StudentQuizStatus status =
                    quizDao.findStudentQuizStatus(studentId, quiz.getQuizId());
            statusList.add(status.toString());
        }
        model.addAttribute("statusList", statusList);

        return "student_general/teacher-info";
    }

    // STUDENT QUIZZES ==============================================================

    @RequestMapping("/student/quizzes")
    public String showStudentQuizzes(@ModelAttribute("studentId") Long studentId, Model model) {
        List<OpenedQuiz> openedQuizzes
                = quizDao.findOpenedQuizzes(studentId);
        model.addAttribute("openedQuizzes", openedQuizzes);

        List<PassedQuiz> passedQuizzes
                = quizDao.findPassedQuizzes(studentId);
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> closedQuizzes
                = quizDao.findClosedQuizzes(studentId);
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "student_general/quizzes";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}", method = RequestMethod.GET)
    public String showStudentQuiz(@ModelAttribute("studentId") Long studentId,
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
        if (checkQuizAccessDenied(studentId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();
        Integer allStudents = userDao.findStudentsNumber(groupId, quizId);
        model.addAttribute("allStudents", allStudents);

        StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
        switch (status) {
            case OPENED:
                OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(studentId, quizId);
                model.addAttribute("openedQuiz", openedQuiz);
                return "student_quiz/opened";
            case PASSED:
                PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
                model.addAttribute("passedQuiz", passedQuiz);
                return "student_quiz/passed";
            case CLOSED:
                Integer closedStudents = userDao.findStudentsNumberInGroupWithClosedQuiz(groupId, quizId);
                PassedQuiz closedQuiz = quizDao.findClosedQuiz(studentId, quizId);
                model.addAttribute("closedStudents", closedStudents);
                model.addAttribute("closedQuiz", closedQuiz);
                return "student_quiz/closed";
        }
        return "student_general/student";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}", method = RequestMethod.POST)
    public String closeQuiz(@ModelAttribute("studentId") Long studentId,
                            @PathVariable("quizId") Long quizId,
                            RedirectAttributes redirectAttributes) {
        quizDao.closeQuizToStudent(studentId, quizId);
        redirectAttributes.addFlashAttribute("closeSuccess", true);
        return "redirect:/student/quizzes/" + quizId;
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/close", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> closeQuiz(@ModelAttribute("studentId") Long studentId,
                                       @PathVariable("quizId") Long quizId) {
        quizDao.closeQuizToStudent(studentId, quizId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/start", method = RequestMethod.GET)
    public String showQuizStart(@ModelAttribute("studentId") Long studentId,
                                @PathVariable("quizId") Long quizId,
                                @SessionAttribute(value = com.studysoft.trainingportal.controller.SessionAttributes.CURRENT_QUESTION_SERIAL, required = false)
                                        Integer currentQuestionSerial,
                                ModelMap model) {
        if (checkQuizAccessDenied(studentId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

        if (currentQuestionSerial != null) {
            model.clear();
            return "redirect:/quizzes/" + quizId + "continue";
        }
        OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(studentId, quizId);
        model.addAttribute("openedQuiz", openedQuiz);
        return "student_quiz/start";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}/repass", method = RequestMethod.GET)
    public String showQuizRepass(@ModelAttribute("studentId") Long studentId,
                                 @PathVariable("quizId") Long quizId,
                                 @SessionAttribute(value = com.studysoft.trainingportal.controller.SessionAttributes.CURRENT_QUESTION_SERIAL, required = false)
                                         Integer currentQuestionSerial,
                                 ModelMap model) {
        if (checkQuizAccessDenied(studentId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

        if (currentQuestionSerial != null) {
            model.clear();
            return "redirect:/quizzes/continue";
        }
        PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
        model.addAttribute("passedQuiz", passedQuiz);
        return "student_quiz/repass";
    }

    @RequestMapping("/student/quizzes/{quizId}/answers")
    public String showAnswers(@ModelAttribute("studentId") Long studentId,
                              @PathVariable("quizId") Long quizId, ModelMap model) {
        if (checkQuizAccessDenied(studentId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }
        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();
        Integer totalStudents = userDao.findStudentsNumber(groupId, quizId);
        Integer closedStudents = userDao.findStudentsNumberInGroupWithClosedQuiz(groupId, quizId);
        if (!closedStudents.equals(totalStudents)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

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

        return "student_quiz/answers";
    }

    // STUDENT RESULTS ==================================================================

    @RequestMapping("/student/results")
    public String showStudentResults(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();

        List<OpenedQuiz> notSingleOpenedQuizzes = new ArrayList<>();
        List<PassedQuiz> notSinglePassedQuizzes = new ArrayList<>();
        List<PassedQuiz> notSingleClosedQuizzes = new ArrayList<>();
        List<Quiz> studentQuizzes = quizDao.findStudentQuizzes(studentId);
        if (!groupId.equals(0L)) {
            for (Quiz quiz : studentQuizzes) {
                Long quizId = quiz.getQuizId();
                StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
                Integer studentsNumber = userDao.findStudentsNumber(groupId, quizId);
                if (studentsNumber.equals(1)) {
                    continue;
                }
                switch (status) {
                    case OPENED:
                        notSingleOpenedQuizzes.add(quizDao.findOpenedQuiz(studentId, quizId));
                        break;
                    case PASSED:
                        notSinglePassedQuizzes.add(quizDao.findPassedQuiz(studentId, quizId));
                        break;
                    case CLOSED:
                        notSingleClosedQuizzes.add(quizDao.findClosedQuiz(studentId, quizId));
                        break;
                }
            }
        }

        model.addAttribute("notSingleOpenedQuizzes", notSingleOpenedQuizzes);
        model.addAttribute("notSinglePassedQuizzes", notSinglePassedQuizzes);
        model.addAttribute("notSingleClosedQuizzes", notSingleClosedQuizzes);

        List<OpenedQuiz> openedQuizzes = quizDao.findOpenedQuizzes(studentId);
        List<PassedQuiz> passedQuizzes = quizDao.findPassedQuizzes(studentId);
        List<PassedQuiz> closedQuizzes = quizDao.findClosedQuizzes(studentId);

        model.addAttribute("openedQuizzes", openedQuizzes);
        model.addAttribute("passedQuizzes", passedQuizzes);
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "student_general/results";
    }

    @RequestMapping("/student/results/{quizId}")
    public String compareQuizResults(@ModelAttribute("studentId") Long studentId,
                                     @PathVariable("quizId") Long quizId,
                                     Model model) {
        if (checkQuizAccessDenied(studentId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();

        List<User> openedStudents = userDao.findStudents(groupId, quizId, StudentQuizStatus.OPENED);
        List<User> passedStudents = userDao.findStudents(groupId, quizId, StudentQuizStatus.PASSED);
        List<User> closedStudents = userDao.findStudents(groupId, quizId, StudentQuizStatus.CLOSED);
        model.addAttribute("openedStudents", openedStudents);
        model.addAttribute("passedStudents", passedStudents);
        model.addAttribute("closedStudents", closedStudents);

        List<OpenedQuiz> openedQuizzes = new ArrayList<>();
        for (User openedStudent : openedStudents) {
            Long openedStudentId = openedStudent.getUserId();
            OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(openedStudentId, quizId);
            openedQuizzes.add(openedQuiz);
        }
        model.addAttribute("openedQuizzes", openedQuizzes);

        List<PassedQuiz> passedQuizzes = new ArrayList<>();
        for (User passedStudent : passedStudents) {
            Long passedStudentId = passedStudent.getUserId();
            PassedQuiz passedQuiz = quizDao.findPassedQuiz(passedStudentId, quizId);
            passedQuizzes.add(passedQuiz);
        }
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> closedQuizzes = new ArrayList<>();
        for (User closedStudent : closedStudents) {
            Long closedStudentId = closedStudent.getUserId();
            PassedQuiz closedQuiz = quizDao.findClosedQuiz(closedStudentId, quizId);
            closedQuizzes.add(closedQuiz);
        }
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "student_general/compare-quiz-results";
    }

    // INTERNALS =========================================================================

    private boolean checkQuizAccessDenied(Long studentId, Long quizId) {
        List<Long> studentQuizIds = quizDao.findStudentQuizIds(studentId);
        return !studentQuizIds.contains(quizId);
    }

    private boolean checkTeacherAccessDenied(Long studentId, Long teacherId) {
        List<Long> teacherIds = quizDao.findStudentQuizzes(studentId)
                .stream()
                .map(Quiz::getAuthorId)
                .collect(Collectors.toList());
        return !teacherIds.contains(teacherId);
    }

    private boolean checkGroupMateAccessDenied(Long studentId, Long groupMateId) {
        User student = userDao.findUser(studentId);
        List<Long> groupMatesIds = userDao.findStudents(student.getGroupId())
                .stream()
                .map(User::getUserId)
                .collect(Collectors.toList());
        return !groupMatesIds.contains(groupMateId);
    }
}