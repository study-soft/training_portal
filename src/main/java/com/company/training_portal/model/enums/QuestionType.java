package com.company.training_portal.model.enums;

public enum QuestionType {
    TEST_ONE_ANSWER(0), TEST_FEW_ANSWERS(1), ACCORDANCE(2), BLANK_SPACE(3);

    private int id;

    QuestionType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
