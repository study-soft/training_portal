package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.time.temporal.ChronoUnit.MINUTES;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
public class QuizDaoJdbcTest {

    @Autowired
    private QuizDao quizDao;

    public void setQuizDao(QuizDao quizDao) {
        this.quizDao = quizDao;
    }

    @Test
    public void test_find_quiz_by_quizId() {
        Quiz testQuiz = new Quiz.QuizBuilder()
                .quizId(1L)
                .name("Procedural")
                .description("Try your procedural skills")
                .explanation("Hope you had procedural fun :)")
                .creationDate(LocalDate.of(2018, 3, 1))
                .passingTime(Duration.of(20, MINUTES))
                .authorId(1L)
                .teacherQuizStatus(TeacherQuizStatus.PUBLISHED)
                .build();

        Quiz quizByQuizId = quizDao.findQuizByQuizId(1L);

        assertEquals(testQuiz, quizByQuizId);
    }

    @Test
    public void find_all_quizzes() {
        List<Quiz> testQuizzes = new ArrayList<>();
        testQuizzes.add(quizDao.findQuizByQuizId(1L));
        testQuizzes.add(quizDao.findQuizByQuizId(2L));
        testQuizzes.add(quizDao.findQuizByQuizId(3L));
        testQuizzes.add(quizDao.findQuizByQuizId(4L));

        List<Quiz> quizzes = quizDao.findAllQuizzes();

        assertEquals(testQuizzes, quizzes);
    }

    @Test
    public void test_find_all_quiz_ids() {
        List<Long> testQuizIds = new ArrayList<>();
        testQuizIds.add(1L);
        testQuizIds.add(2L);
        testQuizIds.add(3L);
        testQuizIds.add(4L);

        List<Long> quizIds = quizDao.findAllQuizIds();

        assertEquals(testQuizIds, quizIds);
    }

    @Test
    public void test_find_all_quizzes_by_authorId() {
        List<Quiz> testQuizzes = new ArrayList<>();
        testQuizzes.add(quizDao.findQuizByQuizId(1L));
        testQuizzes.add(quizDao.findQuizByQuizId(2L));

        List<Quiz> quizzes = quizDao.findAllQuizzesByAuthorId(1L);

        assertEquals(testQuizzes, quizzes);
    }

    @Test
    public void test_find_all_quiz_ids_by_authorId() {
        List<Long> testQuizIds = new ArrayList<>();
        testQuizIds.add(1L);
        testQuizIds.add(2L);

        List<Long> quizIds = quizDao.findAllQuizIdsByAuthorId(1L);

        assertEquals(testQuizIds, quizIds);
    }

    @Test
    public void test_find_all_quiz_ids_by_studentId() {
        List<Long> testQuizIds = new ArrayList<>();
        testQuizIds.add(1L);
        testQuizIds.add(2L);

        List<Long> quizIds = quizDao.findAllQuizIdsByStudentId(4L);

        assertEquals(testQuizIds, quizIds);
    }

    // todo: no test data
    @Test
    public void test_find_all_closed_quiz_ids_by_author_id() {
        List<Long> testQuizIds = new ArrayList<>();

        List<Long> quizIds = quizDao.findAllClosedQuizIdsByAuthorId(1L);

        assertEquals(testQuizIds, quizIds);
    }

    // todo: no test data
    @Test
    public void test_find_all_notPublished_quiz_ids_by_author_id() {
        List<Long> testQuizIds = new ArrayList<>();

        List<Long> quizIds = quizDao.findAllNotPublishedQuizIdsByAuthorId(1L);

        assertEquals(testQuizIds, quizIds);
    }

    @Test
    public void test_find_all_quiz_ids_by_studentId_and_studentQuizStatus() {
        List<Long> testQuizIds = new ArrayList<>();
        testQuizIds.add(1L);

        List<Long> quizIds
                = quizDao.findAllQuizIdsByStudentIdAndStudentQuizStatus(
                        4L, StudentQuizStatus.OPENED);

        assertEquals(testQuizIds, quizIds);
    }

    @Test
    public void test_find_quizzes_number_by_authorId() {
        Integer quizzesNumber = quizDao.findQuizzesNumberByAuthorId(1L);
        assertThat(quizzesNumber, is(2));
    }

    @Test
    public void test_find_students_number_by_authorId_and_groupId_and_quizId_with_studentQuizStatus() {
        Map<StudentQuizStatus, Integer> testResults = new HashMap<>();
        testResults.put(StudentQuizStatus.OPENED, 1);
        testResults.put(StudentQuizStatus.FINISHED, 1);

        Map<StudentQuizStatus, Integer> results
                = quizDao.findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(
                        1L, 1L, 1L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_find_quizzes_number_by_AuthorId_with_teacherQuizStatus() {
        Map<TeacherQuizStatus, Integer> testResults = new HashMap<>();
        testResults.put(TeacherQuizStatus.PUBLISHED, 2);

        Map<TeacherQuizStatus, Integer> results
                = quizDao.FindQuizzesNumberByAuthorIdWithTeacherQuizStatus(1L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_find_all_student_results() {
        Map<Long, Integer> testResults = new HashMap<>();
        testResults.put(1L, 19);
        testResults.put(2L, 20);
        testResults.put(3L, 20);
        testResults.put(4L, 35);

        Map<Long, Integer> results = quizDao.findAllStudentResults(3L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_find_quiz_ids_by_studentId_and_reopenCounter() {
        List<Long> testQuizIds = new ArrayList<>();
        testQuizIds.add(3L);
        testQuizIds.add(2L);

        List<Long> quizIds
                = quizDao.findQuizIdsByStudentIdAndReopenCounter(3L, 0);

        assertEquals(testQuizIds, quizIds);
    }

    @Test
    public void test_find_quiz_ids_by_studentId_and_authorId() {
        List<Long> testQuizIds = new ArrayList<>();
        testQuizIds.add(2L);
        testQuizIds.add(1L);

        List<Long> quizIds
                = quizDao.findQuizIdsByStudentIdAndAuthorId(3L, 1L);

        assertEquals(testQuizIds, quizIds);
    }

    @Test
    public void test_find_result_by_studentId_and_quizId() {
        Integer result = quizDao.findResultByStudentIdAndQuizId(3L, 1L);
        assertThat(result, is(19));
    }

    @Test
    public void test_find_submitDate_by_studentId_and_quizId() {
        LocalDateTime testSubmitDate
                = LocalDateTime.of(2018, 3, 5, 0,0,0);
        LocalDateTime submitDate
                = quizDao.findSubmitDateByStudentIdAndQuizId(3L, 1L);
        assertThat(submitDate, is(testSubmitDate));
    }

    @Test
    public void test_find_finishDate_by_studentId_and_quizId() {
        LocalDateTime testFinishDate
                = LocalDateTime.of(2018, 3, 5, 0,0,15);
        LocalDateTime finishDate
                = quizDao.findFinishDateByStudentIdAndQuizId(3L, 1L);
        assertThat(finishDate, is(testFinishDate));
    }

    @Test
    public void test_find_reopen_counter_by_studentId_and_quizId() {
        Integer result = quizDao.findReopenCounterByStudentIdAndQuizId(3L, 1L);
        assertThat(result, is(1));
    }

    @Test
    public void test_find_studentQuizStatus_by_studentId_and_quizId() {
        StudentQuizStatus studentQuizStatus
                = quizDao.findStudentQuizStatusByStudentIdAndQuizId(3L, 1L);
        assertThat(studentQuizStatus, is(StudentQuizStatus.FINISHED));
    }

    @Test
    public void test_add_quiz() {
        Quiz testQuiz = new Quiz.QuizBuilder()
                .name("Servlet API")
                .description("description")
                .explanation("explanation")
                .creationDate(LocalDate.of(2018, 3, 7))
                .passingTime(Duration.of(10, MINUTES))
                .authorId(1L)
                .teacherQuizStatus(TeacherQuizStatus.UNPUBLISHED)
                .build();
        Long quizId = quizDao.addQuiz(testQuiz);

        Quiz quiz = quizDao.findQuizByQuizId(quizId);

        assertEquals(testQuiz, quiz);
    }

    @Test
    public void test_edit_teacherQuizStatus_by_quizId() {
        quizDao.editTeacherQuizStatusByQuizId(TeacherQuizStatus.UNPUBLISHED, 4L);
        TeacherQuizStatus teacherQuizStatus = quizDao
                .findQuizByQuizId(4L)
                .getTeacherQuizStatus();
        assertThat(teacherQuizStatus, is(TeacherQuizStatus.UNPUBLISHED));
    }

    @Test(expected = DataIntegrityViolationException.class)
    public void test_delete_quiz() {
        quizDao.deleteQuiz(4L);
        quizDao.findQuizByQuizId(4L);
    }
}