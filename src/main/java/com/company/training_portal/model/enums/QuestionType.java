package com.company.training_portal.model.enums;

public enum QuestionType {
    ONE_ANSWER("ONE_ANSWER"), FEW_ANSWERS("FEW_ANSWERS"), ACCORDANCE("ACCORDANCE"),
    SEQUENCE("SEQUENCE"), NUMBER("NUMBER");

    private String questionType;

    QuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getQuestionType() {
        return questionType;
    }
}
