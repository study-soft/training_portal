package com.company.training_portal.model;

import com.company.training_portal.model.enums.QuizStatus;

import java.time.LocalDateTime;

public class UserQuizJunction {

    private Long userQuizJunctionId;
    private Long userId;
    private Long quizId;
    private Integer result;
    private LocalDateTime finishDate;
    private LocalDateTime submitDate;
    private Integer reopenCounter;
    private QuizStatus quizStatus;
}
