package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class QuestionDaoJdbc implements QuestionDao {

    private JdbcTemplate template;

    private static final Logger logger = Logger.getLogger(QuestionDaoJdbc.class);

    @Autowired
    public QuestionDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Transactional(readOnly = true)
    @Override
    public Question findQuestionByQuestionId(Long questionId) {
        Question question = template.queryForObject(FIND_QUESTION_BY_QUESTION_ID,
                new Object[]{questionId}, Question.class);
        logger.info("Question found by questionId: " + question);
        return question;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Question> findQuestionsByQuizId(Long quizId) {
        List<Question> questions = template.query(FIND_QUESTIONS_BY_QUIZ_ID,
                new Object[]{quizId}, this::mapQuestion);
        logger.info("Questions found by quizId:");
        questions.forEach(logger::info);
        return questions;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Question> findQuestionsByQuizIdAndQuestionType(Long quizId,
                                                               QuestionType questionType) {
        List<Question> questions = template.query(FIND_QUESTIONS_BY_QUIZ_ID_AND_QUESTION_TYPE,
                new Object[]{quizId, questionType.getQuestionType()}, this::mapQuestion);
        logger.info("Questions found by quizId and questionType:");
        questions.forEach(logger::info);
        return questions;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<QuestionType, Integer> findQuestionTypesAndCountByQuizId(Long quizId) {
        Map<QuestionType, Integer> questionTypes = new HashMap<>();
        template.query(FIND_QUESTION_TYPES_AND_COUNT_BY_QUIZ_ID,
                new ResultSetExtractor<Map<QuestionType, Integer>>() {
                    @Override
                    public Map<QuestionType, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        while (rs.next()) {
                            questionTypes.put(QuestionType.valueOf(rs.getString(1)),
                                    rs.getInt(2));
                        }
                        return questionTypes;
                    }
                });
        logger.info("Found question types and their count by quizId:");
        questionTypes.forEach((questionType, count) -> logger.info(questionType + ": " + count));
        return questionTypes;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Question> findQuestionsByQuizIdAndScore(Long quizId, Integer score) {
        List<Question> questions = template.query(FIND_QUESTIONS_BY_QUIZ_ID_AND_SCORE,
                new Object[]{quizId, score}, this::mapQuestion);
        logger.info("Questions found by quizId and score:");
        questions.forEach(logger::info);
        return questions;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findQuestionsNumberByQuizId(Long quizId) {
        Integer questionsNumber = template.queryForObject(FIND_QUESTIONS_NUMBER_BY_QUIZ_ID,
                new Object[]{quizId}, Integer.class);
        logger.info("Found questions number: " + questionsNumber);
        return questionsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findQuizScoreByQuizId(Long quizId) {
        Integer score = template.queryForObject(FIND_QUIZ_SCORE_BY_QUIZ_ID,
                new Object[]{quizId}, Integer.class);
        logger.info("Found quiz score by quizId: " + score);
        return score;
    }

    @Transactional
    @Override
    public Long addQuestion(Question question) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_QUESTION,
                        new String[]{"question_id"});
                stmt.setLong(1, question.getQuizId());
                stmt.setString(2, question.getName());
                stmt.setString(3, question.getBody());
                stmt.setString(4, question.getExplanation());
                stmt.setString(5, question.getQuestionType().getQuestionType());
                stmt.setInt(6, question.getScore());
                return stmt;
            }
        }, keyHolder);
        Long questionId = keyHolder.getKey().longValue();
        question.setQuestionId(questionId);
        logger.info("Added question: " + question);
        return questionId;
    }

    @Override
    public void editQuestion(Question question) {
        throw new UnsupportedOperationException();
    }

    @Transactional
    @Override
    public void deleteQuestion(Long questionId) {
        template.update(DELETE_QUESTION, questionId);
        logger.info("Deleted question with id: " + questionId);
    }

    private Question mapQuestion(ResultSet rs, int rowNum) throws SQLException {
        return new Question.QuestionBuilder()
                .questionId(rs.getLong("question_id"))
                .quizId(rs.getLong("quiz_id"))
                .name(rs.getString("name"))
                .body(rs.getString("body"))
                .explanation(rs.getString("explanation"))
                .questionType(QuestionType.valueOf(rs.getString("question_type")))
                .score(rs.getInt("score"))
                .build();
    }

    private static final String FIND_QUESTION_BY_QUESTION_ID =
    "SELECT * FROM QUESTIONS WHERE QUESTION_ID = ?;";

    private static final String FIND_QUESTIONS_BY_QUIZ_ID =
    "SELECT * FROM QUESTIONS WHERE QUIZ_ID = ?;";

    private static final String FIND_QUESTIONS_BY_QUIZ_ID_AND_QUESTION_TYPE =
    "SELECT * FROM QUESTIONS WHERE QUIZ_ID = ? AND QUESTION_TYPE = ?;";

    private static final String FIND_QUESTION_TYPES_AND_COUNT_BY_QUIZ_ID =
    "SELECT QUESTION_TYPE, COUNT(QUESTION_ID) " +
    "FROM QUESTIONS WHERE QUIZ_ID = ? " +
    "GROUP BY QUESTION_TYPE;";

    private static final String FIND_QUESTIONS_BY_QUIZ_ID_AND_SCORE =
    "SELECT * FROM QUESTIONS WHERE QUIZ_ID = ? AND SCORE = ?;";

    private static final String FIND_QUESTIONS_NUMBER_BY_QUIZ_ID =
    "SELECT COUNT(QUESTION_ID) FROM QUESTIONS WHERE QUIZ_ID = ?;";

    private static final String FIND_QUIZ_SCORE_BY_QUIZ_ID =
    "SELECT SUM(SCORE) FROM QUESTIONS WHERE QUIZ_ID = ?;";

    private static final String ADD_QUESTION =
    "INSERT INTO QUESTIONS (QUIZ_ID, NAME, BODY, EXPLANATION, QUESTION_TYPE, SCORE) " +
    "VALUES (?, ?, ?, ?, ?, ?);";

    private static final String DELETE_QUESTION =
    "DELETE FROM QUESTIONS WHERE QUESTION_ID = ?;";
}