package com.company.training_portal.model.enums;

import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Locale;
import java.util.ResourceBundle;

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

    @Override
    public String toString() {
        Locale locale = LocaleContextHolder.getLocale();
        ResourceBundle bundle = ResourceBundle.getBundle("i18n/language", locale);
        return bundle.getString("question.type." + this.getQuestionType().toLowerCase());
    }
}
