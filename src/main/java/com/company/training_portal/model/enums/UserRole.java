package com.company.training_portal.model.enums;

public enum UserRole {
    TEACHER("TEACHER"), STUDENT("STUDENT"), CHOOSE("CHOOSE");

    private String role;

    UserRole(String role) {
        this.role = role;
    }

    public String getRole() {
        return role;
    }
}
