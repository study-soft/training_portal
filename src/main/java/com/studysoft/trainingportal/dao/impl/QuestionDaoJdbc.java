package com.studysoft.trainingportal.dao.impl;

import com.studysoft.trainingportal.dao.*;
import com.studysoft.trainingportal.model.Question;
import com.studysoft.trainingportal.model.enums.QuestionType;
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

    private AnswerSimpleDao answerSimpleDao;
    private AnswerAccordanceDao answerAccordanceDao;
    private AnswerSequenceDao answerSequenceDao;
    private AnswerNumberDao answerNumberDao;

    private static final Logger logger = Logger.getLogger(QuestionDaoJdbc.class);

    @Autowired
    public QuestionDaoJdbc(DataSource dataSource,
                           AnswerSimpleDao answerSimpleDao,
                           AnswerAccordanceDao answerAccordanceDao,
                           AnswerSequenceDao answerSequenceDao,
                           AnswerNumberDao answerNumberDao) {
        template = new JdbcTemplate(dataSource);
        this.answerSimpleDao = answerSimpleDao;
        this.answerAccordanceDao = answerAccordanceDao;
        this.answerSequenceDao = answerSequenceDao;
        this.answerNumberDao = answerNumberDao;
    }

    @Transactional(readOnly = true)
    @Override
    public Question findQuestion(Long questionId) {
        Question question = template.queryForObject(FIND_QUESTION_BY_QUESTION_ID,
                new Object[]{questionId}, this::mapQuestion);
        logger.info("Question found by questionId: " + question);
        return question;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Question> findQuestions(Long quizId) {
        List<Question> questions = template.query(FIND_QUESTIONS_BY_QUIZ_ID,
                new Object[]{quizId}, this::mapQuestion);
        logger.info("Questions found by quizId:");
        questions.forEach(logger::info);
        return questions;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Question> findQuestions(Long quizId, QuestionType questionType) {
        List<Question> questions = template.query(FIND_QUESTIONS_BY_QUIZ_ID_AND_QUESTION_TYPE,
                new Object[]{quizId, questionType.getQuestionType()}, this::mapQuestion);
        logger.info("Questions found by quizId and questionType:");
        questions.forEach(logger::info);
        return questions;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<QuestionType, Integer> findQuestionTypesAndCount(Long quizId) {
        Map<QuestionType, Integer> questionTypes = template.query(
                FIND_QUESTION_TYPES_AND_COUNT_BY_QUIZ_ID, new Object[]{quizId},
                new ResultSetExtractor<Map<QuestionType, Integer>>() {
                    @Override
                    public Map<QuestionType, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        Map<QuestionType, Integer> questionTypes = new HashMap<>();
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
                stmt.setString(2, question.getBody());
                stmt.setString(3, question.getExplanation());
                stmt.setString(4, question.getQuestionType().getQuestionType());
                stmt.setInt(5, question.getScore());
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
        template.update(EDIT_QUESTION, question.getQuizId(), question.getBody(),
                question.getExplanation(), question.getQuestionType().getQuestionType(),
                question.getScore(), question.getQuestionId());
        logger.info("Edited question: " + question);
    }

    @Transactional
    @Override
    public void deleteQuestion(Long questionId) {
        Question question = findQuestion(questionId);
        switch (question.getQuestionType()) {
            case ONE_ANSWER:
                answerSimpleDao.deleteAnswersSimple(questionId);
                break;
            case FEW_ANSWERS:
                answerSimpleDao.deleteAnswersSimple(questionId);
                break;
            case ACCORDANCE:
                answerAccordanceDao.deleteAnswerAccordance(questionId);
                break;
            case SEQUENCE:
                answerSequenceDao.deleteAnswerSequence(questionId);
            case NUMBER:
                answerNumberDao.deleteAnswerNumber(questionId);
                break;
        }
        template.update(DELETE_QUESTION, questionId);
        logger.info("Deleted question with questionId: " + questionId);
    }

    @Transactional
    @Override
    public void deleteQuestions(Long quizId) {
        List<Question> questions = findQuestions(quizId);
        for (Question question : questions) {
            deleteQuestion(question.getQuestionId());
        }
//        template.update(DELETE_QUESTIONS_BY_QUIZ_ID, quizId);
        logger.info("Deleted questions with quizId: " + quizId);
    }

    private Question mapQuestion(ResultSet rs, int rowNum) throws SQLException {
        return new Question.QuestionBuilder()
                .questionId(rs.getLong("question_id"))
                .quizId(rs.getLong("quiz_id"))
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
    "INSERT INTO QUESTIONS (QUIZ_ID, BODY, EXPLANATION, QUESTION_TYPE, SCORE) " +
    "VALUES (?, ?, ?, ?, ?);";

    private static final String EDIT_QUESTION =
    "UPDATE QUESTIONS " +
    "SET QUIZ_ID = ?, BODY = ?, EXPLANATION = ?, QUESTION_TYPE = ?, SCORE = ? " +
    "WHERE QUESTION_ID = ?;";

    private static final String DELETE_QUESTION =
    "DELETE FROM QUESTIONS WHERE QUESTION_ID = ?;";

    private static final String DELETE_QUESTIONS_BY_QUIZ_ID =
    "DELETE FROM QUESTIONS WHERE QUIZ_ID = ?;";
}