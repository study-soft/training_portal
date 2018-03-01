package com.company.training_portal.model.enums;

public enum QuizStatus {
    CREATED(0), OPENED(1), CLOSED(2), REOPENED(3);
    private int id;

    QuizStatus(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
