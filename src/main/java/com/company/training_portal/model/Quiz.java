package com.company.training_portal.model;

import com.company.training_portal.model.enums.QuizStatus;
import com.company.training_portal.model.enums.QuizType;

import java.util.Collection;
import java.util.Date;

public class Quiz {
    private Long quizId;
    private QuizType quizType;
    private QuizStatus quizStatus;
    private String name;
    private String description;
    private String explanation;
    private Date creationDate;
    private Date startDate;
    private Long authorId;
    private Collection<User> students;
    private Integer reopenCounter;

}
