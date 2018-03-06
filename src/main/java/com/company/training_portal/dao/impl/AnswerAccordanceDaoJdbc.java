package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerAccordanceDao;
import com.company.training_portal.model.AnswerAccordance;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

@Repository
public class AnswerAccordanceDaoJdbc implements AnswerAccordanceDao {

    private JdbcTemplate template;

    private static final Logger logger = Logger.getLogger(AnswerAccordanceDaoJdbc.class);

    @Autowired
    public AnswerAccordanceDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Override
    public AnswerAccordance findAnswerAccordanceByQuestionId(Long questionId) {
        AnswerAccordance answerAccordance = template.queryForObject(FIND_ANSWER_ACCORDANCE_BY_QUESTION_ID,
                new Object[]{questionId}, AnswerAccordance.class);
        logger.info("Found answerAccordance by questionId: " + answerAccordance);
        return answerAccordance;
    }

    @Override
    public Long addAnswerAccordance(AnswerAccordance answerAccordance) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_ANSWER_ACCORDANCE_QUESTION_ID,
                        new String[]{"answer_accordance_id"});
                stmt.setLong(1, answerAccordance.getQuestionId());
                return stmt;
            }
        }, keyHolder);
        long answerAccordanceId = keyHolder.getKey().longValue();
        answerAccordance.setAnswerAccordanceId(answerAccordanceId);
        for (Map.Entry<String, String> entry : answerAccordance.getCorrectMap().entrySet()) {
            template.update(ADD_ANSWER_ACCORDANCE_CORRECT_MAP_ENTRY,
                    entry.getKey(), entry.getValue(), answerAccordanceId);
        }
        logger.info("Added answerAccordance: " + answerAccordance);
        return answerAccordanceId;
    }

    @Override
    public void editAnswerAccordance(AnswerAccordance answerAccordance) {
        template.update(EDIT_ANSWER_ACCORDANCE_QUESTION_ID,
                answerAccordance.getQuestionId(),
                answerAccordance.getAnswerAccordanceId());
        for (Map.Entry<String, String> entry : answerAccordance.getCorrectMap().entrySet()) {
            template.update(EDIT_ANSWER_ACCORDANCE_CORRECT_MAP_ENTRY,
                    entry.getKey(), entry.getValue(), answerAccordance.getAnswerAccordanceId());
        }
    }

    @Override
    public void deleteAnswerAccordance(Long answerAccordanceId) {

    }

    private static final String FIND_ANSWER_ACCORDANCE_BY_QUESTION_ID =
    "SELECT AA.ANSWER_ACCORDANCE_ID, AA.QUESTION_ID, CM.LEFT_SIDE, CM.RIGHT_SIDE " +
    "FROM ANSWERS_ACCORDANCE AA INNER JOIN CORRECT_MAPS CM " +
    "ON AA.ANSWER_ACCORDANCE_ID = CM.ANSWER_ACCORDANCE_ID " +
    "WHERE AA.QUESTION_ID = ?;";

    private static final String ADD_ANSWER_ACCORDANCE_QUESTION_ID =
    "INSERT INTO ANSWERS_ACCORDANCE (QUESTION_ID) VALUES (?);";

    private static final String ADD_ANSWER_ACCORDANCE_CORRECT_MAP_ENTRY =
    "INSERT INTO CORRECT_MAPS (LEFT_SIDE, RIGHT_SIDE, ANSWER_ACCORDANCE_ID) VALUES (?, ?, ?);";

    private static final String EDIT_ANSWER_ACCORDANCE_QUESTION_ID =
    "UPDATE ANSWERS_ACCORDANCE SET QUESTION_ID = ? WHERE ANSWER_ACCORDANCE_ID = ?;";

    private static final String EDIT_ANSWER_ACCORDANCE_CORRECT_MAP_ENTRY =
    "UPDATE CORRECT_MAPS SET LEFT_SIDE = ?, RIGHT_SIDE = ?, ANSWER_ACCORDANCE_ID = ? " +
    "WHERE CORRECT_MAP_ID = ?;";

    private static final String DELETE_ANSWER_ACCORDANCE_QUESTION_ID =
    "DELETE FROM ANSWERS_ACCORDANCE WHERE ANSWER_ACCORDANCE_ID = ?;";

    private static final String DELETE_ANSWER_ACCORDANCE_CORRECT_MAP =
    "DELETE FROM CORRECT_MAPS WHERE ANSWER_ACCORDANCE_ID = ?;";
}
