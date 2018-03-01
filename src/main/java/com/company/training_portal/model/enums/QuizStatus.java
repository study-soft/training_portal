package com.company.training_portal.model.enums;

public enum QuizStatus {
    OPENED(0), PASSED_UNCONFIRMED(1), PASSED_CONFIRMED(2), REOPENED(3), CLOSED(4);

    private int id;

    QuizStatus(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
