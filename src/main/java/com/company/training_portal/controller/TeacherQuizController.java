package com.company.training_portal.controller;

import com.company.training_portal.dao.*;
import com.company.training_portal.model.*;
import com.company.training_portal.model.enums.QuestionType;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.util.Utils;
import com.company.training_portal.validator.QuizValidator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
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

import static com.company.training_portal.model.enums.StudentQuizStatus.CLOSED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.company.training_portal.model.enums.TeacherQuizStatus.UNPUBLISHED;
import static com.company.training_portal.util.Utils.formatDateTime;
import static com.company.training_portal.util.Utils.timeUnitsToDuration;

@Controller
@PropertySource("classpath:validationMessages.properties")
@SessionAttributes("teacherId")
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
    private StudentController studentController;

    private Logger logger = Logger.getLogger(QuizPassingController.class);

    @Autowired
    public TeacherQuizController(QuizDao quizDao,
                                 UserDao userDao,
                                 GroupDao groupDao,
                                 QuestionDao questionDao,
                                 AnswerSimpleDao answerSimpleDao,
                                 AnswerAccordanceDao answerAccordanceDao,
                                 AnswerSequenceDao answerSequenceDao,
                                 AnswerNumberDao answerNumberDao,
                                 QuizValidator quizValidator,
                                 StudentController studentController) {
        this.quizDao = quizDao;
        this.userDao = userDao;
        this.groupDao = groupDao;
        this.questionDao = questionDao;
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
        this.quizValidator = quizValidator;
        this.studentController = studentController;
    }

    @ModelAttribute("teacherId")
    public Long getTeacherId(@AuthenticationPrincipal SecurityUser securityUser) {
        return securityUser.getUserId();
    }

    // QUIZ SHOW ===============================================================

    @RequestMapping("/teacher/quizzes")
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
                Map<Long, List<StudentQuizStatus>> statuses = new HashMap<>();
                for (Group group : groups) {
                    Long groupId = group.getGroupId();
                    List<User> groupStudents =
                            userDao.findStudentsForWhomPublished(groupId, quizId);
                    students.put(groupId, groupStudents);
                    List<StudentQuizStatus> statusList = new ArrayList<>();
                    for (User student : groupStudents) {
                        StudentQuizStatus status =
                                quizDao.findStudentQuizStatus(student.getUserId(), quizId);
                        statusList.add(status);
                    }
                    statuses.put(groupId, statusList);
                }

                List<User> studentsWithoutGroup =
                        userDao.findStudentsWithoutGroupForWhomPublished(quizId);
                List<StudentQuizStatus> statusesWithoutGroup = new ArrayList<>();
                for (User student : studentsWithoutGroup) {
                    StudentQuizStatus status =
                            quizDao.findStudentQuizStatus(student.getUserId(), quizId);
                    statusesWithoutGroup.add(status);
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

    // QUIZ UNPUBLICATION ============================================================

    @RequestMapping(value = "teacher/quizzes/{quizId}/students-number", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Integer> getStudentsNumber(@PathVariable("quizId") Long quizId) {
        Map<String, Integer> studentsNumber = new HashMap<>();
        studentsNumber.put("closedStudents", userDao.findStudentsNumberWhoClosedQuiz(quizId));
        studentsNumber.put("totalStudents", userDao.findStudentsNumberToWhomQuizWasPublished(quizId));
        return studentsNumber;
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/unpublish", method = RequestMethod.POST)
    public String unpublishQuiz(@PathVariable("quizId") Long quizId,
                                RedirectAttributes redirectAttributes) {
        quizDao.deleteStudentsInfoAboutQuiz(quizId);
        quizDao.editTeacherQuizStatus(UNPUBLISHED, quizId);
        redirectAttributes.addFlashAttribute("unpublishSuccess", true);
        return "redirect:/teacher/quizzes/{quizId}";
    }

    @RequestMapping(value = "/teacher/quizzes/{quizId}/unpublish-from-quizzes", method = RequestMethod.POST)
    public String unpublishQuizFromQuizzes(@PathVariable("quizId") Long quizId,
                                           RedirectAttributes redirectAttributes) {
        quizDao.deleteStudentsInfoAboutQuiz(quizId);
        quizDao.editTeacherQuizStatus(UNPUBLISHED, quizId);
        String unpublishedQuizName = quizDao.findQuiz(quizId).getName();
        redirectAttributes.addFlashAttribute("unpublishedQuiz", unpublishedQuizName);
        return "redirect:/teacher/quizzes";
    }

    // QUIZ CLOSE ======================================================================

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

    // QUIZ CREATE ================================================================

    @RequestMapping(value = "/teacher/quizzes/create", method = RequestMethod.GET)
    public String showCreateQuiz(Model model) {
        model.addAttribute("quiz", new Quiz());
        return "teacher_quiz/quiz-create";
    }

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
            bindingResult.rejectValue("name", "quiz.name.exists");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("hours", hours);
            model.addAttribute("minutes", minutes);
            model.addAttribute("seconds", seconds);
            return "teacher_quiz/quiz-create";
        }

        Duration passingTime = null;
        if (enabled != null) {
            passingTime = timeUnitsToDuration(
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
                .teacherQuizStatus(UNPUBLISHED)
                .build();

        Long newQuizId = quizDao.addQuiz(newQuiz);
        redirectAttributes.addFlashAttribute("createSuccess", true);
        model.clear();

        return "redirect:/teacher/quizzes/" + newQuizId;
    }

    // QUIZ EDIT ======================================================================

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

    // QUIZ DELETE =================================================================

    @RequestMapping(value = "/teacher/quizzes/{quizId}/delete", method = RequestMethod.POST)
    public String deleteQuiz(@PathVariable("quizId") Long quizId,
                             @RequestParam("deletedQuiz") String deletedQuiz,
                             RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("deletedQuiz", deletedQuiz);
        quizDao.deleteUnpublishedQuiz(quizId);
        return "redirect:/teacher/quizzes";
    }

    // QUESTION SHOW ===============================================================

    @RequestMapping("/teacher/quizzes/{quizId}/questions")
    public String showQuestions(@PathVariable("quizId") Long quizId, ModelMap model) {
        studentController.showAnswers(quizId, model);
        Quiz quiz = quizDao.findQuiz(quizId);
        if (quiz.getTeacherQuizStatus().equals(PUBLISHED)) {
            return "student_quiz/answers";
        }
        return "teacher_quiz/questions";
    }

    // QUESTION CREATE AND EDIT ===================================================

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

    // QUESTION DELETE =========================================================

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