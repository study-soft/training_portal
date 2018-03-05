package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;

@Repository
public class QuestionDaoJdbc implements QuestionDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public QuestionDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public Question findQuestionById(Long questionId) {
        return null;
    }

    @Override
    public List<Question> findQuestionsByQuizId(Long quizId) {
        return null;
    }

    @Override
    public List<Question> findQuestionsByQuizIdAndQuestionType(Long quizId, QuestionType questionType) {
        return null;
    }

    @Override
    public List<Question> findQuestionsByQuizIdAndScore(Long quizId, Integer score) {
        return null;
    }

    @Override
    public Integer findQuestionsNumberByQuizId(Long quizId) {
        return null;
    }

    @Override
    public Long addQuestion(Question question) {
        return null;
    }

    @Override
    public void editQuestion(Question question) {

    }

    @Override
    public void deleteQuestion(Long questionId) {

    }
}
