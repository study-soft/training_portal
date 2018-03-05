package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerSequenceDao;
import com.company.training_portal.model.AnswerSequence;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

@Repository
public class AnswerSequenceDaoJdbc implements AnswerSequenceDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public AnswerSequenceDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public AnswerSequence findAnswerSequenceByQuestionId(Long questionId) {
        return null;
    }

    @Override
    public Long addAnswerSequence(AnswerSequence answerSequence) {
        return null;
    }

    @Override
    public void editAnswerSequence(AnswerSequence answerSequence) {

    }

    @Override
    public void deleteAnswerSequnce(Long answerSequenceId) {

    }
}
