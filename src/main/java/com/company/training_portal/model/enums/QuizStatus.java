package com.company.training_portal.model.enums;

public enum QuizStatus {
    CREATED(0), OPENED(1), PASSED_UNCONFIRMED(2), PASSED_CONFIRMED(3), REOPENED(4), CLOSED(5);

    private int id;

    QuizStatus(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
