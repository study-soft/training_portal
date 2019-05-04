package com.studysoft.trainingportal.controller;

import com.studysoft.trainingportal.dao.*;
import com.studysoft.trainingportal.model.*;
import com.studysoft.trainingportal.model.enums.QuestionType;
import com.studysoft.trainingportal.model.enums.StudentQuizStatus;
import com.studysoft.trainingportal.model.enums.TeacherQuizStatus;
import com.studysoft.trainingportal.util.Utils;
import com.studysoft.trainingportal.validator.QuizValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@SessionAttributes("teacherId")
@PreAuthorize("hasRole('ROLE_TEACHER')")
public class TeacherQuizController {

    private QuizDao quizDao;
    private UserDao userDao;
    private GroupDao groupDao;
    private QuestionDao questionDao;
    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;
    private QuizValidator quizValidator;

    private Logger logger = Logger.getLogger(TeacherQuizController.class);

    @Autowired
    public TeacherQuizController(QuizDao quizDao,
                                 UserDao userDao,
                                 GroupDao groupDao,
                                 QuestionDao questionDao,
                                 AnswerSimpleDao answerSimpleDao,
                                 AnswerAccordanceDao answerAccordanceDao,
                                 AnswerSequenceDao answerSequenceDao,
                                 AnswerNumberDao answerNumberDao,
                                 QuizValidator quizValidator) {
        this.quizDao = quizDao;
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.questionDao = questionDao;
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
        this.quizValidator = quizValidator;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    // QUIZ SHOW ===============================================================

    /**
     * Показує всі вікторини викладача
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_general/quizzes.jsp
     */
    @RequestMapping(value = "/teacher/quizzes", method = RequestMethod.GET)
    public String showTeacherQuizzes(@ModelAttribute("teacherId") Long teacherId,
                                     Model model) {
        List<Quiz> unpublishedQuizzes = quizDao.findUnpublishedQuizzes(teacherId);
        List<Quiz> publishedQuizzes = quizDao.findPublishedQuizzes(teacherId);
        String password = userDao.findUser(teacherId).getPassword();

        model.addAttribute("unpublishedQuizzes", unpublishedQuizzes);
        model.addAttribute("publishedQuizzes", publishedQuizzes);
        model.addAttribute("password", password);

        return "teacher_general/quizzes";
    }

    /**
     * Показує інформацію про вікторину та групи й студентів, яким вона опублікована
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param quizId    ID вікторини
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_quiz/unpublished-quiz.jsp, якщо вікторина неопублікована,
     * teacher_quiz/published-quiz, якщо вікторина опублікована
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}", method = RequestMethod.GET)
    public String showTeacherQuiz(@ModelAttribute("teacherId") Long teacherId,
                                  @PathVariable("quizId") Long quizId,
                                  Model model) {
        if (checkQuizAccessDenied(teacherId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
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
                Map<Long, List<String>> statuses = new HashMap<>();
                for (Group group : groups) {
                    Long groupId = group.getGroupId();
                    List<User> groupStudents =
                            userDao.findStudentsForWhomPublished(groupId, quizId);
                    students.put(groupId, groupStudents);
                    List<String> statusList = new ArrayList<>();
                    for (User student : groupStudents) {
                        StudentQuizStatus status =
                                quizDao.findStudentQuizStatus(student.getUserId(), quizId);
                        statusList.add(status.toString());
                    }
                    statuses.put(groupId, statusList);
                }

                List<User> studentsWithoutGroup =
                        userDao.findStudentsWithoutGroupForWhomPublished(quizId);
                List<String> statusesWithoutGroup = new ArrayList<>();
                for (User student : studentsWithoutGroup) {
                    StudentQuizStatus status =
                            quizDao.findStudentQuizStatus(student.getUserId(), quizId);
                    statusesWithoutGroup.add(status.toString());
                }

                model.addAttribute("publishedQuiz", quiz);
                model.addAttribute("groups", groups);
                model.addAttribute("students", students);
                model.addAttribute("statuses", statuses);
                model.addAttribute("studentsWithoutGroup", studentsWithoutGroup);
                model.addAttribute("statusesWithoutGroup", statusesWithoutGroup);
                model.addAttribute("password", userDao.findUser(teacherId).getPassword());

                return "teacher_quiz/published-quiz";
        }

        return "teacher_general/teacher";
    }

    // QUIZ PUBLICATION =============================================================

    /**
     * Показує сторінку з формою для публікації
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param quizId    ID вікторини
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_quiz/quiz-publication.jsp
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/publication", method = RequestMethod.GET)
    public String showQuizPublication(@ModelAttribute("teacherId") Long teacherId,
                                      @PathVariable("quizId") Long quizId,
                                      Model model) {
        if (checkQuizAccessDenied(teacherId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
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

    /**
     * Публікація вікторини обраним групам і студентам. Якщо операція успішна - додається сповіщення успіху на UI
     *
     * @param quizId             ID вікторини
     * @param studentIdsMap      ID студентів, яким вікторина публікується
     * @param redirectAttributes інтерфейс для збереження атрибутів під час перенапрямлення HTTP-запиту
     * @return проводить перенапрямлення HTTP-запиту на /teacher/quizzes/ після успішного опублікування
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/publication", method = RequestMethod.POST)
    public String publishQuiz(@PathVariable("quizId") Long quizId,
                              @RequestParam Map<String, String> studentIdsMap,
                              RedirectAttributes redirectAttributes) {
        quizDao.editTeacherQuizStatus(TeacherQuizStatus.PUBLISHED, quizId);

        List<Long> studentIds = studentIdsMap.values()
                .stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());

        quizDao.addPublishedQuizInfo(studentIds, quizId);
        redirectAttributes.addFlashAttribute("publicationSuccess", true);

        return "redirect:/teacher/quizzes/" + quizId;
    }

    // QUIZ UNPUBLICATION ============================================================

    /**
     * Отримує загальну кількість студентів, яким вікторина була опублікована, та кількість студентів, у яких
     * статус даної вікторини "Закрита"
     *
     * @param quizId ID вікторини
     * @return ResponseEntity з тілом {"closedStudents": 0, "totalStudents": 0} і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "teacher/quizzes/{quizId}/students-number", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Integer> getStudentsNumber(@PathVariable("quizId") Long quizId) {
        Map<String, Integer> studentsNumber = new HashMap<>();
        studentsNumber.put("closedStudents", userDao.findStudentsNumberWhoClosedQuiz(quizId));
        studentsNumber.put("totalStudents", userDao.findStudentsNumberToWhomQuizWasPublished(quizId));
        return studentsNumber;
    }

    /**
     * Скасування публікації вікторини усім групам і студентам зі сторінки teacher_quiz/unpublished-quiz.jsp.
     * Якщо операція успішна - додається сповіщення успіху на UI
     *
     * @param quizId             ID вікторини
     * @param redirectAttributes інтерфейс для збереження атрибутів під час перенапрямлення HTTP-запиту
     * @return проводить перенапрямлення HTTP-запиту на /teacher/quizzes/{quizId} після успішного
     * скасування публікації
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/unpublish", method = RequestMethod.POST)
    public String unpublishQuiz(@PathVariable("quizId") Long quizId,
                                RedirectAttributes redirectAttributes) {
        quizDao.deleteStudentsInfoAboutQuiz(quizId);
        quizDao.editTeacherQuizStatus(TeacherQuizStatus.UNPUBLISHED, quizId);
        redirectAttributes.addFlashAttribute("unpublishSuccess", true);
        return "redirect:/teacher/quizzes/{quizId}";
    }

    /**
     * Скасування публікації вікторини усім групам і студентам зі сторінки teacher_general/quizzes.jsp.
     * Якщо операція успішна - додається сповіщення успіху на UI
     *
     * @param quizId ID вікторини
     * @return ResponseEntity без тіла і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/unpublish-from-quizzes", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> unpublishQuizFromQuizzes(@PathVariable("quizId") Long quizId) {
        quizDao.deleteStudentsInfoAboutQuiz(quizId);
        quizDao.editTeacherQuizStatus(TeacherQuizStatus.UNPUBLISHED, quizId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // QUIZ CLOSE ======================================================================

    /**
     * Переводить вікторину у статус "Закрита" усій групі
     *
     * @param groupId ID групи
     * @param quizId  ID вікторини
     * @return ResponseEntity з інформацією про закриту вікторину в тілі і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/results/group/{groupId}/close", method = RequestMethod.POST)
    @ResponseBody
    public List<String> closeQuizToGroup(@PathVariable("groupId") Long groupId,
                                         @RequestParam("quizId") Long quizId) {
        quizDao.editStudentsInfoWithOpenedQuizStatus(groupId, quizId);
        quizDao.closeQuizToGroup(groupId, quizId);
        List<String> closedQuizInfo = new ArrayList<>();
        closedQuizInfo.add(quizDao.findQuiz(quizId).getName());
        closedQuizInfo.add(Utils.formatDateTime(LocalDateTime.now()));
        return closedQuizInfo;
    }

    /**
     * Переводить вікторину у статус "Закрита" студенту зі сторінки teacher_results/student-result.jsp
     *
     * @param groupId   ID групи
     * @param quizId    ID вікторини
     * @param studentId ID студента
     * @return ResponseEntity з інформацією про закриту вікторину в тілі і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/results/group/{groupId}/quiz/{quizId}/close", method = RequestMethod.POST)
    @ResponseBody
    public List<String> closeQuizToStudentFromStudents(@PathVariable("groupId") Long groupId,
                                                       @PathVariable("quizId") Long quizId,
                                                       @RequestParam("studentId") Long studentId) {
        return closeQuizToStudent(studentId, quizId);
    }

    /**
     * Переводить вікторину у статус "Закрита" студенту зі сторінки teacher_results/group-quiz-result.jsp
     *
     * @param studentId ID студента
     * @param quizId    ID вікторини
     * @return ResponseEntity з інформацією про закриту вікторину в тілі і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/students/{studentId}/close", method = RequestMethod.POST)
    @ResponseBody
    public List<String> closeQuizToStudentFromResults(@PathVariable("studentId") Long studentId,
                                                      @RequestParam("quizId") Long quizId) {
        return closeQuizToStudent(studentId, quizId);
    }

    // QUIZ CREATE ================================================================

    /**
     * Показує сторінку з формою створення вікторини
     *
     * @param model інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_quiz/quiz-create.jsp
     */
    @RequestMapping(value = "/teacher/quizzes/create", method = RequestMethod.GET)
    public String showCreateQuiz(Model model) {
        model.addAttribute("quiz", new Quiz());
        return "teacher_quiz/quiz-create";
    }

    /**
     * Створення нової вікторини. Проводиться валідація параметрів, введенех користувачем.
     * Якщо валідація успішна - вікторина створюється у БД та додається сповіщення успіху на UI
     *
     * @param teacherId          ID авторизованого користувача у HTTP-сесії
     * @param quiz               інформація, введена користувачем
     * @param enabled            показник чи має вікторини час для проходження
     * @param hours              години для проходження
     * @param minutes            хвилини для проходження
     * @param seconds            секунди для проходження
     * @param bindingResult      інтерфейс для зручного представлення помилок валідації
     * @param model              інтерфейс для додавання атрибутів до моделі на UI
     * @param redirectAttributes інтерфейс для збереження атрибутів під час перенапрямлення HTTP-запиту
     * @return teacher_quiz/quiz-create.jsp при помилках валідації або проводить перенапрямлення HTTP-запиту
     * на /teacher/quizzes/{quizId} при успішному створенні вікторини
     */
    @RequestMapping(value = "/teacher/quizzes/create", method = RequestMethod.POST)
    public String createQuiz(@ModelAttribute("teacherId") Long teacherId,
                             @ModelAttribute("quiz") Quiz quiz,
                             @RequestParam(value = "enabled", required = false)
                                     String enabled,
                             @RequestParam(value = "hours", required = false)
                                     String hours,
                             @RequestParam(value = "minutes", required = false)
                                     String minutes,
                             @RequestParam(value = "seconds", required = false)
                                     String seconds,
                             BindingResult bindingResult, ModelMap model,
                             RedirectAttributes redirectAttributes) {
        quizValidator.validate(quiz, bindingResult);
        if (enabled != null) {
            quizValidator.validatePassingTime(hours, minutes, seconds, bindingResult);
        }

        if (quizDao.quizExistsByName(quiz.getName())) {
            bindingResult.rejectValue("name", "validation.quiz.name.exists");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("hours", hours);
            model.addAttribute("minutes", minutes);
            model.addAttribute("seconds", seconds);
            return "teacher_quiz/quiz-create";
        }

        Duration passingTime = null;
        if (enabled != null) {
            passingTime = Utils.timeUnitsToDuration(
                    hours.isEmpty() ? 0 : Integer.valueOf(hours),
                    minutes.isEmpty() ? 0 : Integer.valueOf(minutes),
                    seconds.isEmpty() ? 0 : Integer.valueOf(seconds));
        }
        LocalDate creationDate = LocalDate.now();
        Quiz newQuiz = new Quiz.QuizBuilder()
                .name(quiz.getName())
                .description(quiz.getDescription().isEmpty() ? null : quiz.getDescription())
                .explanation(quiz.getExplanation().isEmpty() ? null : quiz.getExplanation())
                .creationDate(creationDate)
                .passingTime(passingTime)
                .authorId(teacherId)
                .questionsNumber(0)
                .score(0)
                .teacherQuizStatus(TeacherQuizStatus.UNPUBLISHED)
                .build();

        Long newQuizId = quizDao.addQuiz(newQuiz);
        redirectAttributes.addFlashAttribute("createSuccess", true);
        model.clear();

        return "redirect:/teacher/quizzes/" + newQuizId;
    }

    // QUIZ EDIT ======================================================================

    /**
     * Показує сторінку з формою редагування вікторини
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param quizId    ID вікторини
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_quiz/quiz-edit.jsp
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/edit", method = RequestMethod.GET)
    public String showEditQuiz(@ModelAttribute("teacherId") Long teacherId,
                               @PathVariable("quizId") Long quizId, Model model) {
        if (checkQuizAccessDenied(teacherId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

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

    /**
     * Редагування вікторини. Проводиться валідація параметрів, введенех користувачем. Якщо валідація успішна -
     * вікторина оновлюється у БД та додається сповіщення успіху на UI
     *
     * @param quizId             ID вікторини
     * @param editedQuiz         інформація, введена користувачем
     * @param bindingResult      інтерфейс для зручного представлення помилок валідації
     * @param enabled            показник чи має вікторини час для проходження
     * @param hours              години для проходження
     * @param minutes            хвилини для проходження
     * @param seconds            секунди для проходження
     * @param redirectAttributes інтерфейс для збереження атрибутів під час перенапрямлення HTTP-запиту
     * @param model              інтерфейс для додавання атрибутів до моделі на UI
     * @return teacher_quiz/quiz-edit.jsp при помилках валідації або проводить перенапрямлення HTTP-запиту
     * на /teacher/quizzes/{quizId} при успішному оновленні вікторини
     */
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
            model.addAttribute("enabled", enabled);
            model.addAttribute("hours", hours);
            model.addAttribute("minutes", minutes);
            model.addAttribute("seconds", seconds);
            model.addAttribute("quiz", editedQuiz);
            return "teacher_quiz/quiz-edit";
        }

        Duration editedPassingTime = null;
        if (enabled != null) {
            editedPassingTime = Utils.timeUnitsToDuration(
                    hours.isEmpty() ? 0 : Integer.valueOf(hours),
                    minutes.isEmpty() ? 0 : Integer.valueOf(minutes),
                    seconds.isEmpty() ? 0 : Integer.valueOf(seconds));
        }
        quizDao.editQuiz(oldQuiz.getQuizId(),
                editedQuiz.getName(),
                editedQuiz.getDescription().isEmpty() ? null : editedQuiz.getDescription(),
                editedQuiz.getExplanation().isEmpty() ? null : editedQuiz.getExplanation(),
                editedPassingTime);

        Quiz newQuiz = quizDao.findQuiz(quizId);
        if (!oldQuiz.equals(newQuiz)) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
        }
        model.clear();

        return "redirect:/teacher/quizzes/" + quizId;
    }

    // QUIZ DELETE =================================================================

    /**
     * Видалення неопублікованої вікторини та усіх її питань
     *
     * @param quizId ID вікторини
     * @return ResponseEntity без тіла і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/delete", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> deleteQuiz(@PathVariable("quizId") Long quizId) {
        quizDao.deleteUnpublishedQuiz(quizId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // QUESTION SHOW ===============================================================

    /**
     * Показує питання для вікторини з формами створення, редагування і видалення, якщо вікторина
     * опублікована або просто питання з відповідями, якщо вікторина неопублікована
     *
     * @param teacherId ID авторизованого користувача у HTTP-сесії
     * @param quizId    ID вікторини
     * @param model     інтерфейс для додавання атрибутів до моделі на UI
     * @return student_quiz/answers.jsp для опублікованої вікторини або
     * teacher_quiz/questions.jsp для неопублікованої вікторини
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/questions", method = RequestMethod.GET)
    public String showQuestions(@ModelAttribute("teacherId") Long teacherId,
                                @PathVariable("quizId") Long quizId, ModelMap model) {
        if (checkQuizAccessDenied(teacherId, quizId)) {
            throw new AccessDeniedException("Access denied to quiz");
        }

        Quiz quiz = quizDao.findQuiz(quizId);
        model.addAttribute("quiz", quiz);

        List<Question> questionsOneAnswer = questionDao.findQuestions(quizId, QuestionType.ONE_ANSWER);
        List<Question> questionsFewAnswers = questionDao.findQuestions(quizId, QuestionType.FEW_ANSWERS);
        List<Question> questionsAccordance = questionDao.findQuestions(quizId, QuestionType.ACCORDANCE);
        List<Question> questionsSequence = questionDao.findQuestions(quizId, QuestionType.SEQUENCE);
        List<Question> questionsNumber = questionDao.findQuestions(quizId, QuestionType.NUMBER);
        model.addAttribute("questionsOneAnswer", questionsOneAnswer);
        model.addAttribute("questionsFewAnswers", questionsFewAnswers);
        model.addAttribute("questionsAccordance", questionsAccordance);
        model.addAttribute("questionsSequence", questionsSequence);
        model.addAttribute("questionsNumber", questionsNumber);

        Map<Long, List<AnswerSimple>> quizAnswersSimple = new HashMap<>();
        Map<Long, AnswerAccordance> quizAnswersAccordance = new HashMap<>();
        Map<Long, AnswerSequence> quizAnswersSequence = new HashMap<>();
        Map<Long, AnswerNumber> quizAnswersNumber = new HashMap<>();
        List<Question> tests = new ArrayList<>();
        tests.addAll(questionsOneAnswer);
        tests.addAll(questionsFewAnswers);
        for (Question question : tests) {
            Long questionId = question.getQuestionId();
            List<AnswerSimple> answersSimple = answerSimpleDao.findAnswersSimple(questionId);
            quizAnswersSimple.put(questionId, answersSimple);
        }
        for (Question question : questionsAccordance) {
            Long questionId = question.getQuestionId();
            AnswerAccordance answerAccordance = answerAccordanceDao.findAnswerAccordance(questionId);
            quizAnswersAccordance.put(questionId, answerAccordance);
        }
        for (Question question : questionsSequence) {
            Long questionId = question.getQuestionId();
            AnswerSequence answerSequence = answerSequenceDao.findAnswerSequence(questionId);
            quizAnswersSequence.put(questionId, answerSequence);
        }
        for (Question question : questionsNumber) {
            Long questionId = question.getQuestionId();
            AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(questionId);
            quizAnswersNumber.put(questionId, answerNumber);
        }

        model.addAttribute("quizAnswersSimple", quizAnswersSimple);
        model.addAttribute("quizAnswersAccordance", quizAnswersAccordance);
        model.addAttribute("quizAnswersSequence", quizAnswersSequence);
        model.addAttribute("quizAnswersNumber", quizAnswersNumber);

        if (quiz.getTeacherQuizStatus().equals(TeacherQuizStatus.PUBLISHED)) {
            return "student_quiz/answers";
        }
        return "teacher_quiz/questions";
    }

    // QUESTION CREATE AND EDIT ===================================================

    /**
     * Створення або редагування питання. Потрібний алгоритм вибирається в залежності від типу питання
     *
     * @param quizId ID вікторини
     * @param params параметри для створення або редагування питання
     * @return ResponseEntity з ID створеного або відредагованого питання у тілі і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/questions/update", method = RequestMethod.POST)
    @ResponseBody
    public Long createOrEditQuestion(@PathVariable("quizId") Long quizId,
                                     @RequestParam Map<String, String> params) {
        logger.info(params);
        QuestionType questionType = QuestionType.valueOf(params.get("type"));
        Integer score = Integer.valueOf(params.get("points"));
        String questionBody = params.get("question");
        String explanation = params.get("explanation").trim();

        Question question = new Question.QuestionBuilder()
                .quizId(quizId)
                .body(questionBody)
                .explanation(explanation.isEmpty() ? null : explanation)
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
        return questionId;
    }

    // QUESTION DELETE =========================================================

    /**
     * Видалення питання
     *
     * @param quizId     ID вікторини
     * @param questionId ID питання
     * @return ResponseEntity без тіла і HTTP-статусом 200 OK
     */
    @RequestMapping(value = "/teacher/quizzes/{quizId}/questions/delete", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> deleteQuestion(@PathVariable("quizId") Long quizId,
                                            @RequestParam("questionId") Long questionId) {
        questionDao.deleteQuestion(questionId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // INTERNALS===================================================

    private boolean checkQuizAccessDenied(Long teacherId, Long quizId) {
        List<Long> teacherQuizIds = quizDao.findTeacherQuizIds(teacherId);
        return !teacherQuizIds.contains(quizId);
    }

    private List<String> closeQuizToStudent(Long studentId, Long quizId) {
        StudentQuizStatus status = quizDao.findStudentQuizStatus(studentId, quizId);
        List<String> closedQuizInfo = new ArrayList<>();
        switch (status) {
            case OPENED:
                LocalDateTime currentDate = LocalDateTime.now();
                quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, 0,
                        currentDate, 0, StudentQuizStatus.CLOSED);
                quizDao.editStartDate(currentDate, studentId, quizId);
                PassedQuiz closedQuiz = quizDao.findClosedQuiz(studentId, quizId);
                closedQuizInfo.add(Utils.formatDateTime(closedQuiz.getFinishDate()));
                closedQuizInfo.add(closedQuiz.getResult() + " / " + closedQuiz.getScore());
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
