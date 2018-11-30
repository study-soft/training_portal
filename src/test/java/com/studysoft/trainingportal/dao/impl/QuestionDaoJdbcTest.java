package com.studysoft.trainingportal.dao.impl;

import com.studysoft.trainingportal.config.AppConfig;
import com.studysoft.trainingportal.dao.QuestionDao;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@WebAppConfiguration
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:dump_postgres.sql"})
public class QuestionDaoJdbcTest {

    @Autowired
    private QuestionDao questionDao;

    public void setQuestionDao(QuestionDao questionDao) {
        this.questionDao = questionDao;
    }

    @Test
    public void test_find_question_by_questionId() {
        Question testQuestion = new Question.QuestionBuilder()
                .questionId(1L)
                .quizId(1L)
                .body("Question 1.1 body?")
                .explanation("Question 1.1 explanation")
                .questionType(QuestionType.ONE_ANSWER)
                .score(1)
                .build();

        Question question = questionDao.findQuestion(1L);

        assertEquals(testQuestion, question);
    }

    @Test
    public void test_find_questions_by_quizId() {
        List<Question> testQuestions = new ArrayList<>();
        testQuestions.add(questionDao.findQuestion(1L));
        testQuestions.add(questionDao.findQuestion(2L));
        testQuestions.add(questionDao.findQuestion(3L));
        testQuestions.add(questionDao.findQuestion(4L));
        testQuestions.add(questionDao.findQuestion(5L));
        testQuestions.add(questionDao.findQuestion(6L));
        testQuestions.add(questionDao.findQuestion(7L));
        testQuestions.add(questionDao.findQuestion(8L));
        testQuestions.add(questionDao.findQuestion(9L));
        testQuestions.add(questionDao.findQuestion(10L));
        testQuestions.add(questionDao.findQuestion(11L));
        testQuestions.add(questionDao.findQuestion(12L));

        List<Question> questions = questionDao.findQuestions(1L);

        assertEquals(testQuestions, questions);
    }

    @Test
    public void test_find_questions_by_quizId_and_questionType() {
        List<Question> testQuestions = new ArrayList<>();
        testQuestions.add(questionDao.findQuestion(1L));
        testQuestions.add(questionDao.findQuestion(6L));
        testQuestions.add(questionDao.findQuestion(11L));
        testQuestions.add(questionDao.findQuestion(12L));

        List<Question> questions
                = questionDao.findQuestions(
                        1L, QuestionType.ONE_ANSWER);

        assertEquals(testQuestions, questions);
    }

    @Test
    public void test_find_questionTypes_and_count_by_quizId() {
        Map<QuestionType, Integer> testResults = new HashMap<>();
        testResults.put(QuestionType.ONE_ANSWER, 4);
        testResults.put(QuestionType.FEW_ANSWERS, 2);
        testResults.put(QuestionType.ACCORDANCE, 2);
        testResults.put(QuestionType.SEQUENCE, 2);
        testResults.put(QuestionType.NUMBER, 2);

        Map<QuestionType, Integer> results = questionDao.findQuestionTypesAndCount(1L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_add_question() {
        Question testQuestion = new Question.QuestionBuilder()
                .quizId(1L)
                .body("Question 1.6 body?")
                .explanation("Question 1.6 explanation")
                .questionType(QuestionType.ONE_ANSWER)
                .score(1)
                .build();
        Long questionId = questionDao.addQuestion(testQuestion);

        Question question = questionDao.findQuestion(questionId);

        assertEquals(testQuestion, question);
    }

    @Test
    public void test_edit_question() {
        Question testQuestion = new Question.QuestionBuilder()
                .quizId(1L)
                .body("body")
                .explanation("explanation")
                .questionType(QuestionType.ONE_ANSWER)
                .score(2)
                .questionId(1L)
                .build();
        questionDao.editQuestion(testQuestion);

        Question question = questionDao.findQuestion(1L);

        assertEquals(testQuestion, question);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void test_delete_question_by_questionId() {
        questionDao.deleteQuestion(1L);
        questionDao.findQuestion(1L);
    }
}