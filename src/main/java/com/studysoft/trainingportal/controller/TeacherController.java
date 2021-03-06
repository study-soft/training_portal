package com.studysoft.trainingportal.controller;

import com.studysoft.trainingportal.dao.GroupDao;
import com.studysoft.trainingportal.dao.UserDao;
import com.studysoft.trainingportal.model.Group;
import com.studysoft.trainingportal.model.SecurityUser;
import com.studysoft.trainingportal.model.User;
import com.studysoft.trainingportal.util.Utils;
import com.studysoft.trainingportal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@SessionAttributes("teacherId")
@PreAuthorize("hasRole('ROLE_TEACHER')")
public class TeacherController {

    private UserDao userDao;
    private GroupDao groupDao;
    private UserValidator userValidator;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherController(UserDao userDao,
                             GroupDao groupDao,
                             UserValidator userValidator) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.userValidator = userValidator;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    /**
     * Показує головну сторінку для викладача
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_general/teacher.jsp
     */
    @RequestMapping(value = "/teacher", method = RequestMethod.GET)
    public String showTeacherHome(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        teacher.setPassword(Utils.maskPassword(teacher.getPassword()));
        model.addAttribute("teacher", teacher);
        return "teacher_general/teacher";
    }

    /**
     * Показує сторінку з формою редагування профіля
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return edit-profile.jsp
     */
    @RequestMapping(value = "/teacher/edit-profile", method = RequestMethod.GET)
    public String showEditProfile(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        teacher.setPassword("");
        model.addAttribute("user", teacher);
        return "edit-profile";
    }

    /**
     * Оновлення профіля користувача. Проводиться валідація параметрів, введених користувачем. Якщо
     * реєстрація успішна - оновлена інформація зберігається у БД та додається сповіщення успіху на UI
     *
     * @param teacherId          ID авторизованого користувача у HTTP-сесії
     * @param newPassword        новий пароль
     * @param editedTeacher      інформація для оновлення, введена користувачем
     * @param bindingResult      інтерфейс для зручного представлення помилок валідації
     * @param redirectAttributes інтерфейс для збереження атрибутів під час перенапрямлення HTTP-запиту
     * @param model              інтерфейс для додавання атрибутів до моделі на UI
     * @return edit-profile.jsp при помилках валідації або проводить перенапрямлення HTTP-запиту
     * на /teacher при успішному оновленні профіля
     */
    @RequestMapping(value = "/teacher/edit-profile", method = RequestMethod.POST)
    public String editProfile(@ModelAttribute("teacherId") Long teacherId,
                              @RequestParam("newPassword") String newPassword,
                              @ModelAttribute("user") User editedTeacher,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              ModelMap model) {
        logger.info("Get teacher from model attribute: " + editedTeacher);
        User oldTeacher = userDao.findUser(teacherId);

        String newPasswordIncorrectMsg = null;
        if (!newPassword.isEmpty()) {
            newPasswordIncorrectMsg = userValidator.validateNewPassword(newPassword);
        }
        userValidator.validateEmail(editedTeacher.getEmail(), bindingResult);
        userValidator.validatePhoneNumber(editedTeacher.getPhoneNumber(), bindingResult);
        userValidator.validateFirstName(editedTeacher.getFirstName(), bindingResult);
        userValidator.validateLastName(editedTeacher.getLastName(), bindingResult);
        userValidator.validateDateOfBirth(editedTeacher.getDateOfBirth(), bindingResult);

        String editedEmail = editedTeacher.getEmail();
        String email = oldTeacher.getEmail();
        if (!editedEmail.equals(email) && userDao.userExistsByEmail(editedEmail)) {
            bindingResult.rejectValue("email", "validation.user.email.exists");
        }
        String editedPhoneNumber = editedTeacher.getPhoneNumber();
        String phoneNumber = oldTeacher.getPhoneNumber();
        if (!editedPhoneNumber.equals(phoneNumber) && userDao.userExistsByPhoneNumber(editedPhoneNumber)) {
            bindingResult.rejectValue("phoneNumber", "validation.user.phone.exists");
        }
        String inputPassword = editedTeacher.getPassword();
        String password = oldTeacher.getPassword();
        if (!newPassword.isEmpty() && !inputPassword.equals(password)) {
            bindingResult.rejectValue("password", "validation.user.password.incorrect.old");
            model.addAttribute("newPassword", newPassword);
        }

        logger.info("newPasswordIncorrectMsg: " + newPasswordIncorrectMsg);
        if (bindingResult.hasErrors() || newPasswordIncorrectMsg != null) {
            logger.info("binding result errors: " + bindingResult);
            model.addAttribute("user", editedTeacher);
            model.addAttribute("newPasswordIncorrect", newPasswordIncorrectMsg);
            return "edit-profile";
        }

        userDao.editUser(oldTeacher.getUserId(), editedTeacher.getFirstName(),
                editedTeacher.getLastName(), editedTeacher.getEmail(),
                editedTeacher.getDateOfBirth(), editedTeacher.getPhoneNumber(),
                newPassword.isEmpty() ? oldTeacher.getPassword() : newPassword);

        User newTeacher = userDao.findUser(teacherId);
        if (!newTeacher.equals(oldTeacher)) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
        }
        model.clear();
        return "redirect:/teacher";
    }

    /**
     * Показує всіх студентів, яким викладач публікував вікторини
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_general/students.jsp
     */
    @RequestMapping(value = "/teacher/students", method = RequestMethod.GET)
    public String showStudents(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<User> students = userDao.findStudentsByTeacherId(teacherId);
        final List<Group> groups = new ArrayList<>();
        students.forEach(student -> {
            Long groupId = student.getGroupId();
            if (groupId.equals(0L)) {
                groups.add(null);
            } else {
                groups.add(groupDao.findGroup(groupId));
            }
        });

        model.addAttribute("students", students);
        model.addAttribute("groups", groups);

        return "teacher_general/students";
    }
}