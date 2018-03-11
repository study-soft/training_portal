package com.company.training_portal.controller;

import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.SecurityUser;
import com.company.training_portal.model.User;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.security.Principal;

@Controller
public class StudentController {

    private UserDao userDao;

    private static final Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    public StudentController(UserDao userDao) {
        this.userDao = userDao;
    }

    @RequestMapping(value = "/student", method = RequestMethod.GET)
    public String showStudentHome(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        User user = userDao.findUserByUserId(securityUser.getUserId());
        model.addAttribute("user", user);
        return "student";
    }
}
