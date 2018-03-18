package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Group;
import com.company.training_portal.model.SecurityUser;
import com.company.training_portal.model.User;
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

@Controller
public class TeacherController {

    private UserDao userDao;
    private GroupDao groupDao;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherController(UserDao userDao,
                             GroupDao groupDao) {
        this.userDao = userDao;
        this.groupDao = groupDao;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping("/teacher")
    public String showTeacherHome(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        model.addAttribute("teacher", teacher);
        return "teacher";
    }

    @RequestMapping("/teacher/groups")
    public String showGroups(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<Group> groups = groupDao.findGroups(teacherId);
        List<Integer> studentsNumber = new ArrayList<>();
        for (Group group : groups) {
            Long groupId = group.getGroupId();
            studentsNumber.add(groupDao.findStudentsNumberInGroup(groupId));
        }

        model.addAttribute("groups", groups);
        model.addAttribute("studentsNumber", studentsNumber);

        return "teacher-groups";
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

        return "group-info";
    }
}