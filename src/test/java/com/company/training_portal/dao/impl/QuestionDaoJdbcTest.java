package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.QuestionDao;
import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:schema.sql", "classpath:test-data.sql"})
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
                .name("Question #1.1")
                .body("Question 1.1 body?")
                .explanation("Question 1.1 explanation")
                .questionType(QuestionType.ONE_ANSWER)
                .score(1)
                .build();

        Question question = questionDao.findQuestionByQuestionId(1L);

        assertEquals(testQuestion, question);
    }

    @Test
    public void test_find_questions_by_quiId() {
        List<Question> testQuestions = new ArrayList<>();
        testQuestions.add(questionDao.findQuestionByQuestionId(1L));
        testQuestions.add(questionDao.findQuestionByQuestionId(2L));
        testQuestions.add(questionDao.findQuestionByQuestionId(3L));
        testQuestions.add(questionDao.findQuestionByQuestionId(4L));
        testQuestions.add(questionDao.findQuestionByQuestionId(5L));

        List<Question> questions = questionDao.findQuestionsByQuizId(1L);

        assertEquals(testQuestions, questions);
    }

    @Test
    public void test_find_questions_by_quizId_and_questionType() {
        List<Question> testQuestions = new ArrayList<>();
        testQuestions.add(questionDao.findQuestionByQuestionId(1L));

        List<Question> questions
                = questionDao.findQuestionsByQuizIdAndQuestionType(
                        1L, QuestionType.ONE_ANSWER);

        assertEquals(testQuestions, questions);
    }

    @Test
    public void test_find_questionTypes_and_count_by_quizId() {
        Map<QuestionType, Integer> testResults = new HashMap<>();
        testResults.put(QuestionType.ONE_ANSWER, 1);
        testResults.put(QuestionType.FEW_ANSWERS, 1);
        testResults.put(QuestionType.ACCORDANCE, 1);
        testResults.put(QuestionType.SEQUENCE, 1);
        testResults.put(QuestionType.NUMBER, 1);

        Map<QuestionType, Integer> results = questionDao.findQuestionTypesAndCountByQuizId(1L);

        assertEquals(testResults, results);
    }

    @Test
    public void test_find_questions_by_quizId_and_score() {
        List<Question> testQuestions = new ArrayList<>();
        testQuestions.add(questionDao.findQuestionByQuestionId(1L));

        List<Question> questions = questionDao.findQuestionsByQuizIdAndScore(1L, 1);

        assertEquals(testQuestions, questions);
    }

    @Test
    public void test_find_questions_number_by_quizId() {
        Integer number = questionDao.findQuestionsNumberByQuizId(1L);
        assertThat(number, is(5));
    }

    @Test
    public void test_find_quiz_score_by_quiz_id() {
        Integer testScore = 0;
        List<Question> questions = questionDao.findQuestionsByQuizId(1L);
        for(Question question : questions) {
            testScore += question.getScore();
        }
        assertThat(testScore, is(questionDao.findQuizScoreByQuizId(1L)));
    }

    @Test
    public void test_add_question() {
        Question testQuestion = new Question.QuestionBuilder()
                .quizId(1L)
                .name("Question #1.6")
                .body("Question 1.6 body?")
                .explanation("Question 1.6 explanation")
                .questionType(QuestionType.ONE_ANSWER)
                .score(1)
                .build();
        Long questionId = questionDao.addQuestion(testQuestion);

        Question question = questionDao.findQuestionByQuestionId(questionId);

        assertEquals(testQuestion, question);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void test_delete_question_by_questionId() {
        questionDao.deleteQuestionByQuestionId(1L);
        questionDao.findQuestionByQuestionId(1L);
    }
}