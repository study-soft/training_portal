package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.config.test.TestDaoConfig;
import com.company.training_portal.dao.AnswerSimpleDao;
import com.company.training_portal.model.AnswerSimple;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = TestDaoConfig.class)
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:schema.sql", "classpath:test-data.sql"})
public class AnswerSimpleDaoJdbcTest {

    @Autowired
    private AnswerSimpleDao answerSimpleDao;

    public void setAnswerSimpleDao(AnswerSimpleDao answerSimpleDao) {
        this.answerSimpleDao = answerSimpleDao;
    }

    @Test
    public void test_find_answerSimple_by_answerSimpleId() {
        AnswerSimple testAnswerSimple = new AnswerSimple.AnswerSimpleBuilder()
                .answerSimpleId(1L)
                .questionId(1L)
                .body("incorrect answer")
                .correct(false)
                .build();

        AnswerSimple answerSimple = answerSimpleDao.findAnswerSimpleByAnswerSimpleId(1L);

        assertEquals(testAnswerSimple, answerSimple);
    }

    @Test
    public void test_find_all_answers_simple_by_questionId() {
        List<AnswerSimple> testAnswersSimple = new ArrayList<>();
        testAnswersSimple.add(answerSimpleDao.findAnswerSimpleByAnswerSimpleId(1L));
        testAnswersSimple.add(answerSimpleDao.findAnswerSimpleByAnswerSimpleId(2L));
        testAnswersSimple.add(answerSimpleDao.findAnswerSimpleByAnswerSimpleId(3L));

        List<AnswerSimple> answersSimple = answerSimpleDao.findAllAnswersSimpleByQuestionId(1L);

        assertEquals(testAnswersSimple, answersSimple);
    }

    @Test
    public void test_add_answer_simple() {
        AnswerSimple testAnswerSimple = new AnswerSimple.AnswerSimpleBuilder()
                .questionId(2L)
                .body("correct answer")
                .correct(true)
                .build();
        Long testAnswerSimpleId = answerSimpleDao.addAnswerSimple(testAnswerSimple);

        AnswerSimple answerSimple =
                answerSimpleDao.findAnswerSimpleByAnswerSimpleId(testAnswerSimpleId);

        assertEquals(testAnswerSimple, answerSimple);
    }

    @Test
    public void test_edit_answer_simple() {
        AnswerSimple testAnswerSimple = new AnswerSimple.AnswerSimpleBuilder()
                .answerSimpleId(3L)
                .questionId(1L)
                .body("incorrect answer")
                .correct(false)
                .build();
        answerSimpleDao.editAnswerSimple(testAnswerSimple);

        AnswerSimple answerSimple =
                answerSimpleDao.findAnswerSimpleByAnswerSimpleId(3L);

        assertEquals(testAnswerSimple, answerSimple);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void test_delete_answer_simple() {
        answerSimpleDao.deleteAnswerSimple(10L);
        answerSimpleDao.findAnswerSimpleByAnswerSimpleId(10L);
    }
}