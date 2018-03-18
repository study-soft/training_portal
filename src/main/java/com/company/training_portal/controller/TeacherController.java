package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.TeacherQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.company.training_portal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.UNPUBLISHED;

@Controller
public class TeacherController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.quizDao = quizDao;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping("/teacher")
    public String showTeacherHome(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        model.addAttribute("teacher", teacher);
        return "teacher/teacher";
    }

    @RequestMapping("/teacher/groups")
    public String showTeacherGroups(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<Group> groups = groupDao.findGroups(teacherId);
        List<Integer> studentsNumber = new ArrayList<>();
        for (Group group : groups) {
            Long groupId = group.getGroupId();
            studentsNumber.add(groupDao.findStudentsNumberInGroup(groupId));
        }

        model.addAttribute("groups", groups);
        model.addAttribute("studentsNumber", studentsNumber);

        return "teacher/teacher-groups";
    }

    @RequestMapping("/teacher/groups/{groupId}")
    public String showGroupInfo(@ModelAttribute("teacherId") Long teacherId,
                                @PathVariable("groupId") Long groupId, Model model) {
        Group group = groupDao.findGroup(groupId);
        Integer studentsNumber = groupDao.findStudentsNumberInGroup(groupId);
        List<User> students = userDao.findStudents(groupId);

        model.addAttribute("group", group);
        model.addAttribute("studentsNumber", studentsNumber);
        model.addAttribute("students", students);

        return "teacher/group-info";
    }

    @RequestMapping("/teacher/quizzes")
    public String showTeacherQuizzes(@ModelAttribute("teacherId") Long teacherId,
                              Model model) {

        return "teacher/teacher-quizzes";
    }
}