package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerSequenceDao;
import com.company.training_portal.model.AnswerSequence;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class AnswerSequenceDaoJdbc implements AnswerSequenceDao {

    private JdbcTemplate template;

    private static final Logger logger = Logger.getLogger(AnswerSequenceDaoJdbc.class);

    @Autowired
    public AnswerSequenceDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Transactional(readOnly = true)
    @Override
    public AnswerSequence findAnswerSequenceByQuestionId(Long questionId) {
        AnswerSequence answerSequence = template.queryForObject(FIND_ANSWER_SEQUENCE_BY_QUESTION_ID,
                this::mapAnswerSequence, questionId);
        logger.info("Found answerSequence by questionId: " + answerSequence);
        return answerSequence;
    }

    @Transactional
    @Override
    public void addAnswerSequence(AnswerSequence answerSequence) {
        List<String> correctList = answerSequence.getCorrectList();
        template.update(ADD_ANSWER_SEQUENCE, answerSequence.getQuestionId(),
        correctList.get(0), correctList.get(1), correctList.get(2), correctList.get(3));
        logger.info("Added answerSequence: " + answerSequence);
    }

    @Transactional
    @Override
    public void editAnswerSequence(AnswerSequence answerSequence) {
        List<String> correctList = answerSequence.getCorrectList();
        template.update(EDIT_ANSWER_SEQUENCE,
                correctList.get(0),
                correctList.get(1),
                correctList.get(2),
                correctList.get(3),
                answerSequence.getQuestionId());
        logger.info("Edited answerSequence: " + answerSequence);
    }

    @Transactional
    @Override
    public void deleteAnswerSequence(Long questionId) {
        template.update(DELETE_ANSWER_SEQUENCE, questionId);
        logger.info("Deleted answerSequence with questionId: " + questionId);
    }

    private AnswerSequence mapAnswerSequence(ResultSet rs, int rowNum) throws SQLException {
        List<String> correctList = new ArrayList<>();
        correctList.add(rs.getString("item_1"));
        correctList.add(rs.getString("item_2"));
        correctList.add(rs.getString("item_3"));
        correctList.add(rs.getString("item_4"));

        return new AnswerSequence.AnswerSequenceBuilder()
                .answerSequenceId(rs.getLong("answer_sequence_id"))
                .questionId(rs.getLong("question_id"))
                .correctList(correctList)
                .build();
    }

    private static final String FIND_ANSWER_SEQUENCE_BY_QUESTION_ID =
    "SELECT * FROM ANSWERS_SEQUENCE WHERE QUESTION_ID = ?;";

    private static final String ADD_ANSWER_SEQUENCE =
    "INSERT INTO ANSWERS_SEQUENCE (question_id, item_1, item_2, item_3, item_4) " +
    "VALUES (?, ?, ?, ?, ?);";

    private static final String EDIT_ANSWER_SEQUENCE =
    "UPDATE ANSWERS_SEQUENCE " +
    "SET ITEM_1 = ?, ITEM_2 = ?, ITEM_3 = ?, ITEM_4 = ? " +
    "WHERE QUESTION_ID = ?;";

    private static final String DELETE_ANSWER_SEQUENCE =
    "DELETE FROM ANSWERS_SEQUENCE WHERE QUESTION_ID = ?;";
}