package com.company.training_portal.model;

import java.time.Duration;
import java.time.LocalDate;

public class Quiz {

    private Long quizId;
    private String name;
    private String description;
    private String explanation;
    private LocalDate creationDate;
    private Duration passingTime;
    private Long authorId;
    private Integer reopenCounter;

}
