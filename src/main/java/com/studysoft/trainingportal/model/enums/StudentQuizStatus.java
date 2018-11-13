package com.studysoft.trainingportal.model.enums;

import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Locale;
import java.util.ResourceBundle;

public enum StudentQuizStatus {
    OPENED("OPENED"), PASSED("PASSED"), CLOSED("CLOSED");

    private String studentQuizStatus;

    StudentQuizStatus(String studentQuizStatus) {
        this.studentQuizStatus = studentQuizStatus;
    }

    public String getStudentQuizStatus() {
        return studentQuizStatus;
    }

    @Override
    public String toString() {
        Locale locale = LocaleContextHolder.getLocale();
        ResourceBundle bundle = ResourceBundle.getBundle("i18n/language", locale);
        return bundle.getString("quiz.status." + this.getStudentQuizStatus().toLowerCase());
    }
}
