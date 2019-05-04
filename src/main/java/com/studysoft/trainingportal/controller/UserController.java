package com.studysoft.trainingportal.controller;

import com.studysoft.trainingportal.dao.QuizDao;
import com.studysoft.trainingportal.dao.UserDao;
import com.studysoft.trainingportal.model.Quiz;
import com.studysoft.trainingportal.model.SecurityUser;
import com.studysoft.trainingportal.model.User;
import com.studysoft.trainingportal.model.enums.StudentQuizStatus;
import com.studysoft.trainingportal.util.Utils;
import com.studysoft.trainingportal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.stream.Collectors;

@Controller
public class UserController {

    private UserDao userDao;
    private QuizDao quizDao;
    private UserValidator userValidator;

    private static final Logger logger = Logger.getLogger(UserController.class);

    @Autowired
    public UserController(UserDao userDao,
                          QuizDao quizDao,
                          UserValidator userValidator) {
        this.userDao = userDao;
        this.quizDao = quizDao;
        this.userValidator = userValidator;
    }

    /**
     * Показує сторінку з формою реєстрації
     *
     * @param model інтерфейс для додавання атрибутів до моделі на UI
     * @return registration.jsp
     */
    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "registration";
    }

    /**
     * Реєстрація нового користувача в систему. Проводиться валідація параметрів, введених користувачем.
     * Якщо реєстрація успішна - користувач створюється у БД та додається сповіщення успіху на UI
     *
     * @param user               інформація, введена користувачем
     * @param redirectAttributes інтерфейс для збереження атрибутів під час перенапрямлення HTTP-запиту
     * @param bindingResult      інтерфейс для зручного представлення помилок валідації
     * @param locale             об'єкт, що містить інформацію про мову, обрану користувачем
     * @param model              інтерфейс для додавання атрибутів до моделі на UI
     * @return registration.jsp
     */
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String registerUser(@ModelAttribute("user") User user, RedirectAttributes redirectAttributes,
                               BindingResult bindingResult, Locale locale, ModelMap model) {
        logger.info("Bind request parameter to User backing object: " + user);
        userValidator.validate(user, bindingResult);
        ResourceBundle bundle = ResourceBundle.getBundle("i18n/language", locale);
        if (userDao.userExistsByLogin(user.getLogin())) {
            bindingResult.rejectValue("login", "validation.user.login.exists");
        }
        if (userDao.userExistsByEmail(user.getEmail())) {
            bindingResult.rejectValue("email", "validation.user.email.exists");
        }
        if (userDao.userExistsByPhoneNumber(user.getPhoneNumber())) {
            bindingResult.rejectValue("phoneNumber", "validation.user.phone.exists");
        }
        if (bindingResult.hasErrors()) {
            return "registration";
        }

        userDao.registerUser(user);
        redirectAttributes.addFlashAttribute("registrationSuccess",
                bundle.getString("validation.registration.success"));

        model.clear();
        return "redirect:/login";
    }

    /**
     * Зберігає поточний результат вікторини у БД, якщо користувач намагається вийти із системи під час
     * проходження вікторини
     *
     * @param securityUser об'єкт, що містить інформацію про користувача, авторизованого в системі
     * @param studentId    ID авторизованого користувача у HTTP-сесії
     * @param quiz         поточна вікторина, яку проходить користувач, зберігається у HTTP-сесії
     * @param result       поточний результат вікторини, яку проходить користувач, зберігається у HTTP-сесії
     * @return проводить перенапрямлення HTTP-запиту на /logout для виходу користувача із системи
     */
    @RequestMapping(value = "/quiz-passing-logout", method = RequestMethod.GET)
    public String writeResultToDB(@AuthenticationPrincipal SecurityUser securityUser,
                                  @SessionAttribute("studentId") Long studentId,
                                  @SessionAttribute(value = SessionAttributes.CURRENT_QUIZ, required = false) Quiz quiz,
                                  @SessionAttribute(value = "result", required = false) Double result) {
        List<String> userRoles = securityUser.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
        if (userRoles.contains("ROLE_STUDENT") && result != null) {
            Long quizId = quiz.getQuizId();
            Integer attempt = quizDao.findAttempt(studentId, quizId);
            Integer roundedResult = Utils.roundOff(result * (1 - 0.1 * attempt));
            attempt += 1;
            LocalDateTime finishDate = LocalDateTime.now();
            quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                    finishDate, attempt, StudentQuizStatus.PASSED);
            logger.info("WRITING RESULT TO DATABASE");
        }
        return "redirect:/logout";
    }
}