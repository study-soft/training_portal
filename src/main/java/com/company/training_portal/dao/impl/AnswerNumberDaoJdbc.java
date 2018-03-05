package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerNumberDao;
import com.company.training_portal.model.AnswerNumber;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

@Repository
public class AnswerNumberDaoJdbc implements AnswerNumberDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public AnswerNumberDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public AnswerNumber findAnswerNumberByQuestionId(Long questionId) {
        return null;
    }

    @Override
    public Long addAnswerNumber(AnswerNumber answerNumber) {
        return null;
    }

    @Override
    public void editAnswerNumber(AnswerNumber answerNumber) {

    }

    @Override
    public void deleteAnswerNumber(Long answerNumberId) {

    }
}
