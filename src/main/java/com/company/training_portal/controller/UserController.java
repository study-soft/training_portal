package com.company.training_portal.controller;

import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.UserRole;
import com.company.training_portal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.*;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;

@Controller
public class UserController {

    private static final Logger logger = Logger.getLogger(UserController.class);

    private UserDao userDao;

    private Validator userValidator;

    @Autowired
    public UserController(UserDao userDao, Validator userValidator) {
        this.userDao = userDao;
        this.userValidator = userValidator;
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "registration";
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String registerUser(@ModelAttribute("user") User user,
                               BindingResult bindingResult, Model model) {
        logger.info("Bind request parameter to User backing object: " + user);
        userValidator.validate(user, bindingResult);
        if (bindingResult.hasErrors()) {
            return "registration";
        }

        userDao.registerUser(user);
        model.addAttribute("registrationSuccess",
                "You have been successfully registered! Just log in now.");

        return "login";
    }
}