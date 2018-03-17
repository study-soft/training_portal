package com.company.training_portal.controller;

import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.UserRole;
import com.company.training_portal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.*;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;

@Controller
public class UserController {

    private UserDao userDao;
    private Validator userValidator;

    private static final Logger logger = Logger.getLogger(UserController.class);

    @Autowired
    public UserController(UserDao userDao, @Qualifier("userValidator") Validator userValidator) {
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
                               BindingResult bindingResult, ModelMap model) {
        logger.info("Bind request parameter to User backing object: " + user);
        userValidator.validate(user, bindingResult);
        if (userDao.userExistsByLogin(user.getLogin())) {
            bindingResult.rejectValue("login", "user.exists.login");
        }
        if (userDao.userExistsByEmail(user.getEmail())) {
            bindingResult.rejectValue("email", "user.exists.email");
        }
        if (userDao.userExistsByPhoneNumber(user.getPhoneNumber())) {
            bindingResult.rejectValue("phoneNumber", "user.exists.phoneNumber");
        }
        if (bindingResult.hasErrors()) {
            return "registration";
        }

        userDao.registerUser(user);
        model.addAttribute("registrationSuccess",
                "You have been successfully registered! Just log in now.");

        model.clear();
        return "redirect:/login";
    }
}