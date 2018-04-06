package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerSimpleDao;
import com.company.training_portal.model.AnswerNumber;
import com.company.training_portal.model.AnswerSimple;
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
import java.util.List;

@Repository
public class AnswerSimpleDaoJdbc implements AnswerSimpleDao {

    private JdbcTemplate template;

    private static final Logger logger = Logger.getLogger(AnswerSimpleDaoJdbc.class);

    @Autowired
    public AnswerSimpleDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Transactional(readOnly = true)
    @Override
    public AnswerSimple findAnswerSimple(Long answerSimpleId) {
        AnswerSimple answerSimple = template.queryForObject(FIND_ANSWER_SIMPLE_BY_ANSWER_SIMPLE_ID,
                new Object[]{answerSimpleId}, this::mapAnswerSimple);
        logger.info("Found answerSimple by answerSimpleId: " + answerSimple);
        return answerSimple;
    }

    @Transactional(readOnly = true)
    @Override
    public List<AnswerSimple> findAnswersSimple(Long questionId) {
        List<AnswerSimple> answers = template.query(FIND_ALL_ANSWERS_SIMPLE_BY_QUESTION_ID,
                new Object[]{questionId}, this::mapAnswerSimple);
        logger.info("Found all answers simple by questionId:");
        answers.forEach(logger::info);
        return answers;
    }

    @Transactional
    @Override
    public Long addAnswerSimple(AnswerSimple answerSimple) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_ANSWER_SIMPLE,
                        new String[]{"answer_simple_id"});
                stmt.setLong(1, answerSimple.getQuestionId());
                stmt.setString(2, answerSimple.getBody());
                stmt.setBoolean(3, answerSimple.isCorrect());
                return stmt;
            }
        }, keyHolder);
        long answerSimpleId = keyHolder.getKey().longValue();
        answerSimple.setAnswerSimpleId(answerSimpleId);
        logger.info("Added answerSimple: " + answerSimple);
        return answerSimpleId;
    }

    @Transactional
    @Override
    public void editAnswerSimple(AnswerSimple answerSimple) {
        template.update(EDIT_ANSWER_SIMPLE,
                answerSimple.getQuestionId(),
                answerSimple.getBody(),
                answerSimple.isCorrect(),
                answerSimple.getAnswerSimpleId());
        logger.info("Edited answerSimple: " + answerSimple);
    }

    @Override
    public void deleteAnswersSimple(Long questionId) {
        template.update(DELETE_ANSWERS_SIMPLE_BY_QUESTION_ID, questionId);
        logger.info("Deleted answersSimple with questionId: " + questionId);
    }

    private AnswerSimple mapAnswerSimple(ResultSet rs, int rowNum) throws SQLException {
        return new AnswerSimple.AnswerSimpleBuilder()
                .answerSimpleId(rs.getLong("answer_simple_id"))
                .questionId(rs.getLong("question_id"))
                .body(rs.getString("body"))
                .correct(rs.getBoolean("correct"))
                .build();
    }

    private static final String FIND_ANSWER_SIMPLE_BY_ANSWER_SIMPLE_ID =
    "SELECT * FROM ANSWERS_SIMPLE WHERE ANSWER_SIMPLE_ID = ?;";

    private static final String FIND_ALL_ANSWERS_SIMPLE_BY_QUESTION_ID =
    "SELECT * FROM ANSWERS_SIMPLE WHERE QUESTION_ID = ?;";

    private static final String ADD_ANSWER_SIMPLE =
    "INSERT INTO ANSWERS_SIMPLE (QUESTION_ID, BODY, CORRECT) VALUES (?, ?, ?);";

    private static final String EDIT_ANSWER_SIMPLE =
    "UPDATE ANSWERS_SIMPLE SET QUESTION_ID = ?, BODY = ?, CORRECT = ? WHERE ANSWER_SIMPLE_ID = ?;";

    private static final String DELETE_ANSWERS_SIMPLE_BY_QUESTION_ID =
    "DELETE FROM ANSWERS_SIMPLE WHERE QUESTION_ID = ?;";
}