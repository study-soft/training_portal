package com.company.training_portal.dao;

import com.company.training_portal.model.OpenedQuiz;
import com.company.training_portal.model.PassedQuiz;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface QuizDao {

    Quiz findQuiz(Long quizId);

    List<Quiz> findAllQuizzesWithQuestions();

    List<Long> findTeacherQuizIds(Long authorId);

    List<Quiz> findUnpublishedQuizzes(Long teacherId);

    List<Quiz> findPublishedQuizzes(Long teacherId);

    List<Quiz> findGroupQuizzes(Long groupId, Long teacherId);

    List<Quiz> findStudentQuizzes(Long studentId);

    Integer findQuizzesNumber(Long authorId);

    // key: studentQuizStatus, value: number of students
    Map<StudentQuizStatus, Integer> findStudentsNumberWithStudentQuizStatus(
            Long authorId, Long groupId, Long quizId);

    // key: teacherQuizStatus, value: number of quizzes
    Map<TeacherQuizStatus, Integer> findQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId);

    // key: quizId, value: result
    Map<Long, Integer> findAllStudentResults(Long studentId);

    List<Quiz> findQuizzes(Long studentId, Long authorId);

    List<Long> findCommonQuizIds(Long studentId1, Long studentId2);

    Integer findResult(Long studentId, Long quizId);

    LocalDateTime findSubmitDate(Long studentId, Long quizId);

    LocalDateTime findStartDate(Long studentId, Long quizId);

    LocalDateTime findFinishDate(Long studentId, Long quizId);

    Integer findAttempt(Long studentId, Long quizId);

    StudentQuizStatus findStudentQuizStatus(Long studentId, Long quizId);

    LocalDateTime findClosingDate(Long groupId, Long quizId);

    OpenedQuiz findOpenedQuiz(Long studentId, Long quizId);

    PassedQuiz findPassedQuiz(Long studentId, Long quizId);

    PassedQuiz findClosedQuiz(Long studentId, Long quizId);

    List<OpenedQuiz> findOpenedQuizzes(Long studentId);

    List<PassedQuiz> findPassedQuizzes(Long studentId);

    List<PassedQuiz> findClosedQuizzes(Long studentId);

    List<OpenedQuiz> findOpenedQuizzes(Long studentId, Long teacherId);

    List<PassedQuiz> findPassedQuizzes(Long studentId, Long teacherId);

    List<PassedQuiz> findClosedQuizzes(Long studentId, Long teacherId);

    boolean quizExistsByName(String name);

    void addPublishedQuizInfo(Long studentId, Long quizId, LocalDateTime submitDate);

    Long addQuiz(Quiz quiz);

    void editStartDate(LocalDateTime startDate, Long studentId, Long quizId);

    void editStudentInfoAboutOpenedQuiz(Long studentId, Long quizId,
                                        Integer result, LocalDateTime finishDate,
                                        Integer attempt, StudentQuizStatus studentQuizStatus);

    void editTeacherQuizStatus(TeacherQuizStatus teacherQuizStatus, Long quizId);

    void editQuiz(Quiz quiz);

    void editQuiz(Long quizId, String name, String description,
                  String explanation, Duration passingTime);

    void closeQuiz(Long studentId, Long quizId);

    void deleteUnpublishedQuiz(Long quizId);
}
