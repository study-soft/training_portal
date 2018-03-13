package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.StudentQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

@Controller
@SessionAttributes("studentId")
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

    @ModelAttribute("studentId")
    public Long getStudentId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping(value = "/student", method = RequestMethod.GET)
    public String showStudentHome(@ModelAttribute("studentId") Long studentId, Model model) {
        User student = userDao.findUserByUserId(studentId);
        Group group = null;
        String authorName = null;
        if (student.getGroupId() != 0) {
            group = groupDao.findGroupByGroupId(student.getGroupId());
            authorName = userDao.findUserNameByUserId(group.getAuthorId());
        }

        model.addAttribute("student", student);
        model.addAttribute("authorName", authorName);
        model.addAttribute("group", group);

        return "student";
    }

    @RequestMapping(value = "/student/teachers", method = RequestMethod.GET)
    public String showStudentTeachers(@ModelAttribute("studentId") Long studentId, Model model) {
        List<Quiz> quizzes = quizDao.findStudentQuizzes(studentId);
        HashSet<User> teachers = new HashSet<>();
        for (Quiz quiz : quizzes) {
            teachers.add(userDao.findUserByUserId(quiz.getAuthorId()));
        }

        model.addAttribute("teachers", teachers);

        return "student-teachers";
    }

    @RequestMapping(value = "/student/teachers/{teacherId}", method = RequestMethod.GET)
    public String showTeacherDetails(@ModelAttribute("studentId") Long studentId,
                                     @PathVariable("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUserByUserId(teacherId);
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

    @RequestMapping(value = "/student/quizzes/${quizId}", method = RequestMethod.GET)
    public String showStudentQuiz(@ModelAttribute("studentId") Long studentId,
                           @PathVariable("quizId") Long quizId, Model model) {
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
}