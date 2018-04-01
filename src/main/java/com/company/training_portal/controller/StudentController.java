package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.StudentQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@SessionAttributes("studentId")
public class StudentController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private Validator userValidator;

    private static final Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    public StudentController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             @Qualifier("userValidator") Validator userValidator) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.quizDao = quizDao;
        this.userValidator = userValidator;
    }

    @ModelAttribute("studentId")
    public Long getStudentId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping("/student")
    public String showStudentHome(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
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

    @RequestMapping("/student/{groupMateId}")
    public String showStudentInfo(@ModelAttribute("studentId") Long studentId,
                                  @PathVariable("groupMateId") Long groupMateId,
                                  Model model) {
        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();
        List<User> groupMates = userDao.findStudents(groupId);
        List<Long> groupMatesIds = groupMates.stream()
                .map(User::getUserId)
                .collect(Collectors.toList());
        if (groupMatesIds.contains(groupMateId)) {
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
        } else {
            return "access-denied";
        }
    }

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

        return "student_general/teacher-info";
    }

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

    @RequestMapping("/student/results")
    public String showStudentResults(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        Long groupId = student.getGroupId();

        List<PassedQuiz> notSinglePassedQuizzes = new ArrayList<>();
        List<PassedQuiz> notSingleClosedQuizzes = new ArrayList<>();
        List<Quiz> studentQuizzes = quizDao.findStudentQuizzes(studentId);
        for (Quiz quiz : studentQuizzes) {
            Long quizId = quiz.getQuizId();
            StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
            Integer studentsNumber = userDao.findStudentsNumber(groupId, quizId);
            if (studentsNumber.equals(1)) {
                continue;
            }
            switch (status) {
                case PASSED:
                    notSinglePassedQuizzes.add(quizDao.findPassedQuiz(studentId, quizId));
                    break;
                case CLOSED:
                    notSingleClosedQuizzes.add(quizDao.findClosedQuiz(studentId, quizId));
            }
        }

        model.addAttribute("notSinglePassedQuizzes", notSinglePassedQuizzes);
        model.addAttribute("notSingleClosedQuizzes", notSingleClosedQuizzes);

        List<PassedQuiz> passedQuizzes =
                quizDao.findPassedQuizzes(studentId);
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> closedQuizzes =
                quizDao.findClosedQuizzes(studentId);
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "student_general/results";
    }

    @RequestMapping("/student/results/{quizId}")
    public String compareQuizResults(@ModelAttribute("studentId") Long studentId,
                                     @PathVariable("quizId") Long quizId,
                                     Model model) {

        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

        User student = userDao.findUser(studentId);
        List<User> students = userDao.findStudents(student.getGroupId(), quizId);
        model.addAttribute("students", students);

        List<PassedQuiz> studentsQuizzes = new ArrayList<>();
        List<StudentQuizStatus> statusList = new ArrayList<>();
        for (User currentStudent : students) {
            Long currentStudentId = currentStudent.getUserId();
            StudentQuizStatus status = quizDao.findStudentQuizStatus(currentStudentId, quizId);
            statusList.add(status);
            switch (status) {
                case OPENED:
                    PassedQuiz openedQuiz = new PassedQuiz.PassedQuizBuilder().build();
                    studentsQuizzes.add(openedQuiz);
                    break;
                case PASSED:
                    PassedQuiz passedQuiz = quizDao.findPassedQuiz(currentStudentId, quizId);
                    studentsQuizzes.add(passedQuiz);
                    break;
                case CLOSED:
                    PassedQuiz closedQuiz = quizDao.findClosedQuiz(currentStudentId, quizId);
                    studentsQuizzes.add(closedQuiz);
                    break;
            }
        }
        model.addAttribute("studentsQuizzes", studentsQuizzes);
        model.addAttribute("statusList", statusList);

        return "student_general/compare-quiz-results";
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
                              @ModelAttribute("user") User editedStudent,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes, ModelMap model) {
        logger.info("Get student information from model attribute: " + editedStudent);
        User oldStudent = userDao.findUser(studentId);
        model.addAttribute("oldStudent", oldStudent);

        editedStudent.setLogin(oldStudent.getLogin());
        editedStudent.setUserRole(oldStudent.getUserRole());

        userValidator.validate(editedStudent, bindingResult);

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
        if (bindingResult.hasErrors()) {
            model.addAttribute("user", editedStudent);
            return "edit-profile";
        }

        userDao.editUser(oldStudent.getUserId(), editedStudent.getFirstName(), editedStudent.getLastName(),
                editedStudent.getEmail(), editedStudent.getDateOfBirth(), editedStudent.getPhoneNumber(),
                editedStudent.getPassword());

        redirectAttributes.addFlashAttribute("editSuccess", true);
        model.clear();
        return "redirect:/student";
    }
}