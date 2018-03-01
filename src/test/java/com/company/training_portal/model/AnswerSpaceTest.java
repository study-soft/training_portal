package com.company.training_portal.model;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class AnswerSpaceTest {

    private AnswerSpace answerSpace;

    @Before
    public void setUp() throws Exception {
        answerSpace = new AnswerSpace.AnswerSpaceBuilder().build();
        answerSpace.setAnswerSpaceId(1L);
        answerSpace.setQuestionId(1L);
        answerSpace.setStudentAnswer("studentAnswer");
    }

    @Test
    public void test_answerSpace_builder() {
        AnswerSpace answerSpaceBuilt = new AnswerSpace.AnswerSpaceBuilder()
                .answerSpaceId(1L)
                .questionId(1L)
                .studentAnswer("studentAnswer")
                .build();

        assertEquals(answerSpace, answerSpaceBuilt);
    }
}