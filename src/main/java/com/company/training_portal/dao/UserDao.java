package com.company.training_portal.dao;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.UserRole;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface UserDao {

    User findUser(Long userId);

    User findUserByLogin(String login);

    // No usages
    User findUserByEmail(String email);

    // No usages
    User findUserByPhoneNumber(String phoneNumber);

    String findUserName(Long userId);

    // No usages
    List<User> findUsers(String firstName, String lastName, UserRole userRole);

    List<User> findStudents(Long groupId);

    List<User> findStudents(Long groupId, Long quizId);

    List<User> findStudents(Long groupId, Long quizId, StudentQuizStatus status);

    List<User> findStudentsByTeacherId(Long teacherId);

    // No usages
    List<User> findAllStudents();

    List<User> findStudentsWithoutGroup();

    List<User> findStudentsWithoutGroup(Long teacherId);

    List<User> findStudentsWithoutGroupForQuizPublication(Long quizId);

    List<User> findStudentsForQuizPublication(Long groupId, Long quizId);

    List<User> findStudentsWithoutGroupForWhomPublished(Long quizId);

    List<User> findStudentsForWhomPublished(Long groupId, Long quizId);

    // No usages
    List<User> findAllTeachers();

    // No usages
    Integer findStudentsNumber();

    Integer findStudentsNumberToWhomQuizWasPublished(Long quizId);

    Integer findStudentsNumberWhoClosedQuiz(Long quizId);

    Integer findStudentsNumber(Long groupId, Long quizId);

    // No usages
    Integer findTeachersNumber();

    Integer findStudentsNumberInGroupWithClosedQuiz(Long groupId, Long quizId);

    // No usages
    Integer findResultsNumber(Long groupId, Long quizId);

    // No usages
    Integer findFinalResultsNumber(Long groupId, Long quizId);

    boolean userExistsByLogin(String login);

    boolean userExistsByEmail(String email);

    boolean userExistsByPhoneNumber(String phoneNumber);

    /**
     * Returns instance of user if user exists. Otherwise returns null.
     * @param login user login
     * @param password user password
     * @return instance of user if exists or null otherwise
     */
    User checkUserByLoginAndPassword(String login, String password);

    Long registerUser(User user);

    // No usages
    void addStudentToGroup(Long groupId, Long studentId);

    void addStudentsToGroup(Long groupId, List<Long> studentIds);

    void editUser(Long userId, String firstName, String lastName, String email, LocalDate dateOfBirth,
                  String phoneNumber, String password);

    void deleteStudentFromGroupByUserId(Long userId);

    void deleteStudentsFromGroupByGroupId(Long groupId);
}
