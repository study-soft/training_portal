package com.company.training_portal.dao;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface UserDao {

    User findUserByUserId(Long userId);

    User findUserByLogin(String login);

    User findUserByEmail(String email);

    User findUserByPhoneNumber(String phoneNumber);

    List<User> findUsersByFirstNameAndLastName(String firstName, String lastName);

    List<User> findStudentsByGroupName(String groupName);

    List<User> findAllStudents();

    List<User> findAllTeachers();

    List<User> findAllStudentsByQuizIdAndGroupId(Long quizId, Long groupId);

    Integer findStudentsNumber();

    Integer findTeachersNumber();

    Integer findStudentsNumberInGroup(Long groupId);

    Integer findStudentNumberInGroupWithFinishedQuiz(Long groupId, Long quizId);

    List<Integer> findResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId);

    List<Integer> findFinalResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId);

    // key: quiz's name, value: result
    Map<String, Integer> findAllStudentResults(Long userId);

    // key: student's first name + last name, value: result
    Map<String, Integer> findResultsAndStudentNamesByGroupIdAndQuizId(Long groupId, Long quizId);

    Integer findReopenCounterByStudentIdAndQuizId(Long studentId, Long quizId);

    Integer findUserQuizJunctionIdByStudentIdAndQuizId(Long studentId, Long quizId);

    boolean userExists(String login, String email, String phoneNumber);

    boolean checkUserByLoginAndPassword(User user);

    Long addUser(User user);

    void addStudentToGroup(Integer userId, Integer groupId);

    void addStudentsToGroup(List<User> users, Integer groupId);

    Long addStudentInfoAboutQuiz(Long studentId, Long quizId, Integer result,
                                 LocalDateTime submitDate, LocalDateTime finishDate,
                                 StudentQuizStatus studentQuizStatus);

    void updateStudentInfoAboutQuiz(Long userQuizJunctionId, Integer result,
                                    LocalDateTime finishDate, Integer reopenCounter,
                                    StudentQuizStatus studentQuizStatus);

    //todo: make use cases of editUser(User user)
    void editUser(User user);

    void deleteUserFromGroup(Long userId, Long groupId);
}
