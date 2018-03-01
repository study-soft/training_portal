package com.company.training_portal.model;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class AnswerSimpleTest {

    private AnswerSimple answerSimple;

    @Before
    public void setUp() {
        answerSimple = new AnswerSimple.AnswerSimpleBuilder().build();
        answerSimple.setAnswerSimpleId(1L);
        answerSimple.setQuestionId(1L);
        answerSimple.setBody("body");
        answerSimple.setCorrect(true);
    }

    @Test
    public void test_answerSimple_builder() {
        AnswerSimple answerSimpleBuilt = new AnswerSimple.AnswerSimpleBuilder()
                .answerSimpleId(1L)
                .questionId(1L)
                .body("body")
                .correct(true)
                .build();
        assertEquals(answerSimple, answerSimpleBuilt);
    }
}