package com.company.training_portal.dao;

import com.company.training_portal.model.User;

import java.util.Collection;
import java.util.Map;

public interface UserDao {

    User findUserByUserId(Long userId);

    User findUserByLogin(String login);

    User findUserByEmail(String email);

    User findUserByPhoneNumber(String phoneNumber);

    Collection<User> findUsersByFirstNameAndLastName(String firstName, String lastName);

    Collection<User> findStudentsByGroupId(Long groupId);

    Collection<User> findAllStudents();

    Collection<User> findAllTeacers();

    Integer findStudentsNumber();

    Integer findTeachersNumber();

    Integer finddtudentsNumberInGroup(Long groupId);

    Integer findStudentNumberInGroupWithClosedQuiz(Long groupId, Long quizId);

    Collection<Integer> findResultsByGroupIdAndQuizId(Long groupId, Long quizId);

    Collection<Integer> findFinalResultsByGroupIdAndQuizId(Long groupId, Long quizId);

    // key: quiz's name, value: result
    Map<String, Integer> findAllStudentResults(Long userId);

    // key: student's first name + last name, value: result
    Map<String, Integer> findResulstByGroupIdAndQuizId(Long groupId, Long quizId);

    boolean userExists(String login, String email, String phoneNumber);

    boolean checkUserByLoginAndPassword(User user);

    Integer addUser(User user);

    void addStudentToGroup(Integer userId, Integer groupId);

    void addStudentsToGroup(Collection<User> users, Integer groupId);

    void updateUser(User user);

    void deleteUserFromGroup(Integer userId);
}