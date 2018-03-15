package com.company.training_portal.model;

import com.company.training_portal.model.enums.QuestionType;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class QuestionTest {

    private Question question;

    @Before
    public void setUp() throws Exception {
        question = new Question.QuestionBuilder().build();
        question.setQuestionId(1L);
        question.setQuizId(2L);
        question.setBody("body");
        question.setExplanation("explanation");
        question.setQuestionType(QuestionType.ACCORDANCE);
        question.setScore(45);
    }

    @Test
    public void test_question_builder() {
        Question questionBuilt = new Question.QuestionBuilder()
                .questionId(1L)
                .quizId(2L)
                .body("body")
                .explanation("explanation")
                .questionType(QuestionType.ACCORDANCE)
                .score(45)
                .build();

        assertEquals(question, questionBuilt);
    }
}