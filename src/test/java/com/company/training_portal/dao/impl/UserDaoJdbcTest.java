package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.UserRole;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@WebAppConfiguration
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:schema.sql", "classpath:test-data.sql"})
public class UserDaoJdbcTest {

    @Autowired
    private UserDao userDao;

    @Autowired
    private QuizDao quizDao;

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    public void setQuizDao(QuizDao quizDao) {
        this.quizDao = quizDao;
    }

    @Test
    public void test_find_user_by_userId_login_email_phoneNumber() {
        User testUser = new User.UserBuilder()
                .userId(4L)
                .groupId(1L)
                .firstName("Artem")
                .lastName("Yakovenko")
                .email("artem@example.com")
                .dateOfBirth(LocalDate.of(1996, 1, 28))
                .phoneNumber("095-98-76-54")
                .photo(null)
                .login("Artem")
                .password("123")
                .userRole(UserRole.STUDENT)
                .build();

        User userByUserId = userDao.findUser(4L);
        User userByLogin = userDao.findUserByLogin("Artem");
        User userByEmail = userDao.findUserByEmail("artem@example.com");
        User userByPhoneNumber = userDao.findUserByPhoneNumber("095-98-76-54");

        assertEquals(testUser, userByUserId);
        assertEquals(testUser, userByLogin);
        assertEquals(testUser, userByEmail);
        assertEquals(testUser, userByPhoneNumber);
    }

    @Test
    public void test_find_userName_by_userId() {
        String userName = userDao.findUserName(4L);
        assertThat(userName, is("Yakovenko Artem"));
    }

    @Test
    public void test_find_users_by_firstName_and_lastName_and_UserRole() {
        User testUser = userDao.findUser(4L);
        List<User> testUsersList = new ArrayList<>();
        testUsersList.add(testUser);

        List<User> userList = userDao.findUsers("Artem",
                "Yakovenko", UserRole.STUDENT);

        assertEquals(testUsersList, userList);
    }

    @Test
    public void test_find_students_by_groupId() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(3L));
        testStudents.add(userDao.findUser(4L));

        List<User> students = userDao.findStudents(1L);

        assertEquals(testStudents, students);
    }

    @Test
    public void test_find_students_by_groupId_and_quizId() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(3L));
        testStudents.add(userDao.findUser(4L));

        List<User> students = userDao.findStudents(1L, 11L);

        assertEquals(testStudents, students);
    }

    @Test
    public void test_find_students_by_teacherId() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(5L));
        testStudents.add(userDao.findUser(7L));
        testStudents.add(userDao.findUser(3L));
        testStudents.add(userDao.findUser(4L));

        List<User> students = userDao.findStudentsByTeacherId(1L);

        assertEquals(testStudents, students);
    }

    @Test
    public void test_find_all_students() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(3L));
        testStudents.add(userDao.findUser(4L));
        testStudents.add(userDao.findUser(5L));
        testStudents.add(userDao.findUser(6L));
        testStudents.add(userDao.findUser(7L));
        testStudents.add(userDao.findUser(8L));

        List<User> students = userDao.findAllStudents();

        assertEquals(testStudents, students);
    }

    @Test
    public void test_find_students_without_group() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(8L));
        testStudents.add(userDao.findUser(7L));

        List<User> students = userDao.findStudentsWithoutGroup();

        assertEquals(testStudents, students);
    }

    @Test
    public void test_find_students_without_group_by_teacherId() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(7L));

        List<User> students = userDao.findStudentsWithoutGroup(1L);

        assertEquals(testStudents, students);
    }

    @Test
    public void test_find_students_without_group_for_quiz_publication() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(9L));
        testStudents.add(userDao.findUser(10L));
        testStudents.add(userDao.findUser(8L));
        testStudents.add(userDao.findUser(7L));

        List<User> students = userDao.findStudentsWithoutGroupForQuizPublication(3L);

        assertEquals(students, testStudents);
    }

    @Test
    public void test_find_students_for_quiz_publication_by_groupId_and_quizId() {
        List<User> testStudents = new ArrayList<>();
        testStudents.add(userDao.findUser(14L));
        testStudents.add(userDao.findUser(13L));
        testStudents.add(userDao.findUser(11L));
        testStudents.add(userDao.findUser(12L));

        List<User> students = userDao.findStudentsForQuizPublication(1L, 11L);

        assertEquals(students, testStudents);
    }

    @Test
    public void test_find_all_teachers() {
        List<User> testTeachers = new ArrayList<>();
        testTeachers.add(userDao.findUser(1L));
        testTeachers.add(userDao.findUser(2L));

        List<User> teachers = userDao.findAllTeachers();

        assertEquals(testTeachers, teachers);
    }



    @Test
    public void test_find_students_number() {
        Integer studentsNumber = userDao.findStudentsNumber();
        assertThat(studentsNumber, is(6));
    }

    @Test
    public void test_find_teachers_number() {
        Integer teachersNumber = userDao.findTeachersNumber();
        assertThat(teachersNumber, is(2));
    }

    @Test
    public void test_find_students_number_by_groupId_and_quizId() {
        Integer studentsNumber1 = userDao.findStudentsNumber(1L, 1L);
        Integer studentsNumber2 = userDao.findStudentsNumber(1L, 12L);

        assertThat(studentsNumber1, is(6));
        assertThat(studentsNumber2, is(2));
    }

    @Test
    public void test_find_students_number_in_group_with_finished_quiz() {
        Integer studentsNumber =
                userDao.findStudentsNumberInGroupWithClosedQuiz(1L, 1L);
        assertThat(studentsNumber, is(1));
    }

    @Test
    public void test_find_results_number_by_groupId_and_quizId() {
        Integer resultsNumber =
                userDao.findResultsNumber(null, 1L);
        assertThat(resultsNumber, is(1));
    }

    @Test
    public void test_find_final_results_number_by_groupId_and_quizId() {
        Integer finalResultsNumber =
                userDao.findFinalResultsNumber(1L, 1L);
        assertThat(finalResultsNumber, is(1));
    }

    @Test
    public void test_user_exists_by_login() {
        assertTrue(userDao.userExistsByLogin("Artem"));
        assertFalse(userDao.userExistsByLogin("Login"));
    }

    @Test
    public void test_user_exists_by_email() {
        assertTrue(userDao.userExistsByEmail("artem@example.com"));
        assertFalse(userDao.userExistsByEmail("email@example.com"));
    }

    @Test
    public void test_user_exists_by_phoneNumber() {
        assertTrue(userDao.userExistsByPhoneNumber("095-98-76-54"));
        assertFalse(userDao.userExistsByPhoneNumber("000-00-00-00"));
    }

    @Test
    public void test_check_user_by_login_and_password() {
        User testUser = userDao.findUser(4L);
        User user = userDao.checkUserByLoginAndPassword("Artem", "123");
        assertEquals(testUser, user);

        assertNull(userDao.checkUserByLoginAndPassword("Artem", "incorrect"));
    }

    @Test
    public void test_register_user() {
        User testUser = new User.UserBuilder()
                .groupId(0L)
                .firstName("Enrico")
                .lastName("Tester")
                .email("enrico@example.com")
                .dateOfBirth(LocalDate.of(2018, 3, 7))
                .phoneNumber("095-345-67-89")
                .login("Enrico")
                .password("123")
                .userRole(UserRole.STUDENT)
                .build();
        Long testUserId = userDao.registerUser(testUser);

        assertEquals(testUser, userDao.findUser(testUserId));
    }

    @Test
    public void test_add_student_to_group_by_groupId_and_userId() {
        userDao.addStudentToGroup(1L, 7L);

        User user = userDao.findUser(7L);
        Long groupId = user.getGroupId();

        assertThat(groupId, is(1L));
    }

    @Test
    public void test_add_students_to_group() {
        userDao.addStudentsToGroup(1L, Arrays.asList(7L, 8L));

        Long jasonGroupId = userDao.findUser(7L).getGroupId();
        Long williamGroupId = userDao.findUser(8L).getGroupId();

        assertThat(jasonGroupId, is(1L));
        assertThat(williamGroupId, is(1L));
    }

    @Test
    public void test_add_student_info_about_quiz() {
        userDao.addStudentInfoAboutQuiz(3L, 100L, 56,
                LocalDateTime.of(2018, 3, 7, 20, 48),
                LocalDateTime.of(2018, 4, 8, 21, 40),
                LocalDateTime.of(2018, 4, 8, 21, 49),
                StudentQuizStatus.PASSED);

        Integer result = quizDao.findResult(3L, 100L);
        LocalDateTime submitDate = quizDao.findSubmitDate(3L, 100L);
        LocalDateTime startDate = quizDao.findStartDate(3L, 100L);
        LocalDateTime finishDate = quizDao.findFinishDate(3L, 100L);
        Integer attempt = quizDao.findAttempt(3L, 100L);
        StudentQuizStatus studentQuizStatus = quizDao.findStudentQuizStatus(3L, 5L);

        assertThat(result, is(56));
        assertThat(submitDate, is(LocalDateTime.of(2018, 3, 7, 20, 48)));
        assertThat(startDate, is(LocalDateTime.of(2018, 4, 8, 21, 40)));
        assertThat(finishDate, is(LocalDateTime.of(2018, 4, 8, 21, 49)));
        assertThat(attempt, is(0));
        assertThat(studentQuizStatus, is(StudentQuizStatus.PASSED));
    }

    @Test
    public void test_update_student_info_about_quiz() {
        userDao.updateStudentInfoAboutQuiz(4L, 1L, 56,
                LocalDateTime.of(2018, 1, 10, 10, 2),
                LocalDateTime.of(2018, 1, 10, 10, 10),
                1, StudentQuizStatus.PASSED);

        Integer result = quizDao.findResult(4L, 1L);
        LocalDateTime startDate = quizDao.findStartDate(4L, 1L);
        LocalDateTime finishDate = quizDao.findFinishDate(4L, 1L);
        Integer reopenCounter = quizDao.findAttempt(4L, 1L);
        StudentQuizStatus studentQuizStatus =
                quizDao.findStudentQuizStatus(4L, 1L);

        assertThat(result, is(56));
        assertThat(startDate, is(LocalDateTime.of(2018, 1, 10, 10, 2)));
        assertThat(finishDate, is(LocalDateTime.of(2018, 1, 10, 10, 10)));
        assertThat(reopenCounter, is(1));
        assertThat(studentQuizStatus, is(StudentQuizStatus.PASSED));
    }

    @Test
    public void test_edit_user() {
        userDao.editUser(4L, "firstName", "lastName",
                "email@example.com", LocalDate.of(2000, 3, 25),
                "095-000-00-00", "password");

        User user = userDao.findUser(4L);

        assertThat(user.getFirstName(), is("firstName"));
        assertThat(user.getLastName(), is("lastName"));
        assertThat(user.getEmail(), is("email@example.com"));
        assertThat(user.getDateOfBirth(), is(LocalDate.of(2000, 3, 25)));
        assertThat(user.getPhoneNumber(), is("095-000-00-00"));
        assertThat(user.getPassword(), is("password"));
    }

    @Test
    public void test_delete_student_from_group_by_userId() {
        userDao.deleteStudentFromGroupByUserId(4L);
        Long groupId = userDao.findUser(4L).getGroupId();
        assertThat(groupId, is(0L));
    }

    @Test
    public void test_delete_students_form_group_by_groupId() {
        userDao.deleteStudentsFromGroupByGroupId(2L);

        Long mikeGroupId = userDao.findUser(5L).getGroupId();
        Long saraGroupId = userDao.findUser(6L).getGroupId();

        assertThat(mikeGroupId, is(0L));
        assertThat(saraGroupId, is(0L));
    }
}