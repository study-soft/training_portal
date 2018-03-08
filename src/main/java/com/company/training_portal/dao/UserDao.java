package com.company.training_portal.dao;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.UserRole;
import org.springframework.lang.Nullable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface UserDao {

    User findUserByUserId(Long userId);

    User findUserByLogin(String login);

    User findUserByEmail(String email);

    User findUserByPhoneNumber(String phoneNumber);

    List<User> findUsersByFirstNameAndLastNameAndUserRole(String firstName, String lastName, UserRole userRole);

    List<User> findStudentsByGroupId(Long groupId);

    List<User> findAllStudents();

    List<User> findAllTeachers();

    List<Long> findStudentIdsWithoutGroup();

    List<Long> findStudentIdsByGroupIdAndQuizId(Long quizId, Long groupId);

    Integer findStudentsNumber();

    Integer findTeachersNumber();

    Integer findStudentsNumberInGroup(Long groupId);

    Integer findStudentsNumberInGroupWithFinishedQuiz(Long groupId, Long quizId);

    Integer findResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId);

    Integer findFinalResultsNumberByGroupIdAndQuizId(Long groupId, Long quizId);

    // key: studentId, value: result
    Map<Long, Integer> findStudentIdsAndResultsByGroupIdAndQuizId(Long groupId, Long quizId);

    Long findUserQuizJunctionIdByStudentIdAndQuizId(Long studentId, Long quizId);

    boolean userExists(String login, String email, String phoneNumber);

    /**
     * Returns instance of user if user exists. Otherwise returns null.
     * @param login user login
     * @param password user password
     * @return instance of user if exists or null otherwise
     */
    @Nullable
    User checkUserByLoginAndPassword(String login, String password);

    Long registerUser(User user);

    void addStudentToGroupByGroupIdAndUserId(Long groupId, Long studentId);

    void addStudentsToGroup(Long groupId, List<Long> studentIds);

    Long addStudentInfoAboutQuiz(Long studentId, Long quizId, Integer result,
                                 LocalDateTime submitDate, LocalDateTime finishDate,
                                 StudentQuizStatus studentQuizStatus);

    void updateStudentInfoAboutQuiz(Long userQuizJunctionId, Integer result,
                                    LocalDateTime finishDate, Integer reopenCounter,
                                    StudentQuizStatus studentQuizStatus);

    //todo: make use cases of editUser(User user)
    void editUser(User user);

    void deleteStudentFromGroupByUserId(Long userId);

    void deleteStudentsFromGroupByGroupId(Long groupId);
}
