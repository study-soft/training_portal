package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.UserRole;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class UserDaoJdbc implements UserDao {

    private JdbcTemplate template;

    private static final Logger logger = Logger.getLogger(UserDaoJdbc.class);

    @Autowired
    public UserDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Transactional(readOnly = true)
    @Override
    public User findUserByUserId(Long userId) {
        User user = template.queryForObject(FIND_USER_BY_USER_ID,
                new Object[]{userId}, this::mapUser);
        logger.info("User found by userId: " + user);
        return user;
    }

    @Transactional(readOnly = true)
    @Override
    public User findUserByLogin(String login) {
        User user = template.queryForObject(FIND_USER_BY_LOGIN,
                new Object[]{login}, this::mapUser);
        logger.info("User found by login: " + user);
        return user;
    }

    @Transactional(readOnly = true)
    @Override
    public User findUserByEmail(String email) {
        User user = template.queryForObject(FIND_USER_BY_EMAIL,
                new Object[]{email}, this::mapUser);
        logger.info("User found by email: " + user);
        return user;
    }

    @Transactional(readOnly = true)
    @Override
    public User findUserByPhoneNumber(String phoneNumber) {
        User user = template.queryForObject(FIND_USER_BY_PHONE_NUMBER,
                new Object[]{phoneNumber}, this::mapUser);
        logger.info("User found by phoneNumber: " + user);
        return user;
    }

    @Transactional(readOnly = true)
    @Override
    public List<User> findUsersByFirstNameAndLastNameAndUserRole(String firstName,
                                                                 String lastName,
                                                                 UserRole userRole) {
        List<User> users = template.query(FIND_USERS_BY_FIRST_NAME_AND_LAST_NAME_AND_USER_ROLE,
                new Object[]{firstName, lastName, userRole.getRole()}, this::mapUser);
        logger.info("Users found by firstName, lastName, userRole:");
        users.forEach(logger::info);
        return users;
    }

    @Transactional(readOnly = true)
    @Override
    public List<User> findStudentsByGroupId(Long groupId) {
        List<User> students = template.query(FIND_STUDENTS_BY_GROUP_ID,
                new Object[]{groupId}, this::mapUser);
        logger.info("Students found by groupId:");
        students.forEach(logger::info);
        return students;
    }

    @Transactional(readOnly = true)
    @Override
    public List<User> findAllStudents() {
        List<User> students = template.query(FIND_ALL_STUDENTS, this::mapUser);
        logger.info("All students found:");
        students.forEach(logger::info);
        return students;
    }

    @Transactional(readOnly = true)
    @Override
    public List<User> findAllTeachers() {
        List<User> teachers = template.query(FIND_ALL_TEACHERS, this::mapUser);
        logger.info("All teachers found:");
        teachers.forEach(logger::info);
        return teachers;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findStudentIdsWithoutGroup() {
        List<Long> studentIds = template.queryForList(FIND_STUDENT_IDS_WITHOUT_GROUP, Long.class);
        logger.info("Found studentIds without group: " + studentIds);
        return studentIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findStudentIdsByGroupIdAndQuizId(Long groupId, Long quizId) {
        List<Long> studentIds = template.queryForList(FIND_STUDENT_IDS_BY_GROUP_ID_AND_QUIZ_ID,
                new Object[]{groupId, quizId}, Long.class);
        logger.info("Found student ids by groupId and quizId: " + studentIds);
        return studentIds;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findStudentsNumber() {
        Integer studentsNumber = template.queryForObject(FIND_STUDENTS_NUMBER, Integer.class);
        logger.info("Found students number: " + studentsNumber);
        return studentsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findTeachersNumber() {
        Integer teachersNumber = template.queryForObject(FIND_TEACHERS_NUMBER, Integer.class);
        logger.info("Found teachers number: " + teachersNumber);
        return teachersNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findStudentsNumberInGroup(Long groupId) {
        Integer studentsNumber = template.queryForObject(FIND_STUDENTS_NUMBER_IN_GROUP,
                new Object[]{groupId}, Integer.class);
        logger.info("Students number in group found: " + studentsNumber);
        return studentsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findStudentsNumberInGroupWithFinishedQuiz(Long groupId, Long quizId) {
        Integer studentsNumber = template.queryForObject(
                FIND_STUDENTS_NUMBER_IN_GROUP_WITH_FINISHED_QUIZ,
                new Object[]{groupId, quizId}, Integer.class);
        logger.info("Students number in group with finished quiz found: " + studentsNumber);
        return studentsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId) {
        Integer resultsNumber = template.queryForObject(
                FIND_RESULTS_NUMBER_BY_GROUP_ID_AND_QUIZ_ID,
                new Object[]{groupId, quizId}, Integer.class);
        logger.info("Results number by groupId and quizId found: " + resultsNumber);
        return resultsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findFinalResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId) {
        Integer resultsNumber = template.queryForObject(
                FIND_FINAL_RESULTS_NUMBER_BY_GROUP_ID_AND_QUIZ_ID,
                new Object[]{groupId, quizId}, Integer.class);
        logger.info("Final results number by groupId and quizId found: " + resultsNumber);
        return resultsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<Long, Integer> findStudentIdsAndResultsByGroupIdAndQuizId(Long groupId,
                                                                         Long quizId) {
        Map<Long, Integer> results = new HashMap<>();
        template.query(
                FIND_STUDENT_IDS_AND_RESULTS_BY_GROUP_ID_AND_QUIZ_ID,
                new Object[]{groupId, quizId}, new ResultSetExtractor<Map<Long, Integer>>() {
                    @Override
                    public Map<Long, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        while (rs.next()) {
                            Long studentId = rs.getLong(1);
                            Integer result = rs.getInt(2);
                            results.put(studentId, result);
                        }
                        return results;
                    }
                });
        logger.info("Found studentIds and results by groupId and quizId: ");
        results.forEach((studentId, result) ->
                logger.info("studentId: " + studentId + ", result: " + result));
        return results;
    }

    @Transactional(readOnly = true)
    @Override
    public Long findUserQuizJunctionIdByStudentIdAndQuizId(Long studentId, Long quizId) {
        Long id = template.queryForObject(
                FIND_USER_QUIZ_JUNCTION_ID_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, Long.class);
        logger.info("userQuizJunctionId by studentId, quizId found: " + id);
        return id;
    }

    @Transactional(readOnly = true)
    @Override
    public boolean userExists(String login, String email, String phoneNumber) {
        List<User> users = template.query(
                FIND_USER_BY_LOGIN_EMAIL_PHONE_NUMBER,
                new Object[]{login, email, phoneNumber}, this::mapUser);
        boolean exists = !users.isEmpty();
        if (exists) {
            logger.info("User with login '" + login + "', email '" + email + "' " +
                    "and phoneNumber '" + phoneNumber + "' exists");
        } else {
            logger.info("User with login '" + login + "', email '" + email + "' " +
                    "and phoneNumber '" + phoneNumber + "' does not exists");
        }
        return exists;
    }

    @Transactional(readOnly = true)
    @Override
    public User checkUserByLoginAndPassword(String login, String password) {
        User user = template.query(FIND_USER_BY_LOGIN_AND_PASSWORD,
                new Object[]{login, password},
                new ResultSetExtractor<User>() {
                    @Override
                    public User extractData(ResultSet rs) throws SQLException, DataAccessException {
                        if (!rs.next()) {
                            return null;
                        }
                        return mapUser(rs, 0);
                    }
                });
        logger.info("User by login and password found: " + user);
        return user;
    }

    @Transactional
    @Override
    public Long registerUser(User user) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(REGISTER_USER, new String[]{"user_id"});
                stmt.setString(1, user.getFirstName());
                stmt.setString(2, user.getLastName());
                stmt.setString(3, user.getEmail());
                stmt.setDate(4, Date.valueOf(user.getDateOfBirth()));
                stmt.setString(5, user.getPhoneNumber());
                stmt.setString(6, user.getLogin());
                stmt.setString(7, user.getPassword());
                stmt.setString(8, user.getUserRole().getRole());
                return stmt;
            }
        }, keyHolder);
        long userId = keyHolder.getKey().longValue();
        user.setUserId(userId);
        logger.info("User registered: " + user);
        return userId;
    }

    @Transactional
    @Override
    public void addStudentToGroupByGroupIdAndUserId(Long groupId, Long studentId) {
        template.update(ADD_STUDENT_TO_GROUP_BY_GROUP_ID_AND_USER_ID, groupId, studentId);
        logger.info("Student with id = " + studentId +
                " added to group with id = '" + groupId + "'");
    }

    @Transactional
    @Override
    public void addStudentsToGroup(Long groupId, List<Long> studentIds) {
        for (Long id : studentIds) {
            template.update(ADD_STUDENT_TO_GROUP_BY_GROUP_ID_AND_USER_ID, groupId, id);
        }
        logger.info("Students with ids = " + studentIds +
                " added to group with id = '" + groupId + "'");
    }

    @Transactional
    @Override
    public Long addStudentInfoAboutQuiz(
            Long studentId, Long quizId, Integer result, LocalDateTime submitDate,
            LocalDateTime startDate, LocalDateTime finishDate, StudentQuizStatus studentQuizStatus) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
                    @Override
                    public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                        PreparedStatement stmt = con.prepareStatement(
                                ADD_STUDENT_INFO_ABOUT_QUIZ,
                                Statement.RETURN_GENERATED_KEYS);
                        stmt.setLong(1, studentId);
                        stmt.setLong(2, quizId);
                        stmt.setInt(3, result);
                        stmt.setTimestamp(4, Timestamp.valueOf(submitDate));
                        stmt.setTimestamp(5, Timestamp.valueOf(startDate));
                        stmt.setTimestamp(6, Timestamp.valueOf(finishDate));
                        stmt.setString(7, studentQuizStatus.getStudentQuizStatus());
                        return stmt;
                    }
                }, keyHolder);
        long userQuizJunctionId = keyHolder.getKey().longValue();
        logger.info("Added student info about quiz:");
        logger.info("userQuizJunctionId: " + userQuizJunctionId +
                ", studentId: " + studentId +
                ", quizId: " + quizId +
                ", result: " + result +
                ", submitDate: " + submitDate.toString() +
                ", startDate: " + startDate.toString() +
                ", finishDate: " + finishDate.toString() +
                ", studentQuizStatus: " + studentQuizStatus.getStudentQuizStatus());
        return userQuizJunctionId;
    }

    @Transactional
    @Override
    public void updateStudentInfoAboutQuiz(
            Long userQuizJunctionId, Integer result, LocalDateTime startDate,
            LocalDateTime finishDate, Integer attempt, StudentQuizStatus studentQuizStatus) {
        template.update(UPDATE_STUDENT_INFO_ABOUT_QUIZ,
                result, Timestamp.valueOf(startDate), Timestamp.valueOf(finishDate),
                attempt, studentQuizStatus.getStudentQuizStatus(), userQuizJunctionId);
        logger.info("Updated student info about quiz:");
        logger.info("userQuizJunctionId: " + userQuizJunctionId +
        ", result: " + result +
        ", startDate: " + startDate +
        ", finishDate: " + finishDate.toString() +
        ", attempt: " + attempt +
        ", studentQuizStatus: " + studentQuizStatus.getStudentQuizStatus());
    }

    @Override
    public void editUser(User user) {
        throw new UnsupportedOperationException();
    }

    @Transactional
    @Override
    public void deleteStudentFromGroupByUserId(Long userId) {
        template.update(DELETE_STUDENT_FROM_GROUP_BY_USER_ID, userId);
        logger.info("Student deleted from group by userId: " + userId);
    }

    @Transactional
    @Override
    public void deleteStudentsFromGroupByGroupId(Long groupId) {
        template.update(DELETE_STUDENTS_FROM_GROUP_BY_GROUP_ID, groupId);
        logger.info("Students deleted form group by groupId: " + groupId);
    }

    private User mapUser(ResultSet rs, int rowNum) throws SQLException {
        return new User.UserBuilder()
                .userId(rs.getLong("user_id"))
                .groupId(rs.getLong("group_id"))
                .firstName(rs.getString("first_name"))
                .lastName(rs.getString("last_name"))
                .email(rs.getString("email"))
                .dateOfBirth(rs.getDate("date_of_birth").toLocalDate())
                .phoneNumber(rs.getString("phone_number"))
                .photo(null)
                .login(rs.getString("login"))
                .password(rs.getString("password"))
                .userRole(UserRole.valueOf(rs.getString("user_role")))
                .build();
    }

    private static final String FIND_USER_BY_USER_ID = "SELECT * FROM USERS WHERE USER_ID = ?;";

    private static final String FIND_USER_BY_LOGIN = "SELECT * FROM USERS WHERE LOGIN = ?;";

    private static final String FIND_USER_BY_EMAIL = "SELECT * FROM USERS WHERE EMAIL = ?;";

    private static final String FIND_USER_BY_PHONE_NUMBER = "SELECT * FROM USERS WHERE PHONE_NUMBER = ?;";

    private static final String FIND_USERS_BY_FIRST_NAME_AND_LAST_NAME_AND_USER_ROLE =
    "SELECT * FROM USERS WHERE FIRST_NAME = ? AND LAST_NAME = ? AND USER_ROLE = ?";

    private static final String FIND_STUDENTS_BY_GROUP_ID =
    "SELECT * " +
    "FROM USERS " +
    "WHERE GROUP_ID IS ? AND USER_ROLE = 'STUDENT';";

    private static final String FIND_ALL_STUDENTS = "SELECT * FROM USERS WHERE USER_ROLE = 'STUDENT';";

    private static final String FIND_ALL_TEACHERS = "SELECT * FROM USERS WHERE USER_ROLE = 'TEACHER';";

    private static final String FIND_STUDENT_IDS_WITHOUT_GROUP =
    "SELECT USER_ID FROM USERS WHERE USER_ROLE = 'STUDENT' AND GROUP_ID IS NULL;";

    private static final String FIND_STUDENT_IDS_BY_GROUP_ID_AND_QUIZ_ID =
    "SELECT USERS.USER_ID " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "WHERE USERS.USER_ROLE = 'STUDENT' AND USERS.GROUP_ID IS ? AND J.QUIZ_ID = ?;";

    private static final String FIND_STUDENTS_NUMBER =
    "SELECT COUNT(USER_ID) FROM USERS WHERE USER_ROLE = 'STUDENT';";

    private static final String FIND_TEACHERS_NUMBER =
    "SELECT COUNT(USER_ID) FROM USERS WHERE USER_ROLE = 'TEACHER';";

    private static final String FIND_STUDENTS_NUMBER_IN_GROUP =
    "SELECT COUNT(USER_ID) FROM USERS WHERE GROUP_ID IS ?;";

    private static final String FIND_STUDENTS_NUMBER_IN_GROUP_WITH_FINISHED_QUIZ =
    "SELECT COUNT(USERS.USER_ID) " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "WHERE USERS.USER_ROLE = 'STUDENT' AND USERS.GROUP_ID IS ? AND J.QUIZ_ID = ? " +
    "AND J.STUDENT_QUIZ_STATUS = 'FINISHED';";

    private static final String FIND_RESULTS_NUMBER_BY_GROUP_ID_AND_QUIZ_ID =
    "SELECT COUNT(J.RESULT) " +
    "FROM USER_QUIZ_JUNCTIONS J INNER JOIN USERS ON J.USER_ID = USERS.USER_ID " +
    "WHERE USERS.GROUP_ID IS ? AND J.QUIZ_ID = ?;";

    private static final String FIND_FINAL_RESULTS_NUMBER_BY_GROUP_ID_AND_QUIZ_ID =
    "SELECT COUNT(J.RESULT) " +
    "FROM USER_QUIZ_JUNCTIONS J INNER JOIN USERS ON J.USER_ID = USERS.USER_ID " +
    "WHERE USERS.GROUP_ID IS ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'FINISHED';";

    private static final String FIND_STUDENT_IDS_AND_RESULTS_BY_GROUP_ID_AND_QUIZ_ID =
    "SELECT USERS.USER_ID, J.RESULT " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "WHERE USERS.GROUP_ID IS ? AND J.QUIZ_ID = ?;";

    private static final String FIND_USER_QUIZ_JUNCTION_ID_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT J.USER_QUIZ_JUNCTION_ID FROM USER_QUIZ_JUNCTIONS J WHERE J.USER_ID = ? AND J.QUIZ_ID = ?;";

    private static final String FIND_USER_BY_LOGIN_EMAIL_PHONE_NUMBER =
    "SELECT * FROM USERS WHERE LOGIN = ? AND EMAIL = ? AND PHONE_NUMBER = ?;";

    private static final String FIND_USER_BY_LOGIN_AND_PASSWORD =
    "SELECT * FROM USERS WHERE LOGIN = ? AND PASSWORD = ?;";

    private static final String REGISTER_USER =
    "INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, " +
    "DATE_OF_BIRTH, PHONE_NUMBER, LOGIN, PASSWORD, USER_ROLE) " +
    "VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);";

    private static final String ADD_STUDENT_TO_GROUP_BY_GROUP_ID_AND_USER_ID =
    "UPDATE USERS " +
    "SET GROUP_ID = ? " +
    "WHERE USER_ID = ? AND USER_ROLE = 'STUDENT';";

    private static final String ADD_STUDENT_INFO_ABOUT_QUIZ =
    "INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, " +
    "START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS) " +
    "VALUES (?, ?, ?, ?, ?, ?, 0, ?);";

    private static final String UPDATE_STUDENT_INFO_ABOUT_QUIZ =
    "UPDATE USER_QUIZ_JUNCTIONS " +
    "SET RESULT = ?, START_DATE = ?, FINISH_DATE = ?, ATTEMPT = ?, STUDENT_QUIZ_STATUS = ? " +
    "WHERE USER_QUIZ_JUNCTION_ID = ?;";

    private static final String EDIT_USER = "";

    private static final String DELETE_STUDENT_FROM_GROUP_BY_USER_ID =
    "UPDATE USERS SET GROUP_ID = NULL WHERE USER_ID = ? AND USER_ROLE = 'STUDENT';";

    private static final String DELETE_STUDENTS_FROM_GROUP_BY_GROUP_ID =
    "UPDATE USERS SET GROUP_ID = NULL WHERE GROUP_ID = ? AND USER_ROLE = 'STUDENT';";
}