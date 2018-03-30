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

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

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
    private StudentController studentController;

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
                             QuizValidator quizValidator,
                             StudentController studentController) {
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
        List<Group> activeGroups = groupDao.findGroupsWhichTeacherGaveQuiz(teacherId);
        List<Group> teacherGroups = groupDao.findGroups(teacherId);
        activeGroups.addAll(teacherGroups);
        Set<Group> allGroupsSet = new HashSet<>(activeGroups);
        List<Group> allGroups = new ArrayList<>(allGroupsSet);
        Collections.sort(allGroups);

        List<Long> teacherGroupsIds = teacherGroups.stream()
                .map(Group::getGroupId)
                .collect(Collectors.toList());

        List<Integer> studentsNumber = new ArrayList<>();
        for (Group group : allGroups) {
            Long groupId = group.getGroupId();
            studentsNumber.add(groupDao.findStudentsNumberInGroup(groupId));
        }

        model.addAttribute("groups", allGroups);
        model.addAttribute("teacherGroupsIds", teacherGroupsIds);
        model.addAttribute("studentsNumber", studentsNumber);

        return "teacher/teacher-groups";
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
            return "teacher/own-group-info";
        } else {
            return "teacher/foreign-group-info";
        }
    }

    @RequestMapping("/teacher/quizzes")
    public String showTeacherQuizzes(@ModelAttribute("teacherId") Long teacherId,
                                     Model model) {
        List<Quiz> unpublishedQuizzes = quizDao.findUnpublishedQuizzes(teacherId);
        List<Quiz> publishedQuizzes = quizDao.findPublishedQuizzes(teacherId);
        model.addAttribute("unpublishedQuizzes", unpublishedQuizzes);
        model.addAttribute("publishedQuizzes", publishedQuizzes);

        return "teacher/teacher-quizzes";
    }

    @RequestMapping("/teacher/quizzes/{quizId}")
    public String showTeacherQuiz(@ModelAttribute("teacherId") Long teacherId,
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
        Quiz quiz = quizDao.findQuiz(quizId);
        List<Long> teacherQuizIds = quizDao.findTeacherQuizIds(teacherId);

        if (teacherQuizIds.contains(quiz.getQuizId())) {
            logger.info("Access allowed");
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
        } else {
            logger.info("access denied");
            return "access-denied";
        }
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
        model.addAttribute("groups", groups);

        List<User> teacherSingleStudents = new ArrayList<>();
        List<Group> singleStudentGroups = new ArrayList<>();
        List<User> teacherStudents = userDao.findStudentsByTeacherId(teacherId);
        for (User student : teacherStudents) {
            List<Long> commonGroupQuizIds = quizDao.findCommonGroupQuizIds(student.getGroupId());
            List<Long> studentQuizIds = quizDao.findQuizzes(student.getUserId(), teacherId)
                    .stream()
                    .map(Quiz::getQuizId)
                    .collect(Collectors.toList());
            if (!commonGroupQuizIds.containsAll(studentQuizIds)) {
                teacherSingleStudents.add(student);
                Long groupId = student.getGroupId();
                if (groupId == 0) {
                    singleStudentGroups.add(null);
                } else {
                    singleStudentGroups.add(groupDao.findGroup(groupId));
                }
            }
        }

        model.addAttribute("singleStudentGroups", singleStudentGroups);
        model.addAttribute("students", teacherSingleStudents);

        return "teacher/teacher-results";
    }

    @RequestMapping("/teacher/results/group/{groupId}")
    public String showGroupResults(@ModelAttribute("teacherId") Long teacherId,
                                   @PathVariable("groupId") Long groupId, Model model) {
        List<Quiz> quizzes = quizDao.findCommonGroupQuizzes(groupId, teacherId);
        Integer studentsNumber = groupDao.findStudentsNumberInGroup(groupId);
        model.addAttribute("studentsNumber", studentsNumber);

        List<Quiz> closedQuizzes = new ArrayList<>();
        List<LocalDateTime> closingDates = new ArrayList<>();
        List<Map<String, Integer>> students = new ArrayList<>();

        for (Quiz quiz : quizzes) {
            Long quizId = quiz.getQuizId();
            Integer closedStudents =
                    userDao.findStudentsNumberInGroupWithClosedQuiz(groupId, quizId);
            if (closedStudents.equals(studentsNumber)) {
                closedQuizzes.add(quiz);
                LocalDateTime closingDate = quizDao.findClosingDate(groupId, quizId);
                closingDates.add(closingDate);
            } else {
                Map<StudentQuizStatus, Integer> enumMap =
                        quizDao.findStudentsNumberWithStudentQuizStatus(teacherId, groupId, quizId);
                Map<String, Integer> stringMap = new HashMap<>();
                enumMap.forEach((k, v) -> stringMap.put(k.getStudentQuizStatus(), v));
                students.add(stringMap);
            }
        }
        quizzes.removeAll(closedQuizzes);
        List<Quiz> passedQuizzes = new ArrayList<>(quizzes);

        model.addAttribute("closedQuizzes", closedQuizzes);
        model.addAttribute("closingDates", closingDates);
        model.addAttribute("students", students);
        model.addAttribute("passedQuizzes", passedQuizzes);

        Group group = groupDao.findGroup(groupId);
        model.addAttribute("group", group);

        return "/teacher/results-group";
    }

    @RequestMapping("/teacher/results/group/{groupId}/quiz/{quizId}")
    @SuppressWarnings("Duplicates")
    public String showGroupQuizResults(@ModelAttribute("teacherId") Long teacherId,
                                       @PathVariable("groupId") Long groupId,
                                       @PathVariable("quizId") Long quizId,
                                       Model model) {
        List<User> students = userDao.findStudents(groupId);
        Group group = groupDao.findGroup(groupId);
        Quiz quiz = quizDao.findQuiz(quizId);

        model.addAttribute("students", students);
        model.addAttribute("group", group);
        model.addAttribute("quiz", quiz);

        Integer studentsNumber = groupDao.findStudentsNumberInGroup(groupId);
        Integer closedStudents = userDao.findStudentsNumberInGroupWithClosedQuiz(groupId, quizId);

        if (closedStudents.equals(studentsNumber)) {
            List<PassedQuiz> closedResults = new ArrayList<>();
            for (User student : students) {
                Long studentId = student.getUserId();
                PassedQuiz closedQuiz = quizDao.findClosedQuiz(studentId, quizId);
                closedResults.add(closedQuiz);
            }
            model.addAttribute("closedResults", closedResults);
            return "teacher/results-group-closed-quiz";
        } else {
            List<PassedQuiz> passedResults = new ArrayList<>();
            List<String> statusList = new ArrayList<>();
            for (User student : students) {
                Long studentId = student.getUserId();
                StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
                statusList.add(status.getStudentQuizStatus());
                switch (status) {
                    case OPENED:
                        PassedQuiz openedQuiz = new PassedQuiz.PassedQuizBuilder().build();
                        passedResults.add(openedQuiz);
                        break;
                    case PASSED:
                        PassedQuiz passedQuiz = quizDao.findPassedQuiz(studentId, quizId);
                        passedResults.add(passedQuiz);
                        break;
                    case CLOSED:
                        PassedQuiz closedQuiz = quizDao.findClosedQuiz(studentId, quizId);
                        passedResults.add(closedQuiz);
                        break;
                }
            }
            model.addAttribute("passedResults", passedResults);
            model.addAttribute("statusList", statusList);
            return "teacher/results-group-passed-quiz";
        }
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

        return "teacher/quiz-edit";
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
            return "teacher/quiz-edit";
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

        Long questionId = questionDao.addQuestion(question);
        switch (questionType) {
            case ONE_ANSWER:
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

                answerAccordanceDao.addAnswerAccordance(answerAccordance);
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

                answerSequenceDao.addAnswerSequence(answerSequence);
                break;
            case NUMBER:
                Integer number = Integer.valueOf(params.get("number"));
                AnswerNumber answerNumber = new AnswerNumber.AnswerNumberBuilder()
                        .questionId(questionId)
                        .correct(number)
                        .build();
                answerNumberDao.addAnswerNumber(answerNumber);
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

    @RequestMapping("/teacher/quizzes/{quizId}/questions/hello")
    @ResponseBody
    public String hello(@PathVariable("quizId") Long quizId) {
        return "hello";
    }
}