package com.company.training_portal.model.enums;

public enum StudentQuizStatus {
    OPENED("opened"), PASSED("passed"), FINISHED("finished");

    private String studentQuizStatus;

    StudentQuizStatus(String studentQuizStatus) {
        this.studentQuizStatus = studentQuizStatus;
    }

    public String getStudentQuizStatus() {
        return studentQuizStatus;
    }
}
