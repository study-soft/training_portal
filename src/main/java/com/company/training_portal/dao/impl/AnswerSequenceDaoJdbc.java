package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerSequenceDao;
import com.company.training_portal.model.AnswerSequence;
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
import java.sql.SQLException;

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
        AnswerSequence answerSequence = template.queryForObject(
                FIND_ANSWER_SEQUENCE_BY_QUESTION_ID,
                new Object[]{questionId}, AnswerSequence.class);
        logger.info("Found answerSequence by questionId: " + answerSequence);
        return answerSequence;
    }

    @Transactional
    @Override
    public Long addAnswerSequence(AnswerSequence answerSequence) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_ANSWER_SEQUENCE_QUESTION_ID,
                        new String[]{"answer_sequence_id"});
                stmt.setLong(1, answerSequence.getQuestionId());
                return stmt;
            }
        }, keyHolder);
        long answerSequenceId = keyHolder.getKey().longValue();
        answerSequence.setAnswerSequenceId(answerSequenceId);
        for (String item : answerSequence.getCorrectList()) {
            template.update(ADD_ANSWER_SEQUENCE_CORRECT_LIST_ITEM, item, answerSequenceId);
        }
        logger.info("Added answerSequence: " + answerSequence);
        return answerSequenceId;
    }

    @Transactional
    @Override
    public void editAnswerSequence(AnswerSequence answerSequence) {
        template.update(EDIT_ANSWER_SEQUENCE_QUESTION_ID,
                answerSequence.getQuestionId(),
                answerSequence.getAnswerSequenceId());
        for (String item : answerSequence.getCorrectList()) {
            template.update(EDIT_ANSWER_SEQUENCE_CORRECT_LIST_ITEM,
                    answerSequence.getAnswerSequenceId(), item
                    );
        }
        logger.info("Edited answerSequence: " + answerSequence);
    }

    @Override
    public void deleteAnswerSequence(Long answerSequenceId) {
        template.update(DELETE_ANSWER_SEQUENCE, answerSequenceId);
        template.update(DELETE_ANSWER_SEQUENCE_CORRECT_LIST, answerSequenceId);
        logger.info("Deleted answerSequence with id: " + answerSequenceId);
    }

    private static final String FIND_ANSWER_SEQUENCE_BY_QUESTION_ID =
    "SELECT SEQ.ANSWER_SEQUENCE_ID, SEQ.QUESTION_ID, CORRECT_LISTS.ITEM " +
    "FROM CORRECT_LISTS INNER JOIN ANSWERS_SEQUENCE SEQ " +
    "ON CORRECT_LISTS.ANSWER_SEQUENCE_ID = SEQ.ANSWER_SEQUENCE_ID " +
    "WHERE SEQ.QUESTION_ID = ?;";

    private static final String ADD_ANSWER_SEQUENCE_QUESTION_ID =
    "INSERT INTO ANSWERS_SEQUENCE (QUESTION_ID) VALUES (?);";

    private static final String ADD_ANSWER_SEQUENCE_CORRECT_LIST_ITEM =
    "INSERT INTO CORRECT_LISTS (ITEM, ANSWER_SEQUENCE_ID) VALUES (?, ?);";

    private static final String EDIT_ANSWER_SEQUENCE_QUESTION_ID =
    "UPDATE ANSWERS_SEQUENCE SET QUESTION_ID = ? WHERE ANSWER_SEQUENCE_ID = ?;";

    private static final String EDIT_ANSWER_SEQUENCE_CORRECT_LIST_ITEM =
    "UPDATE CORRECT_LISTS SET ANSWER_SEQUENCE_ID = ?, ITEM = ? WHERE CORRECT_LIST_ID = ?;";

    private static final String FIND_CORRECT_LIST_ID_BY_ANSWER_SEQUENCE_ID =
    "SELECT CORRECT_LIST_ID FROM CORRECT_LISTS WHERE ANSWER_SEQUENCE_ID = ?;";

    private static final String DELETE_ANSWER_SEQUENCE =
    "DELETE FROM ANSWERS_SEQUENCE WHERE ANSWER_SEQUENCE_ID = ?;";

    private static final String DELETE_ANSWER_SEQUENCE_CORRECT_LIST =
    "DELETE FROM CORRECT_LISTS WHERE ANSWER_SEQUENCE_ID = ?;";
}