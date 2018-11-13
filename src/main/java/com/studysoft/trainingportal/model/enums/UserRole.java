package com.studysoft.trainingportal.model.enums;

import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Locale;
import java.util.ResourceBundle;

public enum UserRole {
    TEACHER("TEACHER"), STUDENT("STUDENT"), CHOOSE("CHOOSE");

    private String role;

    UserRole(String role) {
        this.role = role;
    }

    public String getRole() {
        return role;
    }

    @Override
    public String toString() {
        Locale locale = LocaleContextHolder.getLocale();
        ResourceBundle bundle = ResourceBundle.getBundle("i18n/language", locale);
        return bundle.getString("user.role." + this.getRole().toLowerCase());
    }
}
