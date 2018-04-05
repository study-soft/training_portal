package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.OpenedQuiz;
import com.company.training_portal.model.PassedQuiz;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
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

import static com.company.training_portal.model.enums.StudentQuizStatus.OPENED;
import static com.company.training_portal.util.Utils.durationToTimeUnits;

@Repository
public class QuizDaoJdbc implements QuizDao {

    private JdbcTemplate template;

    private QuestionDao questionDao;
    private UserDao userDao;
    private GroupDao groupDao;

    private static final Logger logger = Logger.getLogger(QuizDaoJdbc.class);

    @Autowired
    public QuizDaoJdbc(DataSource dataSource,
                       QuestionDao questionDao,
                       UserDao userDao,
                       GroupDao groupDao) {
        template = new JdbcTemplate(dataSource);
        this.questionDao = questionDao;
        this.userDao = userDao;
        this.groupDao = groupDao;
    }

    @Transactional(readOnly = true)
    @Override
    public Quiz findQuiz(Long quizId) {
        Quiz quiz = template.queryForObject(FIND_QUIZ_BY_QUIZ_ID,
                new Object[]{quizId}, this::mapQuiz);
        logger.info("Quiz found by quizId: " + quiz);
        return quiz;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findAllQuizzesWithQuestions() {
        List<Quiz> quizzes = template.query(FIND_ALL_QUIZZES_WITH_QUESTIONS, this::mapQuiz);
        logger.info("All quizzes found:");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findTeacherQuizIds(Long authorId) {
        List<Long> quizIds = template.queryForList(FIND_ALL_QUIZ_IDS_BY_AUTHOR_ID,
                new Object[]{authorId}, Long.class);
        logger.info("All quizIds by authorId found: " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findUnpublishedQuizzes(Long teacherId) {
        List<Quiz> quizzesWithQuestions = template.query(
                FIND_UNPUBLISHED_QUIZZES_WITH_QUESTIONS_BY_AUTHOR_ID,
                new Object[]{teacherId}, this::mapQuiz);
        List<Quiz> quizzesWithoutQuestions = template.query(
                FIND_UNPUBLISHED_QUIZZES_WITHOUT_QUESTIONS_BY_AUTHOR_ID,
                new Object[]{teacherId}, this::mapQuiz);
        quizzesWithQuestions.addAll(quizzesWithoutQuestions);
        logger.info("Found unpublished quizzes by teacherId '" + teacherId + "':");
        quizzesWithQuestions.forEach(logger::info);
        return quizzesWithQuestions;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findPublishedQuizzes(Long teacherId) {
        List<Quiz> quizzes = template.query(FIND_PUBLISHED_QUIZZES_BY_AUTHOR_ID,
                new Object[]{teacherId}, this::mapQuiz);
        logger.info("Found published quizzes by teacherId '" + teacherId + "':");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findPublishedQuizzes(Long groupId, Long teacherId) {
        List<Quiz> quizzes = template.query(FIND_PUBLISHED_QUIZZES_BY_GROUP_ID_AND_TEACHER_ID,
                new Object[]{groupId, teacherId}, this::mapQuiz);
        logger.info("Found quizzes by groupId '" + groupId + "':");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Quiz> findStudentQuizzes(Long studentId) {
        List<Quiz> quizzes = template.query(
                FIND_QUIZZES_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapQuiz);
        logger.info("Found quizzes by studentId:");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findQuizzesNumber(Long authorId) {
        Integer quizzesNumber = template.queryForObject(FIND_QUIZZES_NUMBER_BY_AUTHOR_ID,
                new Object[]{authorId}, Integer.class);
        logger.info("Quizzes number found: " + quizzesNumber);
        return quizzesNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<StudentQuizStatus, Integer> findStudentsNumberWithStudentQuizStatus(
            Long authorId, Long groupId, Long quizId) {
        Map<StudentQuizStatus, Integer> results = template.query(
                FIND_STUDENTS_NUMBER_BY_AUTHOR_ID_AND_GROUP_ID_AND_QUIZ_ID_WITH_STUDENT_QUIZ_STATUS,
                new Object[]{authorId, groupId, quizId},
                new ResultSetExtractor<Map<StudentQuizStatus, Integer>>() {
                    @Override
                    public Map<StudentQuizStatus, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        Map<StudentQuizStatus, Integer> results = new HashMap<>();
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
    public Map<TeacherQuizStatus, Integer> findQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId) {
        Map<TeacherQuizStatus, Integer> results = template.query(
                FIND_QUIZZES_NUMBER_BY_AUTHOR_ID_WITH_TEACHER_QUIZ_STATUS,
                new Object[]{authorId},
                new ResultSetExtractor<Map<TeacherQuizStatus, Integer>>() {
                    @Override
                    public Map<TeacherQuizStatus, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        Map<TeacherQuizStatus, Integer> results = new HashMap<>();
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
    public List<Quiz> findQuizzes(Long studentId, Long authorId) {
        List<Quiz> quizzes = template.query(
                FIND_QUIZZES_BY_STUDENT_ID_AND_AUTHOR_ID,
                new Object[]{studentId, authorId}, this::mapQuiz);
        logger.info("Found quizzes by studentId and authorId:");
        quizzes.forEach(logger::info);
        return quizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findCommonQuizIds(Long studentId1, Long studentId2) {
        List<Long> quizIds = template.queryForList(FIND_COMMON_QUIZ_IDS_FOR_TWO_STUDENTS,
                new Object[]{studentId1, studentId2}, Long.class);
        logger.info("Found common quizIds for students with id '" +
                studentId1 + "' and '" + studentId2 + "': " + quizIds);
        return quizIds;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findResult(Long studentId, Long quizId) {
        Integer result = template.queryForObject(FIND_RESULT_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, Integer.class);
        logger.info("Result by studentId and quizId found: " + result);
        return result;
    }

    @Transactional(readOnly = true)
    @Override
    public LocalDateTime findSubmitDate(Long studentId, Long quizId) {
        LocalDateTime submitDate = template.queryForObject(
                FIND_SUBMIT_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, LocalDateTime.class);
        logger.info("SubmitDate by studentId and quizId found: " + submitDate);
        return submitDate;
    }

    @Transactional(readOnly = true)
    @Override
    public LocalDateTime findStartDate(Long studentId, Long quizId) {
        LocalDateTime startDate = template.queryForObject(
                FIND_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, LocalDateTime.class);
        logger.info("StartDate by studentId and quizId found: " + startDate);
        return startDate;
    }

    @Transactional(readOnly = true)
    @Override
    public LocalDateTime findFinishDate(Long studentId, Long quizId) {
        LocalDateTime finishDate = template.queryForObject(
                FIND_FINISH_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, LocalDateTime.class);
        logger.info("FinishDate by studentId and quizId found: " + finishDate);
        return finishDate;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findAttempt(Long studentId, Long quizId) {
        Integer attempt = template.queryForObject(
                FIND_ATTEMPT_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, Integer.class);
        logger.info("Attempt by studentId and quizId found: " + attempt);
        return attempt;
    }

    @Transactional(readOnly = true)
    @Override
    public StudentQuizStatus findStudentQuizStatus(Long studentId, Long quizId) {
        StudentQuizStatus studentQuizStatus = StudentQuizStatus.valueOf(template.queryForObject(
                FIND_STUDENT_QUIZ_STATUS_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, String.class));
        logger.info("StudentQuizStatus by studentId and quizId found: " + studentQuizStatus);
        return studentQuizStatus;
    }

    @Transactional(readOnly = true)
    @Override
    public LocalDateTime findClosingDate(Long groupId, Long quizId) {
        LocalDateTime closingDate = template.queryForObject(FIND_CLOSING_DATE_BY_GROUP_ID_AND_QUIZ_ID,
                new Object[]{groupId, quizId}, LocalDateTime.class);
        logger.info("Found closing date by groupId '" + groupId + "' and quizId '" + quizId + "':");
        return closingDate;
    }

    @Transactional(readOnly = true)
    @Override
    public OpenedQuiz findOpenedQuiz(Long studentId, Long quizId) {
        OpenedQuiz openedQuiz = template.queryForObject(
                FIND_OPENED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, this::mapOpenedQuiz);
        logger.info("Found opened quiz by studentId and quizId: " + openedQuiz);
        return openedQuiz;
    }

    @Transactional(readOnly = true)
    @Override
    public PassedQuiz findPassedQuiz(Long studentId, Long quizId) {
        PassedQuiz passedQuiz = template.queryForObject(
                FIND_PASSED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, this::mapPassedQuiz);
        logger.info("Found passed quiz by studentId and quizId: " + passedQuiz);
        return passedQuiz;
    }

    @Transactional(readOnly = true)
    @Override
    public PassedQuiz findClosedQuiz(Long studentId, Long quizId) {
        PassedQuiz closedQuiz = template.queryForObject(
                FIND_CLOSED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID,
                new Object[]{studentId, quizId}, this::mapPassedQuiz);
        logger.info("Found closed quiz by studentId and quizId: " + closedQuiz);
        return closedQuiz;
    }

    @Transactional(readOnly = true)
    @Override
    public List<OpenedQuiz> findOpenedQuizzes(Long studentId) {
        List<OpenedQuiz> openedQuizzes = template.query(
                FIND_OPENED_QUIZZES_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapOpenedQuiz);
        logger.info("Found opened quizzes by studentId '" + studentId + "':");
        openedQuizzes.forEach(logger::info);
        return openedQuizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<PassedQuiz> findPassedQuizzes(Long studentId) {
        List<PassedQuiz> passedQuizzes = template.query(
                FIND_PASSED_QUIZZES_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapPassedQuiz);
        logger.info("Found passed quizzes by studentId '" + studentId + "':");
        passedQuizzes.forEach(logger::info);
        return passedQuizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<PassedQuiz> findClosedQuizzes(Long studentId) {
        List<PassedQuiz> closedQuizzes = template.query(
                FIND_CLOSED_QUIZZES_BY_STUDENT_ID,
                new Object[]{studentId}, this::mapPassedQuiz);
        logger.info("Found closed quizzes by studentId '" + studentId + "':");
        closedQuizzes.forEach(logger::info);
        return closedQuizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<OpenedQuiz> findOpenedQuizzes(Long studentId, Long teacherId) {
        List<OpenedQuiz> openedQuizzes = template.query(
                FIND_OPENED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID,
                new Object[]{studentId, teacherId}, this::mapOpenedQuiz);
        logger.info("Found opened quizzes by studentId '" + studentId +
                "' and teacherId '" + teacherId + "':");
        openedQuizzes.forEach(logger::info);
        return openedQuizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<PassedQuiz> findPassedQuizzes(Long studentId, Long teacherId) {
        List<PassedQuiz> passedQuizzes = template.query(
                FIND_PASSED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID,
                new Object[]{studentId, teacherId}, this::mapPassedQuiz);
        logger.info("Found passed quizzes by studentId '" + studentId +
                "' and teacherId '" + teacherId + "':");
        passedQuizzes.forEach(logger::info);
        return passedQuizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<PassedQuiz> findClosedQuizzes(Long studentId, Long teacherId) {
        List<PassedQuiz> closedQuizzes = template.query(
                FIND_CLOSED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID,
                new Object[]{studentId, teacherId}, this::mapPassedQuiz);
        logger.info("Found closed quizzes by studentId '" + studentId +
                "' and teacherId '" + teacherId + "':");
        closedQuizzes.forEach(logger::info);
        return closedQuizzes;
    }

    @Transactional(readOnly = true)
    @Override
    public boolean quizExistsByName(String name) {
        try {
            template.queryForObject(FIND_QUIZ_NAME_IF_EXISTS,
                    new Object[]{name}, String.class);
        } catch (EmptyResultDataAccessException e) {
            logger.info("No quiz exists by name: " + name);
            return false;
        }
        logger.info("Quiz exists by name: " + name);
        return true;
    }

    @Transactional
    @Override
    public void addPublishedQuizInfo(List<Long> studentIds, Long quizId) {
        LocalDateTime submitDate = LocalDateTime.now();

        List<Object[]> batchArgs = new ArrayList<>();
        for (Long studentId : studentIds) {
            batchArgs.add(new Object[]{studentId, quizId, Timestamp.valueOf(submitDate),
                    0, OPENED.getStudentQuizStatus()});
        }

        template.batchUpdate(ADD_PUBLISHED_QUIZ_INFO, batchArgs);
        logger.info("Added published quiz info:");
        for (Long studentId : studentIds) {
            logger.info("userId: " + studentId +
                    " quizId: " + quizId +
                    " submitDate: " + submitDate +
                    " attempt: 0" +
                    " studentQuizStatus: OPENED");
        }
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
                stmt.setTime(5, quiz.getPassingTime() == null ? null :
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
    public void editStartDate(LocalDateTime startDate, Long studentId, Long quizId) {
        template.update(EDIT_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID,
                startDate, studentId, quizId);
        logger.info("Edited startDate to '" + startDate +
                "' where studentId=" + studentId + ", quizId=" + quizId);
    }

    @Transactional
    @Override
    public void editStudentInfoAboutOpenedQuiz(Long studentId, Long quizId, Integer result,
                                               LocalDateTime finishDate, Integer attempt,
                                               StudentQuizStatus studentQuizStatus) {
        template.update(EDIT_STUDENT_INFO_ABOUT_OPENED_QUIZ,
                result, Timestamp.valueOf(finishDate),
                attempt, studentQuizStatus.getStudentQuizStatus(),
                studentId, quizId);
        logger.info("Edited student info about quiz by studentId = " +
                studentId + " and quizId = " + quizId + ": result: " + result +
        ", finishDate: " + finishDate + ", attempt: " + attempt +
                ", studentQuizStatus: " + studentQuizStatus);
    }

    @Transactional
    @Override
    public void editTeacherQuizStatus(TeacherQuizStatus teacherQuizStatus,
                                      Long quizId) {
        template.update(EDIT_TEACHER_QUIZ_STATUS_BY_QUIZ_ID,
                teacherQuizStatus.getTeacherQuizStatus(), quizId);
        logger.info("Edited teacher status to " + teacherQuizStatus +
                " in quiz with quizId " + quizId);
    }

    @Transactional
    @Override
    public void editQuiz(Long quizId, String name, String description,
                         String explanation, Duration passingTime) {
        List<Integer> timeUnits = durationToTimeUnits(passingTime);
        template.update(EDIT_QUIZ_BY_QUIZ_ID_NAME_DESCRIPTION_EXPLANATION_PASSING_TIME,
                name, description, explanation, timeUnits == null ? null :
                Time.valueOf(LocalTime.of(timeUnits.get(0), timeUnits.get(1), timeUnits.get(2))),
                quizId);
    }

    @Override
    public void editStudentsInfoWithOpenedQuizStatus(Long groupId, Long quizId) {
        LocalDateTime currentTime = LocalDateTime.now();
        template.update(EDIT_STUDENTS_INFO_WITH_OPENED_QUIZ_STATUS,
                currentTime, currentTime, groupId, quizId);
        logger.info("Edited students info with opened quiz status by groupId = " +
                groupId + " and quizId = " + quizId);
    }

    @Transactional
    @Override
    public void closeQuizToStudent(Long studentId, Long quizId) {
        template.update(CLOSE_QUIZ_TO_STUDENT, studentId, quizId);
        logger.info("Closed quiz by studentId = " + studentId + " and quizId = " + quizId);
    }

    @Override
    public void closeQuizToGroup(Long groupId, Long quizId) {
        template.update(CLOSE_QUIZ_TO_GROUP, groupId, quizId);
        logger.info("Closed quiz by groupId = " + groupId + " and quizId = " + quizId);
    }

    @Override
    public void closeQuizToAll(Long teacherId) {
        template.update(CLOSE_QUIZ_TO_ALL_BY_TEACHER_ID, teacherId);
        logger.info("Closed quiz to all by teacherId '" + teacherId + "'");
    }

    @Transactional
    @Override
    public void deleteUnpublishedQuiz(Long quizId) {
        questionDao.deleteQuestions(quizId);
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
                .passingTime(rs.getTime("passing_time") == null ? null :
                        Duration.between(LocalTime.MIDNIGHT,
                        rs.getTime("passing_time").toLocalTime()))
                .authorId(rs.getLong("author_id"))
                .score(rs.getInt("score"))
                .questionsNumber(rs.getInt("questions_number"))
                .teacherQuizStatus(TeacherQuizStatus
                        .valueOf(rs.getString("teacher_quiz_status")))
                .build();
    }

    private OpenedQuiz mapOpenedQuiz(ResultSet rs, int rowNum) throws SQLException {
        return new OpenedQuiz.OpenedQuizBuilder()
                .quizId(rs.getLong("quiz_id"))
                .quizName(rs.getString("quiz_name"))
                .description(rs.getString("description"))
                .passingTime(rs.getTime("passing_time") == null ? null :
                        Duration.between(LocalTime.MIDNIGHT,
                        rs.getTime("passing_time").toLocalTime()))
                .authorName(userDao.findUserName(rs.getLong("author_id")))
                .questionsNumber(rs.getInt("questions_number"))
                .score(rs.getInt("score"))
                .submitDate(rs.getTimestamp("submit_date").toLocalDateTime())
                .build();
    }

    private PassedQuiz mapPassedQuiz(ResultSet rs, int rowNum) throws SQLException {
        return new PassedQuiz.PassedQuizBuilder()
                .quizId(rs.getLong("quiz_id"))
                .quizName(rs.getString("quiz_name"))
                .description(rs.getString("description"))
                .explanation(rs.getString("explanation"))
                .authorName(userDao.findUserName(rs.getLong("author_id")))
                .result(rs.getInt("result"))
                .score(rs.getInt("score"))
                .questionsNumber(rs.getInt("questions_number"))
                .attempt(rs.getInt("attempt"))
                .passingTime(rs.getTime("passing_time") == null ? null :
                        Duration.between(LocalTime.MIDNIGHT,
                                rs.getTime("passing_time").toLocalTime()))
                .submitDate(rs.getTimestamp("submit_date").toLocalDateTime())
                .finishDate(rs.getTimestamp("finish_date").toLocalDateTime())
                .timeSpent(Duration.ofSeconds(rs.getLong("time_spent")))
                .build();
    }

    private static final String FIND_QUIZ_BY_QUIZ_ID =
    "SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "CASE WHEN EXISTS(SELECT * FROM QUESTIONS WHERE QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID) " +
    "THEN SUM(QUESTIONS.SCORE) ELSE 0 END AS SCORE, " +
    "CASE WHEN EXISTS(SELECT * FROM QUESTIONS WHERE QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID) " +
    "THEN COUNT(QUESTIONS.QUESTION_ID) ELSE 0 END AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES LEFT JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE QUIZZES.QUIZ_ID = ? " +
    "GROUP BY QUIZZES.QUIZ_ID;"; // Need group by for case when no quiz for such quizId

    private static final String FIND_QUIZ_NAME_IF_EXISTS =
    "SELECT NAME FROM QUIZZES WHERE QUIZZES.NAME = ?;";

    private static final String FIND_ALL_QUIZZES_WITH_QUESTIONS =
    "SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "GROUP BY QUIZZES.QUIZ_ID;";

    private static final String FIND_ALL_QUIZ_IDS_BY_AUTHOR_ID =
    "SELECT QUIZ_ID FROM QUIZZES WHERE AUTHOR_ID = ?;";

    private static final String FIND_UNPUBLISHED_QUIZZES_WITH_QUESTIONS_BY_AUTHOR_ID =
    "SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE QUIZZES.AUTHOR_ID = ? AND QUIZZES.TEACHER_QUIZ_STATUS = 'UNPUBLISHED' " +
    "GROUP BY QUIZZES.QUIZ_ID;";

    private static final String FIND_UNPUBLISHED_QUIZZES_WITHOUT_QUESTIONS_BY_AUTHOR_ID =
    "SELECT *, 0 AS SCORE, 0 AS QUESTIONS_NUMBER FROM QUIZZES " +
    "WHERE AUTHOR_ID = ? AND TEACHER_QUIZ_STATUS = 'UNPUBLISHED' " +
    "AND NOT EXISTS(SELECT QUESTION_ID FROM QUESTIONS WHERE QUESTIONS.QUIZ_ID = QUIZZES.QUIZ_ID);";

    private static final String FIND_PUBLISHED_QUIZZES_BY_AUTHOR_ID =
    "SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE QUIZZES.AUTHOR_ID = ? AND QUIZZES.TEACHER_QUIZ_STATUS = 'PUBLISHED' " +
    "GROUP BY QUIZZES.QUIZ_ID;";

    private static final String FIND_PUBLISHED_QUIZZES_BY_GROUP_ID_AND_TEACHER_ID =
    "SELECT DISTINCT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "INNER JOIN USERS ON J.USER_ID = USERS.USER_ID " +
    "WHERE USERS.GROUP_ID = ? AND QUIZZES.AUTHOR_ID = ? " +
    "GROUP BY USERS.USER_ID, QUIZZES.QUIZ_ID " +
    "ORDER BY QUIZZES.NAME;";

    private static final String FIND_QUIZZES_BY_STUDENT_ID =
    "SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? " +
    "GROUP BY QUIZZES.QUIZ_ID;";

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

    private static final String FIND_QUIZZES_BY_STUDENT_ID_AND_AUTHOR_ID =
    "SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS NAME, QUIZZES.DESCRIPTION AS DESCRIPTION, " +
    "QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE, " +
    "QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID, " +
    "SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER, " +
    "QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS " +
    "FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? " +
    "GROUP BY QUIZZES.QUIZ_ID;";

    private static final String FIND_COMMON_QUIZ_IDS_FOR_TWO_STUDENTS =
    "SELECT QUIZZES_1.QUIZ_ID " +
    "FROM QUIZZES QUIZZES_1 INNER JOIN USER_QUIZ_JUNCTIONS J_1 ON QUIZZES_1.QUIZ_ID = J_1.QUIZ_ID, " +
    "QUIZZES QUIZZES_2 INNER JOIN USER_QUIZ_JUNCTIONS J_2 ON QUIZZES_2.QUIZ_ID = J_2.QUIZ_ID " +
    "WHERE J_1.USER_ID = ? AND J_2.USER_ID = ? AND QUIZZES_1.QUIZ_ID = QUIZZES_2.QUIZ_ID;";

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

    private static final String FIND_CLOSING_DATE_BY_GROUP_ID_AND_QUIZ_ID =
    "SELECT MAX(J.FINISH_DATE) " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "WHERE USERS.GROUP_ID = ? AND J.QUIZ_ID = ?;";

    private static final String FIND_OPENED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.PASSING_TIME AS passing_time, QUIZZES.AUTHOR_ID AS author_id, " +
    "COUNT(QUESTIONS.QUESTION_ID) AS questions_number, SUM(QUESTIONS.SCORE) AS score, " +
    "J.SUBMIT_DATE AS submit_date " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED' " +
    "GROUP BY QUIZZES.QUIZ_ID;"; // Need group by for case when no quiz for such quizId

    private static final String FIND_PASSED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id, " +
    "J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number, " +
    "J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date, " +
    "J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED';";

    private static final String FIND_CLOSED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id, " +
    "J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number, " +
    "J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date, " +
    "J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'CLOSED';";

    private static final String FIND_OPENED_QUIZZES_BY_STUDENT_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.PASSING_TIME AS passing_time, QUIZZES.AUTHOR_ID AS author_id, " +
    "COUNT(QUESTIONS.QUESTION_ID) AS questions_number, SUM(QUESTIONS.SCORE) AS score, " +
    "J.SUBMIT_DATE AS submit_date " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.SUBMIT_DATE DESC;";

    private static final String FIND_PASSED_QUIZZES_BY_STUDENT_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id, " +
    "J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number, " +
    "J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date, " +
    "J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.FINISH_DATE DESC;";

    private static final String FIND_CLOSED_QUIZZES_BY_STUDENT_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id, " +
    "J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number, " +
    "J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date, " +
    "J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'CLOSED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.FINISH_DATE DESC;";

    private static final String FIND_OPENED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.PASSING_TIME AS passing_time, QUIZZES.AUTHOR_ID AS author_id, " +
    "COUNT(QUESTIONS.QUESTION_ID) AS questions_number, SUM(QUESTIONS.SCORE) AS score, " +
    "J.SUBMIT_DATE AS submit_date " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.SUBMIT_DATE DESC;";

    private static final String FIND_PASSED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id, " +
    "J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number, " +
    "J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date, " +
    "J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent " +
    " FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.FINISH_DATE DESC;";

    private static final String FIND_CLOSED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID =
    "SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description, " +
    "QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id, " +
    "J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number, " +
    "J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date, " +
    "J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent " +
    "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID " +
    "WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? AND J.STUDENT_QUIZ_STATUS = 'CLOSED' " +
    "GROUP BY QUIZZES.NAME " +
    "ORDER BY J.FINISH_DATE DESC;";

    private static final String ADD_PUBLISHED_QUIZ_INFO =
    "INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, SUBMIT_DATE, ATTEMPT, STUDENT_QUIZ_STATUS) " +
    "VALUES (?, ?, ?, ?, ?);";

    private static final String ADD_QUIZ =
    "INSERT INTO QUIZZES (NAME, DESCRIPTION, EXPLANATION, CREATION_DATE, PASSING_TIME, AUTHOR_ID, TEACHER_QUIZ_STATUS) " +
    "VALUES (?, ?, ?, ?, ?, ?, ?);";

    private static final String EDIT_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID =
    "UPDATE USER_QUIZ_JUNCTIONS SET START_DATE = ? WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String EDIT_STUDENT_INFO_ABOUT_OPENED_QUIZ =
    "UPDATE USER_QUIZ_JUNCTIONS " +
    "SET RESULT = ?, FINISH_DATE = ?, ATTEMPT = ?, STUDENT_QUIZ_STATUS = ? " +
    "WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String EDIT_TEACHER_QUIZ_STATUS_BY_QUIZ_ID =
    "UPDATE QUIZZES SET TEACHER_QUIZ_STATUS = ? WHERE QUIZ_ID = ?;";

    private static final String EDIT_QUIZ_BY_QUIZ_ID_NAME_DESCRIPTION_EXPLANATION_PASSING_TIME =
    "UPDATE QUIZZES " +
    "SET NAME = ?, DESCRIPTION = ?, EXPLANATION = ?, PASSING_TIME = ? " +
    "WHERE QUIZ_ID = ?;";

    private static final String EDIT_STUDENTS_INFO_WITH_OPENED_QUIZ_STATUS =
    "UPDATE USER_QUIZ_JUNCTIONS " +
    "SET RESULT = 0, START_DATE = ?, FINISH_DATE = ?, ATTEMPT = 0, STUDENT_QUIZ_STATUS = 'CLOSED' " +
    "WHERE USER_ID IN (SELECT USERS.USER_ID " +
            "FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
            "WHERE GROUP_ID = ?) " +
    "AND QUIZ_ID = ? AND STUDENT_QUIZ_STATUS = 'OPENED';";

    private static final String CLOSE_QUIZ_TO_STUDENT =
    "UPDATE USER_QUIZ_JUNCTIONS " +
    "SET STUDENT_QUIZ_STATUS = 'CLOSED' " +
    "WHERE USER_ID = ? AND QUIZ_ID = ?;";

    private static final String CLOSE_QUIZ_TO_GROUP =
    "UPDATE USER_QUIZ_JUNCTIONS " +
    "SET STUDENT_QUIZ_STATUS = 'CLOSED' " +
    "WHERE USER_ID IN (SELECT USER_ID FROM USERS WHERE GROUP_ID = ?) AND QUIZ_ID = ? " +
    "AND STUDENT_QUIZ_STATUS IN ('OPENED', 'PASSED');";

    private static final String CLOSE_QUIZ_TO_ALL_BY_TEACHER_ID =
    "UPDATE USER_QUIZ_JUNCTIONS J " +
    "SET STUDENT_QUIZ_STATUS = 'CLOSED' " +
    "WHERE J.QUIZ_ID IN (SELECT QUIZ_ID FROM QUIZZES WHERE AUTHOR_ID = ?) " +
    "AND STUDENT_QUIZ_STATUS IN ('OPENED', 'PASSED');";

    private static final String DELETE_UNPUBLISHED_QUIZ =
    "DELETE FROM QUIZZES WHERE QUIZ_ID = ? AND TEACHER_QUIZ_STATUS = 'UNPUBLISHED';";
}