package com.company.training_portal.dao;

import com.company.training_portal.model.OpenedQuiz;
import com.company.training_portal.model.PassedQuiz;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface QuizDao {

    Quiz findQuiz(Long quizId);

    List<Quiz> findAllQuizzes();

    List<Quiz> findTeacherQuizzes(Long authorId);

    List<Quiz> findTeacherQuizzes(Long authorId, TeacherQuizStatus status);

    List<Quiz> findStudentQuizzes(Long studentId);

    Integer findQuizzesNumber(Long authorId);

    // key: studentQuizStatus, value: number of students
    Map<StudentQuizStatus, Integer> findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(
            Long authorId, Long groupId, Long quizId);

    // key: teacherQuizStatus, value: number of quizzes
    Map<TeacherQuizStatus, Integer> findQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId);

    // key: quizId, value: result
    Map<Long, Integer> findAllStudentResults(Long studentId);

    List<Quiz> findQuizzes(Long studentId, Long authorId);

    List<Quiz> findPassedAndClosedGroupQuizzes(Long groupId);

    Integer findResult(Long studentId, Long quizId);

    LocalDateTime findSubmitDate(Long studentId, Long quizId);

    LocalDateTime findStartDate(Long studentId, Long quizId);

    LocalDateTime findFinishDate(Long studentId, Long quizId);

    Integer findAttempt(Long studentId, Long quizId);

    StudentQuizStatus findStudentQuizStatus(Long studentId, Long quizId);

    OpenedQuiz findOpenedQuiz(Long studentId, Long quizId);

    PassedQuiz findPassedQuiz(Long studentId, Long quizId);

    PassedQuiz findClosedQuiz(Long studentId, Long quizId);

    List<OpenedQuiz> findOpenedQuizzes(Long studentId);

    List<PassedQuiz> findPassedQuizzes(Long studentId);

    List<PassedQuiz> findClosedQuizzes(Long studentId);

    void addPublishedQuizInfo(Long studentId, Long quizId, LocalDate submitDate,
                              Integer attempt, StudentQuizStatus status);

    Long addQuiz(Quiz quiz);

    void editStartDate(LocalDateTime startDate, Long studentId, Long quizId);

    void editStudentInfoAboutOpenedQuiz(Long studentId, Long quizId,
                                        Integer result, LocalDateTime finishDate,
                                        Integer attempt, StudentQuizStatus studentQuizStatus);

    void editTeacherQuizStatus(TeacherQuizStatus teacherQuizStatus, Long quizId);

    void editQuiz(Quiz quiz);

    void closeQuiz(Long studentId, Long quizId);

    void deleteUnpublishedQuiz(Long quizId);
}
