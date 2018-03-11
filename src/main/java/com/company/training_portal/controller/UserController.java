package com.company.training_portal.controller;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.UserRole;
import com.company.training_portal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.MapBindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;

@Controller
public class UserController {

    private static final Logger logger = Logger.getLogger(UserController.class);

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String registerUserGet(Model model) {
        model.addAttribute("user", new User());
        return "registration";
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String registerUserPost(@ModelAttribute("user") User user, BindingResult errors, Model model) {
        logger.info("Bind request parameter to User backing object: " + user);
//        Errors errors = new BeanPropertyBindingResult(user, "user");
        UserValidator validator = new UserValidator();
        validator.validate(user, errors);
        if (errors.hasErrors()) {
            return "registration";
        }
        return "hello";
    }
}