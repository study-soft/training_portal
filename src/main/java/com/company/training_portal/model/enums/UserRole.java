package com.company.training_portal.model.enums;

public enum UserRole {
    TEACHER(0), STUDENT(1);

    private int id;

    UserRole(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
