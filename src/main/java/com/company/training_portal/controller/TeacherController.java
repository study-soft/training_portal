package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Group;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.SecurityUser;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.QuestionType;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.company.training_portal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.UNPUBLISHED;

@Controller
@PropertySource("classpath:validationMessages.properties")
public class TeacherController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;
    private Environment environment;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             QuestionDao questionDao,
                             Environment environment) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.questionDao = questionDao;
        this.environment = environment;
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
        List<Quiz> unpublishedQuizzes = quizDao.findTeacherQuizzes(teacherId, UNPUBLISHED);
        List<Quiz> publishedQuizzes = quizDao.findTeacherQuizzes(teacherId, PUBLISHED);
        model.addAttribute("unpublishedQuizzes", unpublishedQuizzes);
        model.addAttribute("publishedQuizzes", publishedQuizzes);

        return "teacher/teacher-quizzes";
    }

    @RequestMapping("/teacher/quizzes/{quizId}")
    public String showTeacherQuiz(/*@ModelAttribute("teacherId") Long teacherId,*/
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
        Quiz quiz = quizDao.findQuiz(quizId);
        Map<QuestionType, Integer> questions = questionDao.findQuestionTypesAndCount(quizId);
        model.addAttribute("questions", questions);

        switch (quiz.getTeacherQuizStatus()) {
            case UNPUBLISHED:
                model.addAttribute("unpublishedQuiz", quiz);
                return "teacher/unpublished-quiz";
            case PUBLISHED:
                model.addAttribute("publishedQuiz", quiz);
                return "teacher/published-quiz";
        }
        return "teacher/teacher";
    }

    @RequestMapping(value = "/teacher/groups/create", method = RequestMethod.GET)
    public String showCreateGroup(/*@ModelAttribute("teacherId") Long teacherId,*/ Model model) {
        List<User> students = userDao.findStudentWithoutGroup();
        model.addAttribute("students", students);
        return "create-group";
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
        if (name == null || name.isEmpty()) {
            String emptyName = environment.getProperty("group.name.empty");
            logger.info("Get property 'group.name.empty': " + emptyName);
            List<User> students = userDao.findStudentWithoutGroup();
            model.addAttribute("emptyName", emptyName);
            model.addAttribute("students", students);
            return "create-group";
        } else {
//            List<User> students = userDao.findStudentWithoutGroup();
//            model.addAttribute("students", students);
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

        List<User> students = new ArrayList<>();
        for (Long studentId : studentIds) {
            User student = userDao.findUser(studentId);
            students.add(student);
        }
        Collections.sort(students);

        redirectAttributes.addFlashAttribute("group", group);
        redirectAttributes.addFlashAttribute("students", students);
        model.clear();

        return "redirect:/teacher/groups/create/success";
    }

    @RequestMapping("/teacher/groups/create/success")
    public String showCreateGroupSuccess() {
        return "group-create-success";
    }
}