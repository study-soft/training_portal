package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Group;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.SecurityUser;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

@Controller
public class StudentController {

    private UserDao userDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;
    private GroupDao groupDao;

    private static final Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    public StudentController(UserDao userDao,
                             QuizDao quizDao,
                             QuestionDao questionDao,
                             GroupDao groupDao) {
        this.userDao = userDao;
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.groupDao = groupDao;
    }

    @RequestMapping(value = "/student", method = RequestMethod.GET)
    public String showStudentHome(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        User student = userDao.findUserByUserId(securityUser.getUserId());
        Group group = groupDao.findGroupByGroupId(student.getGroupId());
        String authorName = userDao.findUserNameByUserId(group.getAuthorId());



        model.addAttribute("student", student);
        model.addAttribute("authorName", authorName);
        model.addAttribute("group", group);

        return "student";
    }

    @RequestMapping(value = "/student/teachers", method = RequestMethod.GET)
    public String showStudentTeachers(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        Long studentId = securityUser.getUserId();
        List<Quiz> quizzes = quizDao.findQuizzesByStudentId(studentId);
        HashSet<User> teachers = new HashSet<>();
        for (Quiz quiz : quizzes) {
            teachers.add(userDao.findUserByUserId(quiz.getAuthorId()));
        }

        model.addAttribute("teachers", teachers);

        return "student-teachers";
    }

    @RequestMapping(value = "/student/teachers/{teacherId}", method = RequestMethod.GET)
    public String showTeacherDetails(@AuthenticationPrincipal SecurityUser securityUser,
                                     @PathVariable("teacherId") Long teacherId, Model model) {
        Long studentId = securityUser.getUserId();

        User teacher = userDao.findUserByUserId(teacherId);
        model.addAttribute("teacher", teacher);

        List<Quiz> quizzes = quizDao.findQuizzesByStudentIdAndAuthorId(studentId, teacherId);
        model.addAttribute("quizzes", quizzes);

        List<StudentQuizStatus> statusList = new ArrayList<>();
        for (Quiz quiz : quizzes) {
            StudentQuizStatus status =
                    quizDao.findStudentQuizStatusByStudentIdAndQuizId(studentId, quiz.getQuizId());
            statusList.add(status);
        }
        model.addAttribute("statusList", statusList);

        return "teacher-info";
    }

    @RequestMapping(value = "/student/results", method = RequestMethod.GET)
    public String showStudentResults(@AuthenticationPrincipal SecurityUser securityUser,
                                     Model model) {
        Long studentId = securityUser.getUserId();

        return "student-results";
    }
}