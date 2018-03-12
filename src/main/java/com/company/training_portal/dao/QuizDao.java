package com.company.training_portal.dao;

import com.company.training_portal.model.OpenedQuiz;
import com.company.training_portal.model.PassedQuiz;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface QuizDao {

    Quiz findQuiz(Long quizId);

    List<Quiz> findAllQuizzes();

    List<Long> findAllQuizIds();

    List<Quiz> findTeacherQuizzes(Long authorId);

    List<Long> findAllQuizIdsByAuthorId(Long authorId);

    List<Quiz> findStudentQuizzes(Long studentId);

    List<Long> findAllClosedQuizIdsByAuthorId(Long authorId);

    List<Long> findAllNotPublishedQuizIdsByAuthorId(Long authorId);

    List<Long> findAllQuizIdsByStudentIdAndStudentQuizStatus(Long studentId, StudentQuizStatus studentQuizStatus);

    Integer findQuizzesNumber(Long authorId);

    // key: studentQuizStatus, value: number of students
    Map<StudentQuizStatus, Integer> findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(
            Long authorId, Long groupId, Long quizId);

    // key: teacherQuizStatus, value: number of quizzes
    Map<TeacherQuizStatus, Integer> FindQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId);

    // key: quizId, value: result
    Map<Long, Integer> findAllStudentResults(Long studentId);

    List<Long> findQuizIdsByStudentIdAndAttempt(Long studentId, Integer attempt);

    List<Quiz> findQuizzes(Long studentId, Long authorId);

    Integer findResult(Long studentId, Long quizId);

    LocalDateTime findSubmitDate(Long studentId, Long quizId);

    LocalDateTime findStartDate(Long studentId, Long quizId);

    LocalDateTime findFinishDate(Long studentId, Long quizId);

    Integer findAttempt(Long studentId, Long quizId);

    StudentQuizStatus findStudentQuizStatus(Long studentId, Long quizId);

    OpenedQuiz findOpenedQuiz(Long studentId, Long quizId);

    PassedQuiz findPassedQuiz(Long studentId, Long quizId);

    PassedQuiz findFinishedQuiz(Long studentId, Long quizId);

    List<OpenedQuiz> findOpenedQuizzes(Long studentId);

    List<PassedQuiz> findPassedQuizzes(Long studentId);

    List<PassedQuiz> findFinishedQuizzes(Long studentId);

    Long addQuiz(Quiz quiz);

    void editTeacherQuizStatus(TeacherQuizStatus teacherQuizStatus, Long quizId);

    void editQuiz(Quiz quiz);

    void finishQuiz(Long studentId, Long quizId);

    void deleteUnpublishedQuiz(Long quizId);
}
