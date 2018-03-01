package com.company.training_portal.model;

import com.company.training_portal.model.enums.UserRole;
import org.junit.Before;
import org.junit.Test;

import java.time.LocalDate;

import static org.junit.Assert.assertEquals;

public class UserTest {

    private User user;

    @Before
    public void setUp() {
        user = new User.UserBuilder().build();
        user.setUserId(1L);
        user.setGroupId(1L);
        user.setFirstName("firstName");
        user.setLastName("lastName");
        user.setEmail("example@gmail.com");
        user.setDateOfBirth(LocalDate.of(2018, 3, 1));
        user.setPhoneNumber("009");
        user.setLogin("login");
        user.setPassword("password");
        user.setUserRole(UserRole.STUDENT);
    }

    @Test
    public void test_user_builder() {
        User userBuilt = new User.UserBuilder()
                .userId(1L)
                .groupId(1L)
                .firstName("firstName")
                .lastName("lastName")
                .email("example@gmail.com")
                .dateOfBirth(LocalDate.of(2018, 3, 1))
                .phoneNumber("009")
                .login("login")
                .password("password")
                .userRole(UserRole.STUDENT)
                .build();
        assertEquals(user, userBuilt);
    }

}