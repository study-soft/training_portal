package com.company.training_portal.model;

import com.company.training_portal.model.enums.UserRole;

import java.time.LocalDate;

public class User {

    private Long userId;
    private Long groupId;
    private String firstName;
    private String lastName;
    private String email;
    private LocalDate dateOfBirth;
    private String phoneNumber;
    private byte[] photo;
    private String login;
    private String password;
    private UserRole userRole;

}
