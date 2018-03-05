package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerAccordance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

@Repository
public class AnswerAccordanceDaoJdbc implements AnswerAccordance {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public AnswerAccordanceDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public AnswerAccordance findAnswerAccordanceByQuestionId(Long quizId) {
        return null;
    }

    @Override
    public Long addAnswerAccordance(AnswerAccordance answerAccordance) {
        return null;
    }

    @Override
    public void editAnswerAccordance(AnswerAccordance answerAccordance) {

    }

    @Override
    public void deleteAnswerAccordance(Long answerAccordanceId) {

    }
}
