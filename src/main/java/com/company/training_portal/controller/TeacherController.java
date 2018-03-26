package com.company.training_portal.controller;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.QuestionType;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static com.company.training_portal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.UNPUBLISHED;

@Controller
@PropertySource("classpath:validationMessages.properties")
@SessionAttributes("teacherId")
public class TeacherController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;
    private Environment environment;
    private Validator userValidator;
    private StudentController studentController;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             QuestionDao questionDao,
                             Environment environment,
                             @Qualifier("userValidator") Validator userValidator,
                             StudentController studentController) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.environment = environment;
        this.userValidator = userValidator;
        this.studentController = studentController;
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
    public String showGroupInfo(@PathVariable("groupId") Long groupId, Model model) {
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
    public String showTeacherQuiz(@PathVariable("quizId") Long quizId,
                                  Model model) {
        Quiz quiz = quizDao.findQuiz(quizId);
        Map<QuestionType, Integer> questions = questionDao.findQuestionTypesAndCount(quizId);

        Map<String, Integer> stringQuestions = new HashMap<>();
        questions.forEach((k, v) -> stringQuestions.put(k.getQuestionType(), v));

        model.addAttribute("questions", stringQuestions);

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
    public String showCreateGroup(Model model) {
        List<User> students = userDao.findStudentsWithoutGroup();
        model.addAttribute("students", students);
        return "teacher/group-create";
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
            return "teacher/group-create";
        }
        if (groupDao.groupExists(name)) {
            String groupExists = environment.getProperty("group.name.exists");
            logger.info("Get property 'group.name.exists': " + groupExists);
            List<User> students = userDao.findStudentsWithoutGroup();
            model.addAttribute("groupExists", groupExists);
            model.addAttribute("students", students);
            return "teacher/group-create";
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

        return "teacher/group-add-students";
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
            return "teacher/group-deleted";
        }
        return "teacher/group-deleted";
    }

    @RequestMapping(value = "/teacher/edit-profile", method = RequestMethod.GET)
    public String showEditProfile(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        model.addAttribute("user", teacher);
        model.addAttribute("dateOfBirth", teacher.getDateOfBirth());
        return "edit-profile";
    }

    @RequestMapping(value = "/teacher/edit-profile", method = RequestMethod.POST)
    public String editProfile(@ModelAttribute("teacherId") Long teacherId,
                              @ModelAttribute("user") User editedTeacher,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              ModelMap model) {
        logger.info("Get teacher from model attribute: " + editedTeacher);
        User oldTeacher = userDao.findUser(teacherId);
        model.addAttribute("oldTeacher", oldTeacher);

        editedTeacher.setLogin(oldTeacher.getLogin());
        editedTeacher.setUserRole(oldTeacher.getUserRole());

        userValidator.validate(editedTeacher, bindingResult);

        String editedEmail = editedTeacher.getEmail();
        String email = oldTeacher.getEmail();
        if (!editedEmail.equals(email) && userDao.userExistsByEmail(editedEmail)) {
            bindingResult.rejectValue("email", "user.email.exists");
        }
        String editedPhoneNumber = editedTeacher.getPhoneNumber();
        String phoneNumber = oldTeacher.getPhoneNumber();
        if (!editedPhoneNumber.equals(phoneNumber) && userDao.userExistsByPhoneNumber(editedPhoneNumber)) {
            bindingResult.rejectValue("phoneNumber", "user.phoneNumber.exists");
        }
        if (bindingResult.hasErrors()) {
            model.addAttribute("user", editedTeacher);
            return "edit-profile";
        }

        userDao.editUser(oldTeacher.getUserId(), editedTeacher.getFirstName(),
                editedTeacher.getLastName(), editedTeacher.getEmail(),
                editedTeacher.getDateOfBirth(), editedTeacher.getPhoneNumber(),
                editedTeacher.getPassword());

        redirectAttributes.addFlashAttribute("editSuccess", true);
        model.clear();
        return "redirect:/teacher";
    }

    @RequestMapping(value = "/teacher/groups/{groupId}/edit", method = RequestMethod.GET)
    public String showEditGroup(@PathVariable("groupId") Long groupId, Model model) {
        Group group = groupDao.findGroup(groupId);
        List<User> students = userDao.findStudents(groupId);

        model.addAttribute("group", group);
        model.addAttribute("students", students);

        return "teacher/group-edit";
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
            return "teacher/group-edit";
        }
        String name = oldGroup.getName();
        if (!editedName.equals(name) && groupDao.groupExists(editedName)) {
            String groupExists = environment.getProperty("group.name.exists");
            List<User> students = userDao.findStudents(groupId);
            model.addAttribute("group", oldGroup);
            model.addAttribute("students", students);
            model.addAttribute("groupExists", groupExists);
            return "teacher/group-edit";
        }

        Group editedGroup = new Group.GroupBuilder()
                .groupId(oldGroup.getGroupId())
                .name(editedName)
                .description(editedDescription)
                .creationDate(oldGroup.getCreationDate())
                .authorId(oldGroup.getAuthorId())
                .build();
        groupDao.editGroup(editedGroup);

        redirectAttributes.addFlashAttribute("editSuccess", true);
        model.clear();
        return "redirect:/teacher/groups/" + groupId;
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

        return "teacher/teacher-students";
    }

    @RequestMapping("/teacher/results")
    public String showResults(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<Group> groups = groupDao.findGroupsWhichTeacherGaveQuiz(teacherId);
        List<User> students = userDao.findStudentsWithoutGroup(teacherId);

        model.addAttribute("groups", groups);
        model.addAttribute("students", students);

        return "teacher/teacher-results";
    }

    @RequestMapping("/teacher/results/group/{groupId}")
    public String showGroupQuizzes(@PathVariable("groupId") Long groupId, Model model) {
        return "";
    }

    @RequestMapping("/teacher/students/{studentId}")
    public String showStudent(@ModelAttribute("teacherId") Long teacherId,
            @PathVariable("studentId") Long studentId, Model model) {
        User student = userDao.findUser(studentId);
        model.addAttribute("student", student);

        if (student.getGroupId() != 0) {
            Group group = groupDao.findGroup(student.getGroupId());
            model.addAttribute("group", group);
        }

        List<OpenedQuiz> openedQuizzes = quizDao.findOpenedQuizzes(studentId, teacherId);
        List<PassedQuiz> passedQuizzes = quizDao.findPassedQuizzes(studentId, teacherId);
        List<PassedQuiz> closedQuizzes = quizDao.findClosedQuizzes(studentId, teacherId);
        model.addAttribute("openedQuizzes", openedQuizzes);
        model.addAttribute("passedQuizzes", passedQuizzes);
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "/student_general/student-info";
    }
}