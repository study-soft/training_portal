package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;

@Repository
public class UserDaoJdbc implements UserDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public UserDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public User findUserByUserId(Long userId) {
        return null;
    }

    @Override
    public User findUserByLogin(String login) {
        return null;
    }

    @Override
    public User findUserByEmail(String email) {
        return null;
    }

    @Override
    public User findUserByPhoneNumber(String phoneNumber) {
        return null;
    }

    @Override
    public List<User> findUsersByFirstNameAndLastName(String firstName, String lastName) {
        return null;
    }

    @Override
    public List<User> findStudentsByGroupName(String groupName) {
        return null;
    }

    @Override
    public List<User> findAllStudents() {
        return null;
    }

    @Override
    public List<User> findAllTeachers() {
        return null;
    }

    @Override
    public List<User> findAllStudentsByQuizIdAndGroupId(Long quizId, Long groupId) {
        return null;
    }

    @Override
    public Integer findStudentsNumber() {
        return null;
    }

    @Override
    public Integer findTeachersNumber() {
        return null;
    }

    @Override
    public Integer findStudentsNumberInGroup(Long groupId) {
        return null;
    }

    @Override
    public Integer findStudentNumberInGroupWithClosedQuiz(Long groupId, Long quizId) {
        return null;
    }

    @Override
    public List<Integer> findResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId) {
        return null;
    }

    @Override
    public List<Integer> findFinalResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId) {
        return null;
    }

    @Override
    public Map<String, Integer> findAllStudentResults(Long userId) {
        return null;
    }

    @Override
    public Map<String, Integer> findResultsAndStudentNamesByGroupIdAndQuizId(Long groupId, Long quizId) {
        return null;
    }

    @Override
    public boolean userExists(String login, String email, String phoneNumber) {
        return false;
    }

    @Override
    public boolean checkUserByLoginAndPassword(User user) {
        return false;
    }

    @Override
    public Long addUser(User user) {
        return null;
    }

    @Override
    public void addStudentToGroup(Integer userId, Integer groupId) {

    }

    @Override
    public void addStudentsToGroup(List<User> users, Integer groupId) {

    }

    @Override
    public void editUser(User user) {

    }

    @Override
    public void deleteUserFromGroup(Long userId, Long groupId) {

    }
}
