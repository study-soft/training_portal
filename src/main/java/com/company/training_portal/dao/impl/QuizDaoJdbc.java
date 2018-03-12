package com.company.training_portal.dao.impl;

import com.company.training_portal.controller.table_rows.StudentOpenedQuiz;
import com.company.training_portal.controller.table_rows.StudentPassedQuiz;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.*;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class QuizDaoJdbc implements QuizDao {

    private JdbcTemplate template;

    private QuestionDao questionDao;
    private UserDao userDao;

    private static final Logger logger = Logger.getLogger(QuizDaoJdbc.class);

    @Autowired
    public QuizDaoJdbc(DataSource dataSource,
                       QuestionDao questionDao,
                       UserDao userDao) {
        template = new JdbcTemplate(dataSource);
        this.questionDao = questionDao;
        this.userDao = userDao;
    }

    @Transactional(readOnly = true)
    @Override
    public Quiz findQuizByQuizId(Long quizId) {
        Quiz quiz = template.queryForObject(FIND_QUIZ_BY_QUIZ_ID,
                new Object[]{quizId}, this::mapQuiz);
        logger.info("Quiz found by quizId: " + quiz);
        return quiz;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findAllQuizzes() {
        List<Quiz> quizzes = template.query(FIND_ALL_QUIZZES, this::mapQuiz);
        logger.info("All quizzes found:");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findAllQuizIds() {
        List<Long> quizIds = template.queryForList(FIND_ALL_QUIZ_IDS,
                Long.class);
        logger.info("All quiz ids found: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findAllQuizzesByAuthorId(Long authorId) {
        List<Quiz> quizzes = template.query(FIND_ALL_QUIZZES_BY_AUTHOR_ID,
                new Object[]{authorId}, this::mapQuiz);
        logger.info("All quizzes by authorId found:");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findAllQuizIdsByAuthorId(Long authorId) {
        List<Long> quizIds = template.queryForList(FIND_ALL_QUIZ_IDS_BY_AUTHOR_ID,
                new Object[]{authorId}, Long.class);
        logger.info("All quiz ids by authorId found: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findQuizzesByStudentId(Long studentId) {
        List<Quiz> quizzes = template.query(
                FIND_QUIZZES_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapQuiz);
        logger.info("Found quizzes by studentId: " + quizzes);
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findAllClosedQuizIdsByAuthorId(Long authorId) {
        List<Long> quizIds = template.queryForList(
                FIND_ALL_CLOSED_QUIZ_IDS_BY_AUTHOR_ID,
                new Object[]{authorId}, Long.class);
        logger.info("All closed quiz ids by authorId found: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findAllNotPublishedQuizIdsByAuthorId(Long authorId) {
        List<Long> quizIds = template.queryForList(FIND_ALL_NOT_PUBLISHED_QUIZ_IDS_BY_AUTHOR_ID,
                new Object[]{authorId}, Long.class);
        logger.info("All not published quiz ids by authorId found: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findAllQuizIdsByStudentIdAndStudentQuizStatus(
            Long studentId, StudentQuizStatus studentQuizStatus) {
        List<Long> quizIds = template.queryForList(
                FIND_ALL_QUIZ_IDS_BY_STUDENT_ID_AND_STUDENT_QUIZ_STATUS,
                new Object[]{studentId, studentQuizStatus.getStudentQuizStatus()},
                Long.class);
        logger.info("All quiz ids by studentId and studentQuizStatus: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findQuizzesNumberByAuthorId(Long authorId) {
        Integer quizzesNumber = template.queryForObject(FIND_QUIZZES_NUMBER_BY_AUTHOR_ID,
                new Object[]{authorId}, Integer.class);
        logger.info("Quizzes number found: " + quizzesNumber);
        return quizzesNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<StudentQuizStatus, Integer> findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(
            Long authorId, Long groupId, Long quizId) {
        Map<StudentQuizStatus, Integer> results = new HashMap<>();
        template.query(
                FIND_STUDENTS_NUMBER_BY_AUTHOR_ID_AND_GROUP_ID_AND_QUIZ_ID_WITH_STUDENT_QUIZ_STATUS,
                new Object[]{authorId, groupId, quizId},
                new ResultSetExtractor<Map<StudentQuizStatus, Integer>>() {
                    @Override
                    public Map<StudentQuizStatus, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        while (rs.next()) {
                            results.put(StudentQuizStatus.valueOf(rs.getString(1)),
                                    rs.getInt(2));
                        }
                        return results;
                    }
                });
        logger.info("All students number and student statuses by authorId, groupId, quizId found:");
        results.forEach((k, v) -> logger.info("status: " + k + ", number: " + v));
        return results;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<TeacherQuizStatus, Integer> FindQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId) {
        Map<TeacherQuizStatus, Integer> results = new HashMap<>();
        template.query(FIND_QUIZZES_NUMBER_BY_AUTHOR_ID_WITH_TEACHER_QUIZ_STATUS,
                new Object[]{authorId},
                new ResultSetExtractor<Map<TeacherQuizStatus, Integer>>() {
                    @Override
                    public Map<TeacherQuizStatus, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        while (rs.next()) {
                            results.put(TeacherQuizStatus.valueOf(rs.getString(1)),
                                    rs.getInt(2));
                        }
                        return results;
                    }
                });
        logger.info("All quizzes number and teacher statuses by authorId found:");
        results.forEach((k, v) -> logger.info("status: " + k + ", value: " + v));
        return results;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<Long, Integer> findAllStudentResults(Long studentId) {
        Map<Long, Integer> results = new HashMap<>();
        template.query(FIND_ALL_STUDENT_RESULTS, new Object[]{studentId},
                new ResultSetExtractor<Map<Long, Integer>>() {
                    @Override
                    public Map<Long, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        while (rs.next()) {
                            results.put(rs.getLong(1), rs.getInt(2));
                        }
                        return results;
                    }
                });
        logger.info("All student results by studentId found:");
        results.forEach((k, v) -> logger.info("quizId: " + k + ", result: " + v));
        return results;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findQuizIdsByStudentIdAndAttempt(Long studentId, Integer attempt) {
        List<Long> quizIds = template.queryForList(
                FIND_QUIZ_IDS_BY_STUDENT_ID_AND_ATTEMPT,
                new Object[]{studentId, attempt},
                Long.class);
        logger.info("All quiz ids by studentId and attempt found: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findQuizzesByStudentIdAndAuthorId(Long studentId, Long authorId) {
        List<Quiz> quizzes = template.query(
                FIND_QUIZZES_BY_STUDENT_ID_AND_AUTHOR_ID,
                new Object[]{studentId, authorId}, this::mapQuiz);
        logger.info("Found quizzes by studentId and authorId:");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findResultByStudentIdAndQuizId(Long studentId, Long quizId) {
        Integer result = template.queryForObject(FIND_RESULT_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, Integer.class);
        logger.info("Result by studentId and quizId found: " + result);
        return result;
    }

    @Transactional(readOnly = true)
    @Override
    public LocalDateTime findSubmitDateByStudentIdAndQuizId(Long studentId, Long quizId) {
        LocalDateTime submitDate = template.queryForObject(
                FIND_SUBMIT_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, LocalDateTime.class);
        logger.info("SubmitDate by studentId and quizId found: " + submitDate);
        return submitDate;
    }

    @Override
    public LocalDateTime findStartDateByStudentIdAndQuizId(Long studentId, Long quizId) {
        LocalDateTime startDate = template.queryForObject(
                FIND_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, LocalDateTime.class);
        logger.info("StartDate by studentId and quizId found: " + startDate);
        return startDate;
    }

    @Transactional(readOnly = true)
    @Override
    public LocalDateTime findFinishDateByStudentIdAndQuizId(Long studentId, Long quizId) {
        LocalDateTime finishDate = template.queryForObject(
                FIND_FINISH_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, LocalDateTime.class);
        logger.info("FinishDate by studentId and quizId found: " + finishDate);
        return finishDate;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findAttemptByStudentIdAndQuizId(Long studentId, Long quizId) {
        Integer attempt = template.queryForObject(
                FIND_ATTEMPT_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, Integer.class);
        logger.info("Attempt by studentId and quizId found: " + attempt);
        return attempt;
    }

    @Transactional(readOnly = true)
    @Override
    public StudentQuizStatus findStudentQuizStatusByStudentIdAndQuizId(Long studentId, Long quizId) {
        StudentQuizStatus studentQuizStatus = StudentQuizStatus.valueOf(template.queryForObject(
                FIND_STUDENT_QUIZ_STATUS_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, String.class));
        logger.info("StudentQuizStatus by studentId and quizId found: " + studentQuizStatus);
        return studentQuizStatus;
    }

    @Override
    public List<StudentOpenedQuiz> findOpenedQuizzesInfoByStudentId(Long studentId) {
        List<StudentOpenedQuiz> openedQuizzes = new ArrayList<>();
        template.query(FIND_OPENED_QUIZZES_INFO_BY_STUDENT_ID,
                new Object[]{studentId}, new ResultSetExtractor<List<StudentOpenedQuiz>>() {
                    @Override
                    public List<StudentOpenedQuiz> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        while (rs.next()) {
                            openedQuizzes.add(new StudentOpenedQuiz(rs.getString(1),
                                    userDao.findUserNameByUserId(rs.getLong(2)),
                                    rs.getInt(3),
                                    rs.getInt(4),
                                    rs.getTimestamp(5).toLocalDateTime()));
                        }
                        return openedQuizzes;
                    }
                });
        logger.info("Found opened quizzes info by studentId:");
        openedQuizzes.forEach(logger::info);
        return openedQuizzes;
    }

    @Override
    public List<StudentPassedQuiz> findPassedQuizzesInfoByStudentId(Long studentId) {
        List<StudentPassedQuiz> passedQuizzes = template.query(
                FIND_PASSED_QUIZZES_INFO_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapStudentPassedQuiz);
        logger.info("Found passed quizzes info by studentId:");
        passedQuizzes.forEach(logger::info);
        return passedQuizzes;
    }

    @Override
    public List<StudentPassedQuiz> findFinishedQuizzesInfoByStudentId(Long studentId) {
        List<StudentPassedQuiz> finishedQuizzes = template.query(
                FIND_FINISHED_QUIZZES_INFO_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapStudentPassedQuiz);
        logger.info("Found finished quizzes info by studentId:");
        finishedQuizzes.forEach(logger::info);
        return finishedQuizzes;
    }

    @Transactional
    @Override
    public Long addQuiz(Quiz quiz) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_QUIZ, new String[]{"quiz_id"});
                stmt.setString(1, quiz.getName());
                stmt.setString(2, quiz.getDescription());
                stmt.setString(3, quiz.getExplanation());
                stmt.setDate(4, Date.valueOf(quiz.getCreationDate()));
                stmt.setTime(5,
                        Time.valueOf(LocalTime.MIDNIGHT.plus(quiz.getPassingTime())));
                stmt.setLong(6, quiz.getAuthorId());
                stmt.setString(7, quiz.getTeacherQuizStatus().getTeacherQuizStatus());
                return stmt;
            }
        }, keyHolder);
        long quizId = keyHolder.getKey().longValue();
        quiz.setQuizId(quizId);
        logger.info("Quiz added: " + quiz);
        return quizId;
    }

    @Transactional
    @Override
    public void editTeacherQuizStatusByQuizId(TeacherQuizStatus teacherQuizStatus,
                                              Long quizId) {
        template.update(EDIT_TEACHER_QUIZ_STATUS_BY_QUIZ_ID,
                teacherQuizStatus.getTeacherQuizStatus(), quizId);
        logger.info("Edit teacher status to " + teacherQuizStatus +
                " in quiz with quizId " + quizId);
    }

    @Override
    public void editQuiz(Quiz quiz) {
        throw new UnsupportedOperationException();
    }

    @Transactional
    @Override
    public void deleteUnpublishedQuiz(Long quizId) {
        questionDao.deleteQuestionsByQuizId(quizId);
        template.update(DELETE_UNPUBLISHED_QUIZ, quizId);
        logger.info("Deleted quiz with quizId " + quizId);
    }

    private Quiz mapQuiz(ResultSet rs, int rowNum) throws SQLException {
        return new Quiz.QuizBuilder()
                .quizId(rs.getLong("quiz_id"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .explanation(rs.getString("explanation"))
                .creationDate(rs.getDate("creation_date").toLocalDate())
                .passingTime(Duration.between(LocalTime.MIDNIGHT,
                        rs.getTime("passing_time").toLocalTime()))
                .authorId(rs.getLong("author_id"))
                .teacherQuizStatus(TeacherQuizStatus
                        .valueOf(rs.getString("teacher_quiz_status")))
                .build();
    }

    private StudentPassedQuiz mapStudentPassedQuiz(ResultSet rs, int rowNum) throws SQLException {
        return new StudentPassedQuiz(rs.getString(1),
                userDao.findUserNameByUserId(rs.getLong(2)),
                rs.getInt(3),
                rs.getInt(4),
                rs.getInt(5),
                rs.getTimestamp(6).toLocalDateTime(),
                Duration.ofMinutes(rs.getLong(7)));
    }

    private static final String FIND_QUIZ_BY_QUIZ_ID =
    "SELECT * FROM QUIZZES WHERE QUIZ_ID = ?;";

    private static final String FIND_ALL_QUIZZES =
    "SELECT * FROM QUIZZES;";

    private static final String FIND_ALL_QUIZ_IDS =
    "SELECT QUIZ_ID FROM QUIZZES;";

    private static final String FIND_ALL_QUIZZES_BY_AUTHOR_ID =
    "SELECT * FROM QUIZZES WHERE AUTHOR_ID = ?;";

    private static final String FIND_ALL_QUIZ_IDS_BY_AUTHOR_ID =
    "SELECT QUIZ_ID FROM QUIZZES WHERE AUTHOR_ID = ?;";

    private static final String FIND_QUIZZES_BY_STUDENT_ID =
    "SELECT QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.DESCRIPTION, QUIZZES.EXPLANATION, " +
            "QUIZZES.CREATION_DATE, QUIZZES.PASSING_TIME, QUIZZES.AUTHOR_ID, QUIZZES.TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "WHERE J.USER_ID = ?;";

    private static final String FIND_ALL_CLOSED_QUIZ_IDS_BY_AUTHOR_ID =
    "SELECT QUIZ_ID FROM QUIZZES WHERE TEACHER_QUIZ_STATUS = 'CLOSED' AND AUTHOR_ID = ?;";

    private static final String FIND_ALL_NOT_PUBLISHED_QUIZ_IDS_BY_AUTHOR_ID =
    "SELECT QUIZ_ID FROM QUIZZES WHERE TEACHER_QUIZ_STATUS = 'UNPUBLISHED' AND AUTHOR_ID = ?;";

    private static final String FIND_ALL_QUIZ_IDS_BY_STUDENT_ID_AND_STUDENT_QUIZ_STATUS =
    "SELECT QUIZZES.QUIZ_ID " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND STUDENT_QUIZ_STATUS = ?;";

    private static final String FIND_QUIZZES_NUMBER_BY_AUTHOR_ID =
    "SELECT COUNT(QUIZ_ID) FROM QUIZZES WHERE AUTHOR_ID = ?;";

    private static final String
            FIND_STUDENTS_NUMBER_BY_AUTHOR_ID_AND_GROUP_ID_AND_QUIZ_ID_WITH_STUDENT_QUIZ_STATUS =
    "SELECT J.STUDENT_QUIZ_STATUS, COUNT(J.USER_ID) " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "INNER JOIN USERS ON J.USER_ID = USERS.USER_ID " +
    "WHERE AUTHOR_ID = ? AND USERS.GROUP_ID = ? AND QUIZZES.QUIZ_ID = ? " +
    "GROUP BY J.STUDENT_QUIZ_STATUS;";

    private static final String FIND_QUIZZES_NUMBER_BY_AUTHOR_ID_WITH_TEACHER_QUIZ_STATUS =
    "SELECT TEACHER_QUIZ_STATUS, COUNT(QUIZ_ID) " +
    "FROM QUIZZES WHERE AUTHOR_ID = ? GROUP BY TEACHER_QUIZ_STATUS;";

    private static final String FIND_ALL_STUDENT_RESULTS =
    "SELECT QUIZZES.QUIZ_ID, J.RESULT " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "WHERE J.USER_ID = ?;";

    private static final String FIND_QUIZ_IDS_BY_STUDENT_ID_AND_ATTEMPT =
    "SELECT QUIZZES.QUIZ_ID " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.ATTEMPT = ?;";

    private static final String FIND_QUIZZES_BY_STUDENT_ID_AND_AUTHOR_ID =
    "SELECT QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.DESCRIPTION, QUIZZES.EXPLANATION, " +
            "QUIZZES.CREATION_DATE, QUIZZES.PASSING_TIME, QUIZZES.AUTHOR_ID, QUIZZES.TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ?;";

    private static final String FIND_RESULT_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT RESULT FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String FIND_SUBMIT_DATE_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT SUBMIT_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String FIND_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT START_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String FIND_FINISH_DATE_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT FINISH_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String FIND_ATTEMPT_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT ATTEMPT FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String FIND_STUDENT_QUIZ_STATUS_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT STUDENT_QUIZ_STATUS FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String FIND_OPENED_QUIZZES_INFO_BY_STUDENT_ID =
    "SELECT QUIZZES.NAME, QUIZZES.AUTHOR_ID, " +
    "COUNT(QUESTIONS.QUESTION_ID), SUM(QUESTIONS.SCORE), J.SUBMIT_DATE " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.SUBMIT_DATE DESC;";

    private static final String FIND_PASSED_QUIZZES_INFO_BY_STUDENT_ID =
    "SELECT QUIZZES.NAME, QUIZZES.AUTHOR_ID, J.RESULT, " +
    "SUM(QUESTIONS.SCORE), J.ATTEMPT, J.FINISH_DATE, " +
    "DATEDIFF('MINUTE', J.START_DATE, J.FINISH_DATE) " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.FINISH_DATE DESC;";

    private static final String FIND_FINISHED_QUIZZES_INFO_BY_STUDENT_ID =
    "SELECT QUIZZES.NAME, QUIZZES.AUTHOR_ID, J.RESULT, " +
    "SUM(QUESTIONS.SCORE), J.ATTEMPT, J.FINISH_DATE, " +
    "DATEDIFF('MINUTE', J.START_DATE, J.FINISH_DATE) " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'FINISHED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.FINISH_DATE DESC;";

    private static final String ADD_QUIZ =
    "INSERT INTO QUIZZES (NAME, DESCRIPTION, EXPLANATION, CREATION_DATE, PASSING_TIME, AUTHOR_ID, TEACHER_QUIZ_STATUS) " +
    "VALUES (?, ?, ?, ?, ?, ?, ?);";

    private static final String EDIT_TEACHER_QUIZ_STATUS_BY_QUIZ_ID =
    "UPDATE QUIZZES SET TEACHER_QUIZ_STATUS = ? WHERE QUIZ_ID = ?;";

    private static final String EDIT_QUIZ =
    "UPDATE QUIZZES " +
    "SET NAME = ?, DESCRIPTION = ?, EXPLANATION = ?, CREATION_DATE = ?, PASSING_TIME = ?, AUTHOR_ID = ?, TEACHER_QUIZ_STATUS = ? " +
    "WHERE QUIZ_ID = ?;";

    private static final String DELETE_UNPUBLISHED_QUIZ =
    "DELETE FROM QUIZZES WHERE QUIZ_ID = ? AND TEACHER_QUIZ_STATUS = 'UNPUBLISHED';";
}