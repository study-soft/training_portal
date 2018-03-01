package com.company.training_portal.model;

import com.company.training_portal.model.enums.QuestionType;

public class Question {

    private Long questionId;
    private Long quizId;
    private String name;
    private String body;
    private String explanation;
    private QuestionType questionType;
    private Integer score;
}
