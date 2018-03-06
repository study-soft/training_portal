package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerNumberDao;
import com.company.training_portal.model.AnswerNumber;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class AnswerNumberDaoJdbc implements AnswerNumberDao {

    private JdbcTemplate template;

    private static final Logger logger = Logger.getLogger(AnswerNumber.class);

    @Autowired
    public AnswerNumberDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Transactional(readOnly = true)
    @Override
    public AnswerNumber findAnswerNumberByQuestionId(Long questionId) {
        AnswerNumber answerNumber = template.queryForObject(FIND_ANSWER_NUMBER_BY_QUESTION_ID,
                new Object[]{questionId}, AnswerNumber.class);
        logger.info("Found answerNumber by questionId: " + answerNumber);
        return answerNumber;
    }

    @Transactional
    @Override
    public Long addAnswerNumber(AnswerNumber answerNumber) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_ANSWER_NUMBER,
                        new String[]{"answer_number_id"});
                stmt.setLong(1, answerNumber.getQuestionId());
                stmt.setInt(2, answerNumber.getCorrect());
                return stmt;
            }
        }, keyHolder);
        long answerNumberId = keyHolder.getKey().longValue();
        answerNumber.setAnswerNumberId(answerNumberId);
        logger.info("Added answerNumber: " + answerNumber);
        return answerNumberId;
    }

    @Transactional
    @Override
    public void editAnswerNumber(AnswerNumber answerNumber) {
        template.update(UPDATE_ANSWER_NUMBER,
                answerNumber.getQuestionId(),
                answerNumber.getCorrect(),
                answerNumber.getAnswerNumberId());
        logger.info("Edited answerNumber: " + answerNumber);
    }

    @Transactional
    @Override
    public void deleteAnswerNumber(Long answerNumberId) {
        template.update(DELETE_ANSWER_NUMBER, answerNumberId);
        logger.info("Deleted answerNumber with id: " + answerNumberId);
    }

    private AnswerNumber mapAnswerNumber(ResultSet rs, int rowNum) throws SQLException {
        return new AnswerNumber.AnswerNumberBuilder()
                .answerNumberId(rs.getLong("answer_number_id"))
                .questionId(rs.getLong("question_id"))
                .correct(rs.getInt("correct"))
                .build();
    }

    private static final String FIND_ANSWER_NUMBER_BY_QUESTION_ID =
    "SELECT * FROM ANSWERS_NUMBER WHERE QUESTION_ID = ?;";

    private static final String ADD_ANSWER_NUMBER =
    "INSERT INTO ANSWERS_NUMBER (QUESTION_ID, CORRECT) VALUES (?, ?);";

    private static final String UPDATE_ANSWER_NUMBER =
    "UPDATE ANSWERS_NUMBER SET QUESTION_ID = ?, CORRECT = ? WHERE ANSWER_NUMBER_ID = ?;";

    private static final String DELETE_ANSWER_NUMBER =
    "DELETE FROM ANSWERS_NUMBER WHERE ANSWER_NUMBER_ID = ?;";
}