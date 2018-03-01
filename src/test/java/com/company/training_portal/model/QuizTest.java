package com.company.training_portal.model;

import org.junit.Before;
import org.junit.Test;

import java.time.Duration;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import static org.junit.Assert.*;

public class QuizTest {

    private Quiz quiz;

    @Before
    public void setUp() throws Exception {
        quiz = new Quiz.QuizBuilder().build();
        quiz.setQuizId(1L);
        quiz.setName("name");
        quiz.setDescription("description");
        quiz.setExplanation("explanation");
        quiz.setCreationDate(LocalDate.of(2018, 1, 3));
        quiz.setPassingTime(Duration.of(25, ChronoUnit.SECONDS));
        quiz.setAuthorId(2L);
    }

    @Test
    public void test_quiz_builder() {
        Quiz quizBuilt = new Quiz.QuizBuilder()
                .quizId(1L)
                .name("name")
                .description("description")
                .explanation("explanation")
                .creationDate(LocalDate.of(2018, 1, 3))
                .passingTime(Duration.of(25, ChronoUnit.SECONDS))
                .authorId(2L)
                .build();

        assertEquals(quiz, quizBuilt);
    }
}