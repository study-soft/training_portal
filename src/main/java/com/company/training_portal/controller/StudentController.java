package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.StudentQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
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

    @RequestMapping(value = "/student", method = RequestMethod.GET)
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

        return "student_general/student-info";
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

        return "student_general/group";
    }

    @RequestMapping(value = "/student/teachers", method = RequestMethod.GET)
    public String showStudentTeachers(@ModelAttribute("studentId") Long studentId, Model model) {
        List<Quiz> quizzes = quizDao.findStudentQuizzes(studentId);
        HashSet<User> teachers = new HashSet<>();
        for (Quiz quiz : quizzes) {
            teachers.add(userDao.findUser(quiz.getAuthorId()));
        }

        model.addAttribute("teachers", teachers);

        return "student_general/teachers";
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

        List<PassedQuiz> finishedQuizzes
                = quizDao.findFinishedQuizzes(studentId);
        model.addAttribute("finishedQuizzes", finishedQuizzes);

        return "student_general/quizzes";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}", method = RequestMethod.GET)
    public String showStudentQuiz(@ModelAttribute("studentId") Long studentId,
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
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
            case FINISHED:
                Long groupId = userDao.findUser(studentId).getGroupId();
                Integer finishedStudents = userDao.findStudentsNumberInGroupWithFinishedQuiz(groupId, quizId);
                Integer allStudents = groupDao.findStudentsNumberInGroup(groupId);
                PassedQuiz finishedQuiz = quizDao.findFinishedQuiz(studentId, quizId);
                model.addAttribute("finishedStudents", finishedStudents);
                model.addAttribute("allStudents", allStudents);
                model.addAttribute("finishedQuiz", finishedQuiz);
                return "student_quiz/finished";
        }
        return "student_general/student";
    }

    @RequestMapping(value = "/student/quizzes/{quizId}", method = RequestMethod.POST)
    public String finishQuiz(@ModelAttribute("studentId") Long studentId,
                             @PathVariable("quizId") Long quizId,
                             RedirectAttributes redirectAttributes) {
        quizDao.finishQuiz(studentId, quizId);
        redirectAttributes.addFlashAttribute("finishSuccess", true);
        return "redirect:/student/quizzes/" + quizId;
    }

    @RequestMapping(value = "/student/results", method = RequestMethod.GET)
    public String showStudentResults(@ModelAttribute("studentId") Long studentId, Model model) {
        List<PassedQuiz> passedQuizzes =
                quizDao.findPassedQuizzes(studentId);
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> finishedQuizzes =
                quizDao.findFinishedQuizzes(studentId);
        model.addAttribute("finishedQuizzes", finishedQuizzes);

        return "student_general/results";
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
            switch (status) {
                case OPENED:
                    PassedQuiz openedQuiz = new PassedQuiz.PassedQuizBuilder().build();
                    studentsQuizzes.add(openedQuiz);
                    break;
                case PASSED:
                    PassedQuiz passedQuiz = quizDao.findPassedQuiz(currentStudentId, quizId);
                    studentsQuizzes.add(passedQuiz);
                    break;
                case FINISHED:
                    PassedQuiz finishedQuiz = quizDao.findFinishedQuiz(currentStudentId, quizId);
                    studentsQuizzes.add(finishedQuiz);
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