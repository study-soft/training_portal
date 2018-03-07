package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.UserRole;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.time.LocalDate;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
public class UserDaoJdbcTest {

    @Autowired
    private UserDao userDao;

    @Test
    public void test_find_user_by_user_id_login_email_phoneNumber() {
        User testUser = new User.UserBuilder()
                .userId(4L)
                .groupId(1L)
                .firstName("Artem")
                .lastName("Yakovenko")
                .email("artem@example.com")
                .dateOfBirth(LocalDate.of(1996, 1, 28))
                .phoneNumber("095-98-76-54")
                .photo(null)
                .login("Artem")
                .password("123")
                .userRole(UserRole.STUDENT)
                .build();
        User userByUserId = userDao.findUserByUserId(4L);
        User userByLogin = userDao.findUserByLogin("Artem");
        User userByEmail = userDao.findUserByEmail("artem@example.com");
        User userByPhoneNumber = userDao.findUserByPhoneNumber("095-98-76-54");
        assertEquals(testUser, userByUserId);
        assertEquals(testUser, userByLogin);
        assertEquals(testUser, userByEmail);
        assertEquals(testUser, userByPhoneNumber);
    }
}