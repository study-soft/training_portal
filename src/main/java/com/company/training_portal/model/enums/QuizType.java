package com.company.training_portal.model.enums;

public enum QuizType {
    TEST(0), CONTROL_WORK(1);
    private int id;

    QuizType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
