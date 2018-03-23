package com.company.training_portal.model.enums;

public enum StudentQuizStatus {
    OPENED("OPENED"), PASSED("PASSED"), CLOSED("CLOSED");

    private String studentQuizStatus;

    StudentQuizStatus(String studentQuizStatus) {
        this.studentQuizStatus = studentQuizStatus;
    }

    public String getStudentQuizStatus() {
        return studentQuizStatus;
    }
}
