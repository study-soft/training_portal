package com.studysoft.trainingportal.dao.impl;

import com.studysoft.trainingportal.config.AppConfig;
import com.studysoft.trainingportal.dao.QuestionDao;
import com.studysoft.trainingportal.dao.QuizDao;
import com.studysoft.trainingportal.dao.UserDao;
import com.studysoft.trainingportal.model.*;
import com.studysoft.trainingportal.model.enums.StudentQuizStatus;
import com.studysoft.trainingportal.model.enums.TeacherQuizStatus;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.studysoft.trainingportal.model.enums.QuestionType.ONE_ANSWER;
import static com.studysoft.trainingportal.model.enums.StudentQuizStatus.CLOSED;
import static com.studysoft.trainingportal.model.enums.StudentQuizStatus.OPENED;
import static com.studysoft.trainingportal.model.enums.StudentQuizStatus.PASSED;
import static com.studysoft.trainingportal.model.enums.TeacherQuizStatus.PUBLISHED;
import static com.studysoft.trainingportal.model.enums.TeacherQuizStatus.UNPUBLISHED;
import static java.time.temporal.ChronoUnit.MINUTES;
import static java.time.temporal.ChronoUnit.SECONDS;
import static java.util.Arrays.asList;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@WebAppConfiguration
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:schema_postgres.sql", "classpath:test-data.sql"})
public class QuizDaoJdbcTest {

    @Autowired
    private QuizDao quizDao;
    @Autowired
    private QuestionDao questionDao;
    @Autowired
    private UserDao userDao;

    public void setQuizDao(QuizDao quizDao) {
        this.quizDao = quizDao;
    }

    public void setQuestionDao(QuestionDao questionDao) {
        this.questionDao = questionDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    @Test
    public void test_find_quiz_by_quizId() {
        Quiz testQuiz = new Quiz.QuizBuilder()
                .quizId(1L)
                .name("Procedural")
                .description("Try your procedural skills")
                .explanation("Hope you had procedural fun :)")
                .creationDate(LocalDate.of(2018, 3, 1))
                .passingTime(Duration.of(10, MINUTES))
                .authorId(1L)
                .questionsNumber(12)
                .score(30)
                .teacherQuizStatus(PUBLISHED)
                .build();

        Quiz quiz = quizDao.findQuiz(1L);

        assertEquals(testQuiz, quiz);

        Quiz testQuizWithoutQuestions = new Quiz.QuizBuilder()
                .quizId(13L)
                .name("SQL")
                .creationDate(LocalDate.of(2018, 3, 29))
                .authorId(1L)
                .questionsNumber(0)
                .score(0)
                .teacherQuizStatus(UNPUBLISHED)
                .build();

        Quiz quizWithoutQuestions = quizDao.findQuiz(13L);

        assertEquals(testQuizWithoutQuestions, quizWithoutQuestions);

    }

    @Test
    public void find_all_quizzes_with_questions() {
        List<Quiz> testQuizzes = new ArrayList<>();
        testQuizzes.add(quizDao.findQuiz(1L));
        testQuizzes.add(quizDao.findQuiz(2L));
        testQuizzes.add(quizDao.findQuiz(3L));
        testQuizzes.add(quizDao.findQuiz(4L));
        testQuizzes.add(quizDao.findQuiz(5L));
        testQuizzes.add(quizDao.findQuiz(6L));
        testQuizzes.add(quizDao.findQuiz(7L));
        testQuizzes.add(quizDao.findQuiz(8L));
        testQuizzes.add(quizDao.findQuiz(9L));
        testQuizzes.add(quizDao.findQuiz(10L));
        testQuizzes.add(quizDao.findQuiz(11L));
        testQuizzes.add(quizDao.findQuiz(12L));

        List<Quiz> quizzes = quizDao.findAllQuizzesWithQuestions();

        assertEquals(testQuizzes, quizzes);
    }

    @Test
    public void test_find_all_quizzes_by_authorId() {
        List<Long> testQuizzes = new ArrayList<>(
                asList(1L, 2L, 5L, 9L, 10L, 11L, 12L, 13L, 14L));

        List<Long> quizzes = quizDao.findTeacherQuizIds(1L);

        assertEquals(testQuizzes, quizzes);
    }

    @Test
    public void test_find_unpublished_quizzes_by_teacherId() {
        List<Quiz> testUnpublishedQuizzes = new ArrayList<>();
        testUnpublishedQuizzes.add(quizDao.findQuiz(9L));
        testUnpublishedQuizzes.add(quizDao.findQuiz(10L));
        testUnpublishedQuizzes.add(quizDao.findQuiz(13L));
        testUnpublishedQuizzes.add(quizDao.findQuiz(14L));

        List<Quiz> unpublishedQuizzes = quizDao.findUnpublishedQuizzes(1L);

        assertEquals(testUnpublishedQuizzes, unpublishedQuizzes);
    }

    @Test
    public void test_find_published_quizzes_by_teacherId() {
        List<Quiz> testPublishedQuizzes = new ArrayList<>();
        testPublishedQuizzes.add(quizDao.findQuiz(1L));
        testPublishedQuizzes.add(quizDao.findQuiz(2L));
        testPublishedQuizzes.add(quizDao.findQuiz(11L));
        testPublishedQuizzes.add(quizDao.findQuiz(12L));
        testPublishedQuizzes.add(quizDao.findQuiz(5L));

        List<Quiz> publishedQuizzes = quizDao.findPublishedQuizzes(1L);

        assertEquals(testPublishedQuizzes, publishedQuizzes);
    }

    @Test
    public void test_find_group_quizzes() {
        List<Quiz> testGroupQuizzes = new ArrayList<>();
        testGroupQuizzes.add(quizDao.findQuiz(2L));
        testGroupQuizzes.add(quizDao.findQuiz(5L));
        testGroupQuizzes.add(quizDao.findQuiz(12L));
        testGroupQuizzes.add(quizDao.findQuiz(1L));
        testGroupQuizzes.add(quizDao.findQuiz(11L));

        List<Quiz> groupQuizzes = quizDao.findPublishedQuizzes(1L, 1L);

        assertEquals(testGroupQuizzes, groupQuizzes);
    }

    @Test
    public void test_find_quizzes_by_studentId() {
        List<Quiz> testQuizzes = new ArrayList<>();
        testQuizzes.add(quizDao.findQuiz(1L));
        testQuizzes.add(quizDao.findQuiz(2L));
        testQuizzes.add(quizDao.findQuiz(3L));
        testQuizzes.add(quizDao.findQuiz(4L));
        testQuizzes.add(quizDao.findQuiz(5L));
        testQuizzes.add(quizDao.findQuiz(6L));
        testQuizzes.add(quizDao.findQuiz(11L));
        testQuizzes.add(quizDao.findQuiz(12L));

        List<Quiz> quizzes = quizDao.findStudentQuizzes(4L);

        assertEquals(testQuizzes, quizzes);
    }

    @Test
    public void test_find_quizzes_number_by_authorId() {
        Integer quizzesNumber = quizDao.findQuizzesNumber(1L);
        assertThat(quizzesNumber, is(9));
    }

    @Test
    public void test_find_students_number_by_authorId_and_groupId_and_quizId_with_studentQuizStatus() {
        Map<StudentQuizStatus, Integer> testResults = new HashMap<>();
        testResults.put(OPENED, 1);
        testResults.put(PASSED, 2);
        testResults.put(CLOSED, 3);

        Map<StudentQuizStatus, Integer> results
                = quizDao.findStudentsNumberWithStudentQuizStatus(
                1L, 1L, 1L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_find_quizzes_number_by_authorId_with_teacherQuizStatus() {
        Map<TeacherQuizStatus, Integer> testResults = new HashMap<>();
        testResults.put(PUBLISHED, 5);
        testResults.put(TeacherQuizStatus.UNPUBLISHED, 4);

        Map<TeacherQuizStatus, Integer> results
                = quizDao.findQuizzesNumberByAuthorIdWithTeacherQuizStatus(1L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_find_quizzes_by_studentId_and_authorId() {
        List<Quiz> testQuizzes = new ArrayList<>();
        testQuizzes.add(quizDao.findQuiz(1L));
        testQuizzes.add(quizDao.findQuiz(2L));
        testQuizzes.add(quizDao.findQuiz(11L));
        testQuizzes.add(quizDao.findQuiz(5L));

        List<Quiz> quizzes = quizDao.findQuizzes(3L, 1L);
        assertEquals(testQuizzes, quizzes);
    }

    @Test
    public void test_find_common_quizzes_for_two_students() {
        List<Quiz> student1Quizzes = quizDao.findStudentQuizzes(3L);
        List<Quiz> students2Quizzes = quizDao.findStudentQuizzes(11L);
        student1Quizzes.retainAll(students2Quizzes);
        List<Long> testCommonQuizIds = student1Quizzes.stream()
                .map(Quiz::getQuizId)
                .collect(Collectors.toList());

        List<Long> commonQuizIds = quizDao.findCommonQuizIds(3L, 11L);

        assertEquals(testCommonQuizIds, commonQuizIds);
    }

    @Test
    public void test_find_teacher_quiz_ids() {
        List<Long> testTeacherQuizIds = Arrays.asList(3L, 4L, 6L, 7L, 8L);
        List<Long> teacherQuizIds = quizDao.findTeacherQuizIds(2L);
        assertEquals(testTeacherQuizIds, teacherQuizIds);
    }

    @Test
    public void test_find_student_quiz_ids() {
        List<Long> testStudentQuizIds = Arrays.asList(3L, 5L, 6L, 11L);
        List<Long> studentQuizIds = quizDao.findStudentQuizIds(5L);
        assertEquals(testStudentQuizIds, studentQuizIds);
    }

    @Test
    public void test_find_result_by_studentId_and_quizId() {
        Integer result = quizDao.findResult(3L, 1L);
        assertThat(result, is(20));
    }

    @Test
    public void test_find_submitDate_by_studentId_and_quizId() {
        LocalDateTime testSubmitDate
                = LocalDateTime.of(2018, 3, 5, 0, 0, 0);
        LocalDateTime submitDate
                = quizDao.findSubmitDate(3L, 1L);
        assertThat(submitDate, is(testSubmitDate));
    }

    @Test
    public void test_find_startDate_by_studentId_and_quizId() {
        LocalDateTime testStartDate
                = LocalDateTime.of(2018, 3, 5, 0, 0, 12);
        LocalDateTime startDate
                = quizDao.findStartDate(3L, 1L);
        assertThat(startDate, is(testStartDate));
    }

    @Test
    public void test_find_finishDate_by_studentId_and_quizId() {
        LocalDateTime testFinishDate
                = LocalDateTime.of(2018, 3, 5, 0, 0, 15);
        LocalDateTime finishDate
                = quizDao.findFinishDate(3L, 1L);
        assertThat(finishDate, is(testFinishDate));
    }

    @Test
    public void test_find_attempt_by_studentId_and_quizId() {
        Integer result = quizDao.findAttempt(3L, 1L);
        assertThat(result, is(2));
    }

    @Test
    public void test_find_studentQuizStatus_by_studentId_and_quizId() {
        StudentQuizStatus studentQuizStatus
                = quizDao.findStudentQuizStatus(5L, 5L);
        assertThat(studentQuizStatus, is(PASSED));
    }

    @Test
    public void test_find_closing_date_by_groupId_and_quizId() {
        List<User> students = userDao.findStudents(1L);
        Optional<LocalDateTime> finishDate = students.stream()
                .map(student -> quizDao.findFinishDate(student.getUserId(), 3L))
                .max(LocalDateTime::compareTo);
        LocalDateTime testClosingDate = finishDate.orElse(LocalDateTime.now());

        LocalDateTime closingDate = quizDao.findClosingDate(1L, 3L);

        assertEquals(testClosingDate, closingDate);
    }

    @Test
    public void test_find_opened_quiz_by_studentId_and_quizId() {
        OpenedQuiz testOpenedQuiz = new OpenedQuiz.OpenedQuizBuilder()
                .quizId(5L)
                .quizName("Input output")
                .description("Try your IO skills")
                .passingTime(Duration.of(15, MINUTES))
                .authorName("Bronson Andrew")
                .questionsNumber(2)
                .score(5)
                .submitDate(LocalDateTime.of(2018, 3, 5, 0, 24, 0))
                .build();

        OpenedQuiz openedQuiz = quizDao.findOpenedQuiz(4L, 5L);

        assertEquals(testOpenedQuiz, openedQuiz);
    }

    @Test
    public void test_find_passed_quiz_by_studentId_and_quizId() {
        PassedQuiz testPassedQuiz = new PassedQuiz.PassedQuizBuilder()
                .quizId(4L)
                .quizName("Multithreading")
                .description("Try your multithreading skills")
                .explanation("Hope you had multithreading fun :)")
                .authorName("Peterson Angel")
                .result(3)
                .score(4)
                .questionsNumber(1)
                .attempt(2)
                .passingTime(Duration.of(10, SECONDS))
                .submitDate(LocalDateTime.of(2018, 3, 5, 0, 8, 0))
                .finishDate(LocalDateTime.of(2018, 3, 11, 0, 16, 4))
                .timeSpent(Duration.ofSeconds(364))
                .build();

        PassedQuiz passedQuiz = quizDao.findPassedQuiz(4L, 4L);

        assertEquals(testPassedQuiz, passedQuiz);
    }

    @Test
    public void test_find_closed_quiz_by_studentId_and_quizId() {
        PassedQuiz testFinishedQuiz = new PassedQuiz.PassedQuizBuilder()
                .quizId(3L)
                .quizName("Collections")
                .description("Try your collections skills")
                .explanation("Hope you had fun with collections :)")
                .authorName("Peterson Angel")
                .result(2)
                .score(3)
                .questionsNumber(2)
                .attempt(2)
                .passingTime(Duration.of(15, MINUTES))
                .submitDate(LocalDateTime.of(2018, 3, 6, 0, 14, 0))
                .finishDate(LocalDateTime.of(2018, 3, 11, 0, 5, 0))
                .timeSpent(Duration.ofMinutes(5L))
                .build();

        PassedQuiz finishedQuiz = quizDao.findClosedQuiz(4L, 3L);

        assertEquals(testFinishedQuiz, finishedQuiz);
    }

    @Test
    public void test_find_opened_quizzes_by_studentId() {
        List<OpenedQuiz> testOpenedQuizzes = new ArrayList<>();
        testOpenedQuizzes.add(quizDao.findOpenedQuiz(4L, 11L));
        testOpenedQuizzes.add(quizDao.findOpenedQuiz(4L, 6L));
        testOpenedQuizzes.add(quizDao.findOpenedQuiz(4L, 5L));

        List<OpenedQuiz> openedQuizzes =
                quizDao.findOpenedQuizzes(4L);

        assertEquals(testOpenedQuizzes, openedQuizzes);
    }

    @Test
    public void test_find_passed_quizzes_by_studentId() {
        List<PassedQuiz> testPassedQuizzes = new ArrayList<>();
        testPassedQuizzes.add(quizDao.findPassedQuiz(4L, 12L));
        testPassedQuizzes.add(quizDao.findPassedQuiz(4L, 4L));
        testPassedQuizzes.add(quizDao.findPassedQuiz(4L, 1L));

        List<PassedQuiz> passedQuizzes
                = quizDao.findPassedQuizzes(4L);

        assertEquals(testPassedQuizzes, passedQuizzes);
    }

    @Test
    public void test_find_closed_quizzes_by_studentId() {
        List<PassedQuiz> testClosedQuizzes = new ArrayList<>();
        testClosedQuizzes.add(quizDao.findClosedQuiz(4L, 3L));
        testClosedQuizzes.add(quizDao.findClosedQuiz(4L, 2L));

        List<PassedQuiz> closedQuizzes
                = quizDao.findClosedQuizzes(4L);

        assertEquals(testClosedQuizzes, closedQuizzes);
    }

    @Test
    public void test_find_opened_quizzes_by_studentId_and_teacherId() {
        List<OpenedQuiz> testOpenedQuizzes = new ArrayList<>();
        testOpenedQuizzes.add(quizDao.findOpenedQuiz(4L, 11L));
        testOpenedQuizzes.add(quizDao.findOpenedQuiz(4L, 5L));

        List<OpenedQuiz> openedQuizzes = quizDao.findOpenedQuizzes(4L, 1L);

        assertEquals(testOpenedQuizzes, openedQuizzes);
    }

    @Test
    public void test_find_passed_quizzes_by_studentId_and_teacherId() {
        List<PassedQuiz> testPassedQuizzes = new ArrayList<>();
        testPassedQuizzes.add(quizDao.findPassedQuiz(4L, 12L));
        testPassedQuizzes.add(quizDao.findPassedQuiz(4L, 1L));

        List<PassedQuiz> passedQuizzes = quizDao.findPassedQuizzes(4L, 1L);

        assertEquals(testPassedQuizzes, passedQuizzes);
    }

    @Test
    public void test_find_closed_quizzes_by_studentId_and_teacherId() {
        List<PassedQuiz> testClosedQuizzes = new ArrayList<>();
        testClosedQuizzes.add(quizDao.findClosedQuiz(4L, 2L));

        List<PassedQuiz> closedQuizzes = quizDao.findClosedQuizzes(4L, 1L);

        assertEquals(testClosedQuizzes, closedQuizzes);
    }

    @Test
    public void test_quiz_exists_by_name() {
        assertTrue(quizDao.quizExistsByName("Procedural"));
        assertTrue(quizDao.quizExistsByName("SQL"));
        assertFalse(quizDao.quizExistsByName("Test name"));
    }

    @Test
    public void test_add_published_quiz_info() {
        List<Long> studentIds = Arrays.asList(14L, 13L, 11L, 12L, 3L, 4L);
        int testSubmitDateSeconds = LocalDateTime.now().getSecond();
        quizDao.addPublishedQuizInfo(studentIds, 10L);

        for (Long studentsId : studentIds) {
            int submitDateSeconds = quizDao.findOpenedQuiz(studentsId, 10L)
                    .getSubmitDate()
                    .getSecond();

            assertEquals(testSubmitDateSeconds, submitDateSeconds);
        }
    }

    @Test
    public void test_add_quiz() {
        Quiz testQuiz = new Quiz.QuizBuilder()
                .name("Spring core")
                .description("description")
                .explanation("explanation")
                .creationDate(LocalDate.of(2018, 3, 7))
                .passingTime(Duration.of(10, MINUTES))
                .authorId(1L)
                .questionsNumber(1)
                .score(1)
                .teacherQuizStatus(TeacherQuizStatus.UNPUBLISHED)
                .build();
        Long quizId = quizDao.addQuiz(testQuiz);
        Question question = new Question.QuestionBuilder()
                .questionId(100_000L)
                .quizId(quizId)
                .body("Question body")
                .explanation("Question explanation")
                .score(1)
                .questionType(ONE_ANSWER)
                .build();
        questionDao.addQuestion(question);

        Quiz quiz = quizDao.findQuiz(quizId);

        assertEquals(testQuiz, quiz);
    }

    @Test
    public void test_edit_student_info_about_opened_quiz() {
        quizDao.editStudentInfoAboutOpenedQuiz(4L, 1L, 56,
                LocalDateTime.of(2018, 1, 10, 10, 2),
                1, PASSED);

        Integer result = quizDao.findResult(4L, 1L);
        LocalDateTime finishDate = quizDao.findFinishDate(4L, 1L);
        Integer attempt = quizDao.findAttempt(4L, 1L);
        StudentQuizStatus studentQuizStatus =
                quizDao.findStudentQuizStatus(4L, 1L);

        assertThat(result, is(56));
        assertThat(finishDate, is(LocalDateTime.of(2018, 1, 10, 10, 2)));
        assertThat(attempt, is(1));
        assertThat(studentQuizStatus, is(PASSED));
    }

    @Test
    public void test_edit_teacherQuizStatus_by_quizId() {
        quizDao.editTeacherQuizStatus(TeacherQuizStatus.UNPUBLISHED, 4L);
        TeacherQuizStatus teacherQuizStatus = quizDao
                .findQuiz(4L)
                .getTeacherQuizStatus();
        assertThat(teacherQuizStatus, is(TeacherQuizStatus.UNPUBLISHED));
    }

    @Test
    public void test_edit_quiz_by_quiz_id_name_description_explnation_passing_time() {
        quizDao.editQuiz(1L, "Name", "Description", "Explanation",
                Duration.ofSeconds(3680));

        Quiz quiz = quizDao.findQuiz(1L);

        assertThat(quiz.getName(), is("Name"));
        assertThat(quiz.getDescription(), is("Description"));
        assertThat(quiz.getExplanation(), is("Explanation"));
        assertThat(quiz.getPassingTime(), is(Duration.ofSeconds(3680)));
    }

    @Test
    public void edit_students_info_with_opened_quiz_status() {
        quizDao.editStudentsInfoWithOpenedQuizStatus(1L, 1L);
        List<User> students = userDao.findStudents(1L, 1L);
        for (User student : students) {
            Long studentId = student.getUserId();
            Integer result = quizDao.findResult(studentId, 1L);
            if (result.equals(0)) {
                Integer attempt = quizDao.findAttempt(studentId, 1L);
                Integer finishDate = quizDao.findFinishDate(studentId, 1L).getSecond();
                assertThat(attempt, is(0));
                assertThat(finishDate, is(LocalDateTime.now().getSecond()));
            }
        }
    }

    @Test
    public void test_close_quiz_to_student() {
        quizDao.closeQuizToStudent(4L, 4L);
        StudentQuizStatus studentQuizStatus =
                quizDao.findStudentQuizStatus(4L, 4L);
        assertThat(studentQuizStatus, is(CLOSED));
    }

    @Test
    public void test_close_quiz_to_group() {
        quizDao.closeQuizToGroup(1L, 1L);
        List<User> students = userDao.findStudents(1L, 1L);
        for (User student : students) {
            StudentQuizStatus status = quizDao.findStudentQuizStatus(student.getUserId(), 1L);
            assertThat(status, is(CLOSED));
        }
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void test_delete_unpublished_quiz() {
        quizDao.deleteUnpublishedQuiz(10L);
        quizDao.findQuiz(10L);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void test_delete_students_info_about_quiz() {
        quizDao.deleteStudentsInfoAboutQuiz(1L);
        quizDao.findResult(4L, 1L);
    }
}