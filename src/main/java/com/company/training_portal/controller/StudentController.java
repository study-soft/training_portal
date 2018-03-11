package com.company.training_portal.controller;

import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.SecurityUser;
import com.company.training_portal.model.User;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.ArrayList;
import java.util.List;

@Controller
public class StudentController {

    private UserDao userDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;

    private static final Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    public StudentController(UserDao userDao,
                             QuizDao quizDao,
                             QuestionDao questionDao) {
        this.userDao = userDao;
        this.quizDao = quizDao;
        this.questionDao = questionDao;
    }

    @RequestMapping(value = "/student", method = RequestMethod.GET)
    public String showStudentHome(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        User user = userDao.findUserByUserId(securityUser.getUserId());
        model.addAttribute("user", user);
        return "student";
    }

    @RequestMapping(value = "student/quizzes", method = RequestMethod.GET)
    public String showStudentQuizzes(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        Long studentId = securityUser.getUserId();
        List<Long> quizIds = quizDao.findAllQuizIdsByStudentId(studentId);
        List<Quiz> quizzes = new ArrayList<>();
        for (Long quizId : quizIds) {
            quizzes.add(quizDao.findQuizByQuizId(quizId));
        }

        List<String> authorNames = new ArrayList<>();
        for (Quiz quiz : quizzes) {
            authorNames.add(userDao.findUserByUserId(quiz.getAuthorId()).getFirstName() + " " +
            userDao.findUserByUserId(quiz.getAuthorId()).getLastName());
        }
        model.addAttribute("authorNames", authorNames);

        List<Integer> quizScores = new ArrayList<>();
        for (Long quizId : quizIds) {
            quizScores.add(questionDao.findQuizScoreByQuizId(quizId));
        }
        model.addAttribute("quizScores", quizScores);

        return "student-quizzes";
    }
}
