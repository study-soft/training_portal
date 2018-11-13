package com.studysoft.trainingportal.controller;

import com.studysoft.trainingportal.dao.GroupDao;
import com.studysoft.trainingportal.dao.QuizDao;
import com.studysoft.trainingportal.dao.UserDao;
import com.studysoft.trainingportal.model.*;
import com.studysoft.trainingportal.model.enums.StudentQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@SessionAttributes("teacherId")
@PreAuthorize("hasRole('ROLE_TEACHER')")
public class TeacherResultsController {

    private UserDao userDao;
    private GroupDao groupDao;
    private QuizDao quizDao;

    private static final Logger logger = Logger.getLogger(TeacherController.class);

    @Autowired
    public TeacherResultsController(UserDao userDao,
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
        List<Quiz> groupQuizzes = quizDao.findPublishedQuizzes(groupId, teacherId);
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

        return "teacher_results/group-result";
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

        List<User> openedStudents = userDao.findStudents(groupId, quizId, StudentQuizStatus.OPENED);
        List<User> passedStudents = userDao.findStudents(groupId, quizId, StudentQuizStatus.PASSED);
        List<User> closedStudents = userDao.findStudents(groupId, quizId, StudentQuizStatus.CLOSED);
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

        return "teacher_results/group-quiz-result";
    }

    @RequestMapping("/teacher/students/{studentId}")
    public String showStudentResults(@ModelAttribute("teacherId") Long teacherId,
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

        return "teacher_results/student-result";
    }
}
