package com.company.training_portal.model.enums;

public enum QuestionType {
    ONE_ANSWER(0), FEW_ANSWERS(1), ACCORDANCE(2), SEQUENCE(3), NUMBER(4);

    private int id;

    QuestionType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
