package com.studysoft.trainingportal.dao.impl;

import com.studysoft.trainingportal.config.AppConfig;
import com.studysoft.trainingportal.dao.AnswerNumberDao;
import com.studysoft.trainingportal.dao.QuestionDao;
import com.studysoft.trainingportal.model.AnswerNumber;
import com.studysoft.trainingportal.model.Question;
import com.studysoft.trainingportal.model.enums.QuestionType;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@WebAppConfiguration
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:dump_postgres.sql"})
public class AnswerNumberDaoJdbcTest {

    @Autowired
    private AnswerNumberDao answerNumberDao;

    @Autowired
    private QuestionDao questionDao;

    public void setAnswerNumberDao(AnswerNumberDao answerNumberDao) {
        this.answerNumberDao = answerNumberDao;
    }

    public void setQuestionDao(QuestionDao questionDao) {
        this.questionDao = questionDao;
    }

    @Test
    public void test_find_answerNumber_by_questionId() {
        AnswerNumber testAnswerNumber = new AnswerNumber.AnswerNumberBuilder()
                .questionId(5L)
                .correct(5)
                .build();

        AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(5L);

        assertEquals(testAnswerNumber, answerNumber);
    }

    @Test
    public void test_add_answerNumber() {
        Question testQuestion = new Question.QuestionBuilder()
                .quizId(1L)
                .body("Question 1.6 body?")
                .explanation("Question 1.6 explanation")
                .questionType(QuestionType.NUMBER)
                .score(1)
                .build();
        Long questionId = questionDao.addQuestion(testQuestion);

        AnswerNumber testAnswerNumber = new AnswerNumber.AnswerNumberBuilder()
                .questionId(questionId)
                .correct(10)
                .build();
        answerNumberDao.addAnswerNumber(testAnswerNumber);

        AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(questionId);

        assertEquals(testAnswerNumber, answerNumber);
    }

    @Test
    public void editAnswerNumber() {
        AnswerNumber testAnswerNumber = new AnswerNumber.AnswerNumberBuilder()
                .questionId(5L)
                .correct(10)
                .build();
        answerNumberDao.editAnswerNumber(testAnswerNumber);

        AnswerNumber answerNumber = answerNumberDao.findAnswerNumber(5L);

        assertEquals(testAnswerNumber, answerNumber);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void deleteAnswerNumber() {
        answerNumberDao.deleteAnswerNumber(5L);
        answerNumberDao.findAnswerNumber(5L);
    }
}