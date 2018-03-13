package com.company.training_portal.dao;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.UserRole;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface UserDao {

    User findUser(Long userId);

    User findUserByLogin(String login);

    User findUserByEmail(String email);

    User findUserByPhoneNumber(String phoneNumber);

    String findUserName(Long userId);

    List<User> findUsers(String firstName, String lastName, UserRole userRole);

    List<User> findStudents(Long groupId);

    List<User> findAllStudents();

    List<User> findAllTeachers();

    List<Long> findStudentIdsWithoutGroup();

    List<Long> findStudentIdsByGroupIdAndQuizId(Long quizId, Long groupId);

    Integer findStudentsNumber();

    Integer findTeachersNumber();

    Integer findStudentsNumberInGroupWithFinishedQuiz(Long groupId, Long quizId);

    Integer findResultsNumber(Long groupId, Long quizId);

    Integer findFinalResultsNumber(Long groupId, Long quizId);

    // key: studentId, value: result
    Map<Long, Integer> findStudentIdsAndResultsByGroupIdAndQuizId(Long groupId, Long quizId);

    Long findUserQuizJunctionId(Long studentId, Long quizId);

    boolean userExists(String login, String email, String phoneNumber);

    /**
     * Returns instance of user if user exists. Otherwise returns null.
     * @param login user login
     * @param password user password
     * @return instance of user if exists or null otherwise
     */
    User checkUserByLoginAndPassword(String login, String password);

    Long registerUser(User user);

    void addStudentToGroup(Long groupId, Long studentId);

    void addStudentsToGroup(Long groupId, List<Long> studentIds);

    Long addStudentInfoAboutQuiz(Long studentId, Long quizId, Integer result,
                                 LocalDateTime submitDate, LocalDateTime startDate,
                                 LocalDateTime finishDate, StudentQuizStatus studentQuizStatus);

    void updateStudentInfoAboutQuiz(Long userQuizJunctionId, Integer result,
                                    LocalDateTime finishDate, LocalDateTime startDate,
                                    Integer attempt, StudentQuizStatus studentQuizStatus);

    //todo: make use cases of editUser(User user)
    void editUser(User user);

    void deleteStudentFromGroupByUserId(Long userId);

    void deleteStudentsFromGroupByGroupId(Long groupId);
}
