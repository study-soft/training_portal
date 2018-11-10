package com.company.training_portal.controller;

import com.company.training_portal.dao.*;
import com.company.training_portal.model.*;
import com.company.training_portal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

import static com.company.training_portal.util.Utils.maskPassword;

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

    @RequestMapping("/teacher")
    public String showTeacherHome(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        teacher.setPassword(maskPassword(teacher.getPassword()));
        model.addAttribute("teacher", teacher);
        return "teacher_general/teacher";
    }

    @RequestMapping(value = "/teacher/edit-profile", method = RequestMethod.GET)
    public String showEditProfile(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        teacher.setPassword("");
        model.addAttribute("user", teacher);
        return "edit-profile";
    }

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

    @RequestMapping("/teacher/students")
    public String showStudents(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<User> students = userDao.findStudentsByTeacherId(teacherId);
        List<Group> groups = new ArrayList<>();
        for (User student : students) {
            Long groupId = student.getGroupId();
            if (groupId == 0) {
                groups.add(null);
            } else {
                groups.add(groupDao.findGroup(groupId));
            }
        }

        model.addAttribute("students", students);
        model.addAttribute("groups", groups);

        return "teacher_general/students";
    }
}