package com.company.training_portal.model.enums;

public enum QuestionType {
    ONE_ANSWER("one_answer"), FEW_ANSWERS("few_answers"), ACCORDANCE("accordance"),
    SEQUENCE("sequence"), NUMBER("number");

    private String questionType;

    QuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getQuestionType() {
        return questionType;
    }
}
