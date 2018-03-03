package com.company.training_portal.model.enums;

public enum QuizStatus {
    OPENED(0), PASSED(1), REOPENED(2), CLOSED(3);

    private int id;

    QuizStatus(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
