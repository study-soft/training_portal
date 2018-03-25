package com.company.training_portal.controller;

import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.User;
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
import org.springframework.web.bind.annotation.SessionAttribute;

import java.time.LocalDateTime;

import static com.company.training_portal.controller.QuizController.roundOff;
import static com.company.training_portal.controller.SessionAttributes.CURRENT_QUIZ;
import static com.company.training_portal.controller.SessionAttributes.RESULT;
import static com.company.training_portal.model.enums.StudentQuizStatus.PASSED;

@Controller
public class UserController {

    private UserDao userDao;
    private QuizDao quizDao;
    private Validator userValidator;

    private static final Logger logger = Logger.getLogger(UserController.class);

    @Autowired
    public UserController(UserDao userDao,
                          QuizDao quizDao,
                          @Qualifier("userValidator") Validator userValidator) {
        this.userDao = userDao;
        this.quizDao = quizDao;
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
            bindingResult.rejectValue("login", "user.login.exists");
        }
        if (userDao.userExistsByEmail(user.getEmail())) {
            bindingResult.rejectValue("email", "user.email.exists");
        }
        if (userDao.userExistsByPhoneNumber(user.getPhoneNumber())) {
            bindingResult.rejectValue("phoneNumber", "user.phoneNumber.exists");
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

    @RequestMapping("/quiz-passing-logout")
    public String writeResultToDB(@SessionAttribute("studentId") Long studentId,
                                  @SessionAttribute(value = CURRENT_QUIZ, required = false) Quiz quiz,
                                  @SessionAttribute(value = "result", required = false) Double result) {
        if (result != null) {
            Long quizId = quiz.getQuizId();
            Integer attempt = quizDao.findAttempt(studentId, quizId);
            Integer roundedResult = roundOff(result * (1 - 0.1 * attempt));
            attempt += 1;
            LocalDateTime finishDate = LocalDateTime.now();
            quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                    finishDate, attempt, PASSED);
            logger.info(">>>>>>> WRITING RESULT TO DATABASE");
        }
        return "redirect:/logout";
    }
}