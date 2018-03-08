package com.company.training_portal.model;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class AnswerNumberTest {

    private AnswerNumber answerNumber;

    @Before
    public void setUp() throws Exception {
        answerNumber = new AnswerNumber.AnswerNumberBuilder().build();
        answerNumber.setQuestionId(1L);
        answerNumber.setCorrect(10);
    }

    @Test
    public void test_answerSpace_builder() {
        AnswerNumber answerNumberBuilt = new AnswerNumber.AnswerNumberBuilder()
                .questionId(1L)
                .correct(10)
                .build();

        assertEquals(answerNumber, answerNumberBuilt);
    }
}