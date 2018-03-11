package com.company.training_portal.dao;

import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface QuizDao {

    Quiz findQuizByQuizId(Long quizId);

    List<Quiz> findAllQuizzes();

    List<Long> findAllQuizIds();

    List<Quiz> findAllQuizzesByAuthorId(Long authorId);

    List<Long> findAllQuizIdsByAuthorId(Long authorId);

    List<Quiz> findQuizzesByStudentId(Long studentId);

    List<Long> findAllClosedQuizIdsByAuthorId(Long authorId);

    List<Long> findAllNotPublishedQuizIdsByAuthorId(Long authorId);

    List<Long> findAllQuizIdsByStudentIdAndStudentQuizStatus(Long studentId, StudentQuizStatus studentQuizStatus);

    Integer findQuizzesNumberByAuthorId(Long authorId);

    // key: studentQuizStatus, value: number of students
    Map<StudentQuizStatus, Integer> findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(
            Long authorId, Long groupId, Long quizId);

    // key: teacherQuizStatus, value: number of quizzes
    Map<TeacherQuizStatus, Integer> FindQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId);

    // key: quizId, value: result
    Map<Long, Integer> findAllStudentResults(Long studentId);

    List<Long> findQuizIdsByStudentIdAndAttempt(Long studentId, Integer attempt);

    List<Long> findQuizIdsByStudentIdAndAuthorId(Long studentId, Long authorId);

    Integer findResultByStudentIdAndQuizId(Long studentId, Long quizId);

    LocalDateTime findSubmitDateByStudentIdAndQuizId(Long studentId, Long quizId);

    LocalDateTime findStartDateByStudentIdAndQuizId(Long studentId, Long quizId);

    LocalDateTime findFinishDateByStudentIdAndQuizId(Long studentId, Long quizId);

    Integer findAttemptByStudentIdAndQuizId(Long studentId, Long quizId);

    StudentQuizStatus findStudentQuizStatusByStudentIdAndQuizId(Long studentId, Long quizId);

    Long addQuiz(Quiz quiz);

    void editTeacherQuizStatusByQuizId(TeacherQuizStatus teacherQuizStatus, Long quizId);

    void editQuiz(Quiz quiz);

    void deleteUnpublishedQuiz(Long quizId);
}
