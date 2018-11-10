package com.company.training_portal.model.enums;

import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Locale;
import java.util.ResourceBundle;

public enum TeacherQuizStatus {
    UNPUBLISHED("UNPUBLISHED"), PUBLISHED("PUBLISHED");

    private String teacherQuizStatus;

    TeacherQuizStatus(String teacherQuizStatus) {
        this.teacherQuizStatus = teacherQuizStatus;
    }

    public String getTeacherQuizStatus() {
        return teacherQuizStatus;
    }

    @Override
    public String toString() {
        Locale locale = LocaleContextHolder.getLocale();
        ResourceBundle bundle = ResourceBundle.getBundle("i18n/language", locale);
        return bundle.getString("quiz.status." + this.getTeacherQuizStatus().toLowerCase());
    }
}
