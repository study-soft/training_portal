package com.company.training_portal.model.enums;

public enum QuizStatus {
    OPENED("opened"), PASSED("passed"), REOPENED("reopened"), CLOSED("closed");

    private String quizStatus;

    QuizStatus(String quizStatus) {
        this.quizStatus = quizStatus;
    }

    public String getQuizStatus() {
        return quizStatus;
    }
}
