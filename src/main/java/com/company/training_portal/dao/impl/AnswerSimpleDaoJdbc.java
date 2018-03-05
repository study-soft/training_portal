package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.AnswerSimpleDao;
import com.company.training_portal.model.AnswerSimple;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;

@Repository
public class AnswerSimpleDaoJdbc implements AnswerSimpleDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public AnswerSimpleDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public List<AnswerSimple> findAllAnswersSimpleByQuestionId(Long questionId) {
        return null;
    }

    @Override
    public Long addAnswerSimple(AnswerSimple answerSimple) {
        return null;
    }

    @Override
    public void editAnswerSimple(AnswerSimple answerSimple) {

    }

    @Override
    public void deleteAnswerSimple(Long answerSimpleId) {

    }
}
