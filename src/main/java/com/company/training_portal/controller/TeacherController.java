package com.company.training_portal.controller;

import com.company.training_portal.dao.*;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.QuestionType;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.util.Utils;
import com.company.training_portal.validator.QuizValidator;
import com.company.training_portal.validator.UserValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.company.training_portal.model.enums.StudentQuizStatus.CLOSED;
import static com.company.training_portal.model.enums.StudentQuizStatus.OPENED;
import static com.company.training_portal.model.enums.StudentQuizStatus.PASSED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.company.training_portal.util.Utils.formatDateTime;
import static com.company.training_portal.util.Utils.timeUnitsToDuration;

@Controller
@PropertySource("classpath:validationMessages.properties")
@SessionAttributes("teacherId")
public class TeacherController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;
    private Environment environment;
    private UserValidator userValidator;
    private QuizValidator quizValidator;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherController(UserDao userDao,
                             GroupDao groupDao,
                             QuizDao quizDao,
                             QuestionDao questionDao,
                             AnswerSimpleDao answerSimpleDao,
                             AnswerAccordanceDao answerAccordanceDao,
                             AnswerSequenceDao answerSequenceDao,
                             AnswerNumberDao answerNumberDao,
                             Environment environment,
                             UserValidator userValidator,
                             QuizValidator quizValidator) {
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.quizDao = quizDao;
        this.questionDao = questionDao;
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
        this.environment = environment;
        this.userValidator = userValidator;
        this.quizValidator = quizValidator;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    @RequestMapping("/teacher")
    public String showTeacherHome(@ModelAttribute("teacherId") Long teacherId, Model model) {
        User teacher = userDao.findUser(teacherId);
        model.addAttribute("teacher", teacher);
        return "teacher_general/teacher";
    }

    @RequestMapping("/teacher/groups")
    public String showTeacherGroups(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<Group> groups = groupDao.findGroupsWhichTeacherGaveQuiz(teacherId);
        List<Group> teacherGroups = groupDao.findGroups(teacherId);
        groups.removeAll(teacherGroups);

        List<Integer> studentsNumberForGroups = new ArrayList<>();
        List<Integer> studentsNumberForTeacherGroups = new ArrayList<>();
        for (Group group : groups) {
            Integer studentsNumber = groupDao.findStudentsNumberInGroup(group.getGroupId());
            studentsNumberForGroups.add(studentsNumber);
        }
        for (Group group : teacherGroups) {
            Integer studentsNumber = groupDao.findStudentsNumberInGroup(group.getGroupId());
            studentsNumberForTeacherGroups.add(studentsNumber);
        }

        model.addAttribute("groups", groups);
        model.addAttribute("studentsNumberForGroups", studentsNumberForGroups);
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
        List<User> students = userDao.findStudents(groupId);

        model.addAttribute("group", group);
        model.addAttribute("studentsNumber", studentsNumber);
        model.addAttribute("students", students);

        if (teacherGroupsIds.contains(groupId)) {
            return "teacher_group/own-group-info";
        } else {
            return "teacher_group/foreign-group-info";
        }
    }

    @RequestMapping("/teacher/quizzes")
    public String showTeacherQuizzes(@ModelAttribute("teacherId") Long teacherId,
                                     HttpSession session, Model model) {
        List<Quiz> unpublishedQuizzes = quizDao.findUnpublishedQuizzes(teacherId);
        List<Quiz> publishedQuizzes = quizDao.findPublishedQuizzes(teacherId);
        model.addAttribute("unpublishedQuizzes", unpublishedQuizzes);
        model.addAttribute("publishedQuizzes", publishedQuizzes);

        return "teacher_general/quizzes";
    }

    @RequestMapping("/teacher/quizzes/{quizId}")
    public String showTeacherQuiz(@ModelAttribute("teacherId") Long teacherId,
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
        List<Long> teacherQuizIds = quizDao.findTeacherQuizIds(teacherId);
        if (!teacherQuizIds.contains(quizId)) {
            logger.info("access denied");
            return "access-denied";
        }

        logger.info("Access allowed");
        Quiz quiz = quizDao.findQuiz(quizId);
        Map<QuestionType, Integer> questions = questionDao.findQuestionTypesAndCount(quizId);
        Map<String, Integer> stringQuestions = new HashMap<>();
        questions.forEach((k, v) -> stringQuestions.put(k.getQuestionType(), v));

        model.addAttribute("questions", stringQuestions);

        switch (quiz.getTeacherQuizStatus()) {
            case UNPUBLISHED:
                model.addAttribute("unpublishedQuiz", quiz);
                return "teacher_quiz/unpublished-quiz";
            case PUBLISHED:
                List<Group> groups = groupDao.findGroupsForWhichPublished(quizId);
                Map<Long, List<User>> students = new HashMap<>();
                for (Group group : groups) {
                    Long groupId = group.getGroupId();
                    List<User> groupStudents =
                            userDao.findStudentsForWhomPublished(groupId, quizId);
                    students.put(groupId, groupStudents);
                }
                List<User> studentsWithoutGroup =
                        userDao.findStudentsWithoutGroupForWhomPublished(quizId);

                model.addAttribute("publishedQuiz", quiz);
                model.addAttribute("groups", groups);
                model.addAttribute("students", students);
                model.addAttribute("studentsWithoutGroup", studentsWithoutGroup);

                return "teacher_quiz/published-quiz";
        }

        return "teacher_general/teacher";
    }

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

    @RequestMapping("/teacher/results")
    public String showResults(@ModelAttribute("teacherId") Long teacherId, Model model) {
        List<Group> groups = groupDao.findGroupsWhichTeacherGaveQuiz(teacherId);
        model.addAttribute("groups", groups);

        List<User> teacherStudents = userDao.findStudentsWithoutGroup(teacherId);
        model.addAttribute("students", teacherStudents);

        return "teacher_general/results";
    }

    @RequestMapping("/teacher/results/group/{groupId}")
    public String showGroupResults(@ModelAttribute("teacherId") Long teacherId,
                                   @PathVariable("groupId") Long groupId, Model model) {
        List<Quiz> groupQuizzes = quizDao.findGroupQuizzes(groupId, teacherId);
        Integer studentsNumber = groupDao.findStudentsNumberInGroup(groupId);
        model.addAttribute("studentsNumber", studentsNumber);

        List<Quiz> closedQuizzes = new ArrayList<>();
        List<Quiz> passedQuizzes = new ArrayList<>();
        List<LocalDateTime> closingDates = new ArrayList<>();
        List<Map<String, Integer>> quizStudents = new ArrayList<>();

        for (Quiz quiz : groupQuizzes) {
            Long quizId = quiz.getQuizId();
            Integer closedStudents =
                    userDao.findStudentsNumberInGroupWithClosedQuiz(groupId, quizId);
            Map<StudentQuizStatus, Integer> enumMap =
                    quizDao.findStudentsNumberWithStudentQuizStatus(teacherId, groupId, quizId);
            Map<String, Integer> stringMap = new HashMap<>();
            enumMap.forEach((k, v) -> stringMap.put(k.getStudentQuizStatus(), v));
            Integer totalStudents = stringMap
                    .values()
                    .stream()
                    .reduce(0, (x, y) -> x + y);
            stringMap.put("TOTAL", totalStudents);
            if (closedStudents.equals(totalStudents)) {
                closedQuizzes.add(quiz);
                LocalDateTime closingDate = quizDao.findClosingDate(groupId, quizId);
                closingDates.add(closingDate);
            } else {
                passedQuizzes.add(quiz);
                quizStudents.add(stringMap);
            }
        }

        model.addAttribute("closedQuizzes", closedQuizzes);
        model.addAttribute("closingDates", closingDates);
        model.addAttribute("passedQuizzes", passedQuizzes);
        model.addAttribute("quizStudents", quizStudents);

        Group group = groupDao.findGroup(groupId);
        model.addAttribute("group", group);

        return "teacher_results/group";
    }

    @RequestMapping("/teacher/results/group/{groupId}/quiz/{quizId}")
    public String showGroupQuizResults(@ModelAttribute("teacherId") Long teacherId,
                                       @PathVariable("groupId") Long groupId,
                                       @PathVariable("quizId") Long quizId,
                                       Model model) {
        Group group = groupDao.findGroup(groupId);
        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("group", group);
        model.addAttribute("quiz", quiz);

        List<User> openedStudents = userDao.findStudents(groupId, quizId, OPENED);
        List<User> passedStudents = userDao.findStudents(groupId, quizId, PASSED);
        List<User> closedStudents = userDao.findStudents(groupId, quizId, CLOSED);
        model.addAttribute("openedStudents", openedStudents);
        model.addAttribute("passedStudents", passedStudents);
        model.addAttribute("closedStudents", closedStudents);

        List<OpenedQuiz> openedQuizzes = new ArrayList<>();
        for (User student : openedStudents) {
            OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(student.getUserId(), quizId);
            openedQuizzes.add(openedQuiz);
        }
        model.addAttribute("openedQuizzes", openedQuizzes);

        List<PassedQuiz> passedQuizzes = new ArrayList<>();
        for (User student : passedStudents) {
            PassedQuiz passedQuiz = quizDao.findPassedQuiz(student.getUserId(), quizId);
            passedQuizzes.add(passedQuiz);
        }
        model.addAttribute("passedQuizzes", passedQuizzes);

        List<PassedQuiz> closedQuizzes = new ArrayList<>();
        for (User student : closedStudents) {
            PassedQuiz closedQuiz = quizDao.findClosedQuiz(student.getUserId(), quizId);
            closedQuizzes.add(closedQuiz);
        }
        model.addAttribute("closedQuizzes", closedQuizzes);

        return "teacher_results/group-quiz";
    }

    @RequestMapping(value = "/teacher/results/group/{groupId}/close", method = RequestMethod.POST)
    @ResponseBody
    public List<String> closeQuizToGroup(@PathVariable("groupId") Long groupId,
                                         @RequestParam("quizId") Long quizId) {
        quizDao.editStudentsInfoWithOpenedQuizStatus(groupId, quizId);
        quizDao.closeQuizToGroup(groupId, quizId);
        List<String> closedQuizInfo = new ArrayList<>();
        closedQuizInfo.add(quizDao.findQuiz(quizId).getName());
        closedQuizInfo.add(formatDateTime(LocalDateTime.now()));
        return closedQuizInfo;
    }

    @RequestMapping(value = "/teacher/results/group/{groupId}/quiz/{quizId}/close", method = RequestMethod.POST)
    @ResponseBody
    public List<String> closeQuizToStudentFromStudents(@PathVariable("groupId") Long groupId,
                                                       @PathVariable("quizId") Long quizId,
                                                       @RequestParam("studentId") Long studentId) {
        return closeQuizToStudent(studentId, quizId);
    }

    @RequestMapping(value = "/teacher/students/{studentId}/close", method = RequestMethod.POST)
    @ResponseBody
    public List<String> closeQuizToStudentFromResults(@PathVariable("studentId") Long studentId,
                                                      @RequestParam("quizId") Long quizId) {
        return closeQuizToStudent(studentId, quizId);
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

        return "/teacher_results/student";
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/edit", method = RequestMethod.GET)
    public String showEditQuiz(@PathVariable("quizId") Long quizId, Model model) {
        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

        Duration passingTime = quiz.getPassingTime();
        if (passingTime != null) {
            List<Integer> timeUnits = Utils.durationToTimeUnits(passingTime);
            model.addAttribute("hours", timeUnits.get(0));
            model.addAttribute("minutes", timeUnits.get(1));
            model.addAttribute("seconds", timeUnits.get(2));
        }

        return "teacher_quiz/quiz-edit";
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/edit", method = RequestMethod.POST)
    public String editQuiz(@PathVariable("quizId") Long quizId,
                           @ModelAttribute("quiz") Quiz editedQuiz,
                           BindingResult bindingResult,
                           @RequestParam(value = "enabled", required = false)
                                   String enabled,
                           @RequestParam(value = "hours", required = false)
                                   String hours,
                           @RequestParam(value = "minutes", required = false)
                                   String minutes,
                           @RequestParam(value = "seconds", required = false)
                                   String seconds,
                           RedirectAttributes redirectAttributes, ModelMap model) {
        quizValidator.validate(editedQuiz, bindingResult);
        if (enabled != null) {
            quizValidator.validatePassingTime(hours, minutes, seconds, bindingResult);
        }

        Quiz oldQuiz = quizDao.findQuiz(quizId);
        String editedName = editedQuiz.getName();
        String name = oldQuiz.getName();
        if (!editedName.equals(name) && quizDao.quizExistsByName(editedName)) {
            bindingResult.rejectValue("name", "quiz.name.exists");
        }
        if (bindingResult.hasErrors()) {
            model.addAttribute("quiz", editedQuiz);
            return "teacher_quiz/quiz-edit";
        }

        Duration editedPassingTime = null;
        if (enabled != null) {
            editedPassingTime = timeUnitsToDuration(
                    hours.isEmpty() ? 0 : Integer.valueOf(hours),
                    minutes.isEmpty() ? 0 : Integer.valueOf(minutes),
                    seconds.isEmpty() ? 0 : Integer.valueOf(seconds));
        }
        quizDao.editQuiz(oldQuiz.getQuizId(), editedQuiz.getName(), editedQuiz.getDescription(),
                editedQuiz.getExplanation(), editedPassingTime);

        Quiz newQuiz = quizDao.findQuiz(quizId);
        if (!oldQuiz.equals(newQuiz)) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
        }
        model.clear();

        return "redirect:/teacher/quizzes/" + quizId;
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/publication", method = RequestMethod.GET)
    public String showQuizPublication(@ModelAttribute("teacherId") Long teacherId,
                                      @PathVariable("quizId") Long quizId,
                                      Model model) {
        List<Long> teacherQuizIds = quizDao.findTeacherQuizIds(teacherId);
        if (!teacherQuizIds.contains(quizId)) {
            logger.info("access denied");
            return "access-denied";
        }

        logger.info("access allowed");
        Quiz quiz = quizDao.findQuiz(quizId);
        List<Group> groups = groupDao.findGroupsForQuizPublication(quizId);
        Map<Long, List<User>> students = new HashMap<>();
        for (Group group : groups) {
            Long groupId = group.getGroupId();
            List<User> groupStudents = userDao.findStudentsForQuizPublication(groupId, quizId);
            students.put(groupId, groupStudents);
        }
        List<User> studentsWithoutGroup = userDao.findStudentsWithoutGroupForQuizPublication(quizId);

        model.addAttribute("quiz", quiz);
        model.addAttribute("groups", groups);
        model.addAttribute("students", students);
        model.addAttribute("studentsWithoutGroup", studentsWithoutGroup);

        return "teacher_quiz/quiz-publication";
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/publication", method = RequestMethod.POST)
    public String publishQuiz(@PathVariable("quizId") Long quizId,
                              @RequestParam Map<String, String> studentIdsMap,
                              RedirectAttributes redirectAttributes) {
        quizDao.editTeacherQuizStatus(PUBLISHED, quizId);

        List<Long> studentIds = studentIdsMap.values()
                .stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());

        quizDao.addPublishedQuizInfo(studentIds, quizId);
        redirectAttributes.addFlashAttribute("publicationSuccess", true);

        return "redirect:/teacher/quizzes/" + quizId;
    }

    @RequestMapping("/teacher/quizzes/{quizId}/questions/update")
    @ResponseBody
    public ResponseEntity<?> editQuestion(@PathVariable("quizId") Long quizId,
                                          @RequestParam Map<String, String> params) {
        logger.info(params);
        QuestionType questionType = QuestionType.valueOf(params.get("type"));
        Integer score = Integer.valueOf(params.get("points"));
        String questionBody = params.get("question");
        String explanation = params.get("explanation");

        Question question = new Question.QuestionBuilder()
                .quizId(quizId)
                .body(questionBody)
                .explanation(explanation)
                .questionType(questionType)
                .score(score)
                .build();

        params.remove("type");
        params.remove("points");
        params.remove("question");
        params.remove("explanation");

        boolean editingQuestion = true;
        Long questionId;
        String paramQuestionId = params.get("questionId");
        logger.info("paramQuestionId: " + paramQuestionId);
        if (paramQuestionId == null) {
            editingQuestion = false;
            questionId = questionDao.addQuestion(question);
        } else {
            questionId = Long.valueOf(paramQuestionId);
            question.setQuestionId(questionId);
            questionDao.editQuestion(question);
            params.remove("questionId");
        }

        switch (questionType) {
            case ONE_ANSWER:
                if (editingQuestion) {
                    answerSimpleDao.deleteAnswersSimple(questionId);
                }

                String correctAnswer = params.get("correct");
                params.remove("correct");

                for (String answer : params.keySet()) {
                    boolean correct = false;
                    String answerBody = params.get(answer);
                    if (answer.equals(correctAnswer)) {
                        correct = true;
                    }
                    AnswerSimple answerSimple = new AnswerSimple.AnswerSimpleBuilder()
                            .questionId(questionId)
                            .body(answerBody)
                            .correct(correct)
                            .build();
                    answerSimpleDao.addAnswerSimple(answerSimple);
                }
                break;
            case FEW_ANSWERS:
                if (editingQuestion) {
                    answerSimpleDao.deleteAnswersSimple(questionId);
                }

                Set<String> answers = new LinkedHashSet<>();
                Set<String> correctAnswers = new HashSet<>();
                for (String key : params.keySet()) {
                    if (key.contains("correct")) {
                        correctAnswers.add(params.get(key));
                    } else {
                        answers.add(key);
                    }
                }

                for (String answer : answers) {
                    boolean correct = false;
                    String answerBody = params.get(answer);
                    if (correctAnswers.contains(answer)) {
                        correct = true;
                    }
                    AnswerSimple answerSimple = new AnswerSimple.AnswerSimpleBuilder()
                            .questionId(questionId)
                            .body(answerBody)
                            .correct(correct)
                            .build();
                    answerSimpleDao.addAnswerSimple(answerSimple);
                }
                break;
            case ACCORDANCE:
                List<String> leftSide = new ArrayList<>();
                List<String> rightSide = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    leftSide.add(params.get("left" + i));
                    rightSide.add(params.get("right" + i));
                }

                AnswerAccordance answerAccordance = new AnswerAccordance.AnswerAccordanceBuilder()
                        .questionId(questionId)
                        .leftSide(leftSide)
                        .rightSide(rightSide)
                        .build();
                if (editingQuestion) {
                    answerAccordanceDao.editAnswerAccordance(answerAccordance);
                } else {
                    answerAccordanceDao.addAnswerAccordance(answerAccordance);
                }
                break;
            case SEQUENCE:
                List<String> correctList = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    correctList.add(params.get("sequence" + i));
                }

                AnswerSequence answerSequence = new AnswerSequence.AnswerSequenceBuilder()
                        .questionId(questionId)
                        .correctList(correctList)
                        .build();
                if (editingQuestion) {
                    answerSequenceDao.editAnswerSequence(answerSequence);
                } else {
                    answerSequenceDao.addAnswerSequence(answerSequence);
                }
                break;
            case NUMBER:
                Integer number = Integer.valueOf(params.get("number"));
                AnswerNumber answerNumber = new AnswerNumber.AnswerNumberBuilder()
                        .questionId(questionId)
                        .correct(number)
                        .build();
                if (editingQuestion) {
                    answerNumberDao.editAnswerNumber(answerNumber);
                } else {
                    answerNumberDao.addAnswerNumber(answerNumber);
                }
                break;
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @RequestMapping("/teacher/quizzes/{quizId}/questions/delete")
    @ResponseBody
    public ResponseEntity<?> deleteQuestion(@PathVariable("quizId") Long quizId,
                                            @RequestParam("questionId") Long questionId) {
        questionDao.deleteQuestion(questionId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // INTERNALS===================================================

    private List<String> closeQuizToStudent(Long studentId, Long quizId) {
        StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
        List<String> closedQuizInfo = new ArrayList<>();
        switch (status) {
            case OPENED:
                quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, 0,
                        LocalDateTime.now(), 0, CLOSED);
                PassedQuiz closedQuiz = quizDao.findClosedQuiz(studentId, quizId);
                closedQuizInfo.add(formatDateTime(closedQuiz.getFinishDate()));
                closedQuizInfo.add(String.valueOf(closedQuiz.getResult() + " / " + closedQuiz.getScore()));
                closedQuizInfo.add(String.valueOf(closedQuiz.getAttempt()));
                closedQuizInfo.add("00:00");
                break;
            case PASSED:
                quizDao.closeQuizToStudent(studentId, quizId);
                break;
            case CLOSED:
                logger.error("Can not close already closed quiz");
                break;
        }
        return closedQuizInfo;
    }
}