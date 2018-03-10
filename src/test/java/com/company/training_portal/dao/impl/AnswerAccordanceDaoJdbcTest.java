package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.AnswerAccordanceDao;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.model.AnswerAccordance;
import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@WebAppConfiguration
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:schema.sql", "classpath:test-data.sql"})
public class AnswerAccordanceDaoJdbcTest {

    @Autowired
    private AnswerAccordanceDao answerAccordanceDao;

    @Autowired
    private QuestionDao questionDao;

    public void setAnswerAccordanceDao(AnswerAccordanceDao answerAccordanceDao) {
        this.answerAccordanceDao = answerAccordanceDao;
    }

    @Test
    public void test_find_answerAccordance_by_questionId() {
        Map<String, String> correctMap = new HashMap<>();
        correctMap.put("SQL", "database");
        correctMap.put("Java", "backend");
        correctMap.put("HTML", "frontend");
        correctMap.put("Pascal", "Dead");
        AnswerAccordance testAnswerAccordance
                = new AnswerAccordance.AnswerAccordanceBuilder()
                .questionId(3L)
                .correctMap(correctMap)
                .build();

        AnswerAccordance answerAccordance
                = answerAccordanceDao.findAnswerAccordanceByQuestionId(3L);

        assertEquals(testAnswerAccordance, answerAccordance);
    }

    @Test
    public void test_add_answerAccordance() {
        Question testQuestion = new Question.QuestionBuilder()
                .quizId(1L)
                .name("Question #1.6")
                .body("Question 1.6 body?")
                .explanation("Question 1.6 explanation")
                .questionType(QuestionType.ACCORDANCE)
                .score(1)
                .build();
        Long questionId = questionDao.addQuestion(testQuestion);

        Map<String, String> correctMap = new HashMap<>();
        correctMap.put("Model", "Dao");
        correctMap.put("View", "Pages");
        correctMap.put("Controller", "Request handler");
        correctMap.put("Spring", "Business logic container");
        AnswerAccordance testAnswerAccordance
                = new AnswerAccordance.AnswerAccordanceBuilder()
                .questionId(questionId)
                .correctMap(correctMap)
                .build();
        answerAccordanceDao.addAnswerAccordance(testAnswerAccordance);

        AnswerAccordance answerAccordance =
                answerAccordanceDao.findAnswerAccordanceByQuestionId(questionId);

        assertEquals(testAnswerAccordance, answerAccordance);
    }

    @Test
    public void edit_answerAccordance() {
        Map<String, String> correctMap = new HashMap<>();
        correctMap.put("Model", "Dao");
        correctMap.put("View", "Pages");
        correctMap.put("Controller", "Class-handler");
        correctMap.put("Spring", "Business logic container");
        AnswerAccordance testAnswerAccordance
                = new AnswerAccordance.AnswerAccordanceBuilder()
                .questionId(3L)
                .correctMap(correctMap)
                .build();
        answerAccordanceDao.editAnswerAccordance(testAnswerAccordance);

        AnswerAccordance answerAccordance
                = answerAccordanceDao.findAnswerAccordanceByQuestionId(3L);

        assertEquals(testAnswerAccordance, answerAccordance);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void delete_answerAccordance() {
        answerAccordanceDao.deleteAnswerAccordance(3L);
        answerAccordanceDao.findAnswerAccordanceByQuestionId(3L);
    }
}