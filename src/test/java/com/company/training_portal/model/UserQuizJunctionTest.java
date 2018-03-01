package com.company.training_portal.model;

import com.company.training_portal.model.enums.QuizStatus;
import org.junit.Before;
import org.junit.Test;

import java.time.LocalDateTime;

import static org.junit.Assert.*;

public class UserQuizJunctionTest {

    private UserQuizJunction userQuizJunction;

    @Before
    public void setUp() throws Exception {
        userQuizJunction = new UserQuizJunction.UserQuizJunctionBuilder().build();
        userQuizJunction.setUserQuizJunctionId(1L);
        userQuizJunction.setUserId(2L);
        userQuizJunction.setQuizId(3L);
        userQuizJunction.setResult(50);
        userQuizJunction.setFinishDate(
                LocalDateTime.of(2018, 1, 3, 15, 5, 35));
        userQuizJunction.setSubmitDate(
                LocalDateTime.of(2018, 3, 6, 4, 56, 34));
        userQuizJunction.setReopenCounter(5);
        userQuizJunction.setQuizStatus(QuizStatus.OPENED);
    }

    @Test
    public void test_userQuizJunction_builder() {
        UserQuizJunction userQuizJunctionBuilt = new UserQuizJunction.UserQuizJunctionBuilder()
                .userQuizJunctionId(1L)
                .userId(2L)
                .quizId(3L)
                .result(50)
                .finishDate(
                        LocalDateTime.of(2018, 1, 3, 15, 5, 35))
                .submitDate(
                        LocalDateTime.of(2018, 3, 6, 4, 56, 34))
                .reopenCounter(5)
                .quizStatus(QuizStatus.OPENED)
                .build();

        assertEquals(userQuizJunction, userQuizJunctionBuilt);
    }
}