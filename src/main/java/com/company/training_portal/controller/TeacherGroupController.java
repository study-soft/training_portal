package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Group;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.SecurityUser;
import com.company.training_portal.model.User;
import com.company.training_portal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static java.util.Arrays.asList;

@Controller
@PropertySource("classpath:validationMessages.properties")
@SessionAttributes("teacherId")
public class TeacherGroupController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private Environment environment;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherGroupController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             Environment environment) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.quizDao = quizDao;
        this.environment = environment;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    // GROUP SHOW ===================================================================

    @RequestMapping("/teacher/groups")
    public String showTeacherGroups(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<Group> groups = groupDao.findGroupsWhichTeacherGaveQuiz(teacherId);
        List<Group> teacherGroups = groupDao.findGroups(teacherId);
        groups.removeAll(teacherGroups);

        List<Integer> studentsNumberForGroups = new ArrayList<>();
        List<Integer> studentsNumberForTeacherGroups = new ArrayList<>();
        List<User> authors = new ArrayList<>();
        for (Group group : groups) {
            Integer studentsNumber = groupDao.findStudentsNumberInGroup(group.getGroupId());
            studentsNumberForGroups.add(studentsNumber);
            User author = userDao.findUser(group.getAuthorId());
            authors.add(author);
        }
        for (Group group : teacherGroups) {
            Integer studentsNumber = groupDao.findStudentsNumberInGroup(group.getGroupId());
            studentsNumberForTeacherGroups.add(studentsNumber);
        }

        model.addAttribute("groups", groups);
        model.addAttribute("studentsNumberForGroups", studentsNumberForGroups);
        model.addAttribute("authors", authors);
        model.addAttribute("teacherGroups", teacherGroups);
        model.addAttribute("studentsNumberForTeacherGroups", studentsNumberForTeacherGroups);

        return "teacher_general/groups";
    }

    @RequestMapping("/teacher/groups/{groupId}")
    public String showGroupInfo(@ModelAttribute("teacherId") Long teacherId,
                                @PathVariable("groupId") Long groupId, Model model) {
        List<Group> teacherGroups = groupDao.findGroups(teacherId);
        List<Long> teacherGroupsIds = teacherGroups.stream()
                .map(Group::getGroupId)
                .collect(Collectors.toList());

        Group group = groupDao.findGroup(groupId);
        Integer studentsNumber = groupDao.findStudentsNumberInGroup(groupId);
        List<User> studentsList = userDao.findStudents(groupId);
        List<Quiz> publishedQuizzes = quizDao.findPublishedQuizzes(groupId, teacherId);

        List<String> statuses = new ArrayList<>();
        Map<Long, List<Integer>> studentsProgress = new HashMap<>();
        for (Quiz quiz : publishedQuizzes) {
            Long quizId = quiz.getQuizId();
            Integer studentsNumberForQuiz =
                    userDao.findStudentsNumber(groupId, quizId);
            Integer closedStudents =
                    userDao.findStudentsNumberInGroupWithClosedQuiz(groupId, quizId);
            studentsProgress.put(quizId, asList(closedStudents, studentsNumberForQuiz));
            if (closedStudents.equals(studentsNumberForQuiz)) {
                statuses.add("Closed");
            } else {
                statuses.add("Passes");
            }
        }

        model.addAttribute("group", group);
        model.addAttribute("studentsNumber", studentsNumber);
        model.addAttribute("studentsList", studentsList);
        model.addAttribute("publishedQuizzes", publishedQuizzes);
        model.addAttribute("statuses", statuses);
        model.addAttribute("studentsProgress", studentsProgress);

        if (teacherGroupsIds.contains(groupId)) {
            return "teacher_group/own-group-info";
        } else {
            return "teacher_group/foreign-group-info";
        }
    }

    // GROUP CREATE ===============================================================

    @RequestMapping(value = "/teacher/groups/create", method = RequestMethod.GET)
    public String showCreateGroup(Model model) {
        List<User> students = userDao.findStudentsWithoutGroup();
        model.addAttribute("students", students);
        return "teacher_group/group-create";
    }

    @RequestMapping(value = "/teacher/groups/create", method = RequestMethod.POST)
    public String createGroup(@RequestParam("name") String name,
                              @RequestParam("description") String description,
                              @RequestParam Map<String, String> studentIdsMap,
                              @ModelAttribute("teacherId") Long teacherId,
                              RedirectAttributes redirectAttributes, ModelMap model) {
        logger.info("request param 'name' = " + name);
        logger.info("request param 'description' = " + description);
        logger.info("request param 'studentIdsMap' = " + studentIdsMap);
        name = name.trim();
        if (name.isEmpty()) {
            String emptyName = environment.getProperty("group.name.empty");
            logger.info("Get property 'group.name.empty': " + emptyName);
            List<User> students = userDao.findStudentsWithoutGroup();
            model.addAttribute("emptyName", emptyName);
            model.addAttribute("students", students);
            return "teacher_group/group-create";
        }
        if (groupDao.groupExists(name)) {
            String groupExists = environment.getProperty("group.name.exists");
            logger.info("Get property 'group.name.exists': " + groupExists);
            List<User> students = userDao.findStudentsWithoutGroup();
            model.addAttribute("groupExists", groupExists);
            model.addAttribute("students", students);
            return "teacher_group/group-create";
        }

        studentIdsMap.remove("name");
        studentIdsMap.remove("description");

        LocalDate creationDate = LocalDate.now();
        Group group = new Group.GroupBuilder()
                .name(name)
                .description(description)
                .creationDate(creationDate)
                .authorId(teacherId)
                .build();
        Long groupId = groupDao.addGroup(group);

        List<Long> studentIds = studentIdsMap.values().stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());
        userDao.addStudentsToGroup(groupId, studentIds);

        redirectAttributes.addFlashAttribute("createSuccess", true);
        model.clear();
        return "redirect:/teacher/groups/" + groupId;
    }

    @RequestMapping(value = "/teacher/groups/{groupId}/add-students", method = RequestMethod.GET)
    public String showAddStudents(@PathVariable("groupId") Long groupId, Model model) {
        Group group = groupDao.findGroup(groupId);
        List<User> students = userDao.findStudentsWithoutGroup();

        model.addAttribute("group", group);
        model.addAttribute("students", students);

        return "teacher_group/group-add-students";
    }

    @RequestMapping(value = "/teacher/groups/{groupId}/add-students", method = RequestMethod.POST)
    @ResponseBody
    public List<User> addStudents(@PathVariable("groupId") Long groupId,
                                  @RequestParam Map<String, String> studentIdsMap) {
        logger.info("request param map: " + studentIdsMap);

        List<Long> studentIds = studentIdsMap.values().stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());
        userDao.addStudentsToGroup(groupId, studentIds);

        List<User> students = new ArrayList<>();
        for (Long studentId : studentIds) {
            User student = userDao.findUser(studentId);
            students.add(student);
        }
        Collections.sort(students);

        return students;
    }

    // GROUP EDIT ==================================================================

    @RequestMapping(value = "/teacher/groups/{groupId}/edit", method = RequestMethod.GET)
    public String showEditGroup(@PathVariable("groupId") Long groupId, Model model) {
        Group group = groupDao.findGroup(groupId);
        List<User> students = userDao.findStudents(groupId);

        model.addAttribute("group", group);
        model.addAttribute("students", students);

        return "teacher_group/group-edit";
    }

    @RequestMapping(value = "/teacher/groups/{groupId}/edit", method = RequestMethod.POST)
    public String editGroup(@PathVariable("groupId") Long groupId,
                            @RequestParam("name") String editedName,
                            @RequestParam("description") String editedDescription,
                            RedirectAttributes redirectAttributes,
                            ModelMap model) {
        Group oldGroup = groupDao.findGroup(groupId);
        editedName = editedName.trim();
        if (editedName.isEmpty()) {
            String emptyName = environment.getProperty("group.name.empty");
            List<User> students = userDao.findStudents(groupId);
            model.addAttribute("group", oldGroup);
            model.addAttribute("students", students);
            model.addAttribute("emptyName", emptyName);
            return "teacher_group/group-edit";
        }
        String name = oldGroup.getName();
        if (!editedName.equals(name) && groupDao.groupExists(editedName)) {
            String groupExists = environment.getProperty("group.name.exists");
            List<User> students = userDao.findStudents(groupId);
            model.addAttribute("group", oldGroup);
            model.addAttribute("students", students);
            model.addAttribute("groupExists", groupExists);
            return "teacher_group/group-edit";
        }

        Group editedGroup = new Group.GroupBuilder()
                .groupId(oldGroup.getGroupId())
                .name(editedName)
                .description(editedDescription)
                .creationDate(oldGroup.getCreationDate())
                .authorId(oldGroup.getAuthorId())
                .build();
        groupDao.editGroup(editedGroup);

        if (!oldGroup.equals(editedGroup)) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
        }
        model.clear();
        return "redirect:/teacher/groups/" + groupId;
    }

    // GROUP DELETE ================================================================

    @RequestMapping(value = "/teacher/groups/{groupId}/delete-student", method = RequestMethod.POST)
    @ResponseBody
    public Long deleteStudentFromGroup(@PathVariable("groupId") Long groupId,
                                       @RequestParam("studentId") Long studentId) {
        userDao.deleteStudentFromGroupByUserId(studentId);
        return studentId;
    }

    @RequestMapping(value = "/teacher/groups/{groupId}/delete", method = RequestMethod.POST)
    public String deleteGroup(@PathVariable("groupId") Long groupId, Model model) {
        try {
            Group group = groupDao.findGroup(groupId);
            List<User> students = userDao.findStudents(groupId);
            model.addAttribute("group", group);
            model.addAttribute("students", students);
            groupDao.deleteGroup(groupId);
        } catch (EmptyResultDataAccessException e) {
            model.addAttribute("groupAlreadyDeleted", true);
            return "teacher_group/group-deleted";
        }
        return "teacher_group/group-deleted";
    }
}
