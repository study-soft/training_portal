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

    List<String> findAllQuizNames();

    List<Quiz> findAllQuizzesByAuthorId(Long authorId);

    List<String> findAllQuizNamesByAuthorId(Long authorId);

    List<String> findAllQuizNamesByStudentId(Long studentId);

    List<String> findAllClosedQuizNamesByAuthorId(Long authorId);

    List<Quiz> findAllNotPublishedQuizzesByAuthorId(Long authorId);

    List<String> findAllQuizNamesByStudentIdAndStudentQuizStatus(Long studentId, StudentQuizStatus studentQuizStatus);

    Integer findQuizzesNumberByAuthorId(Long authorId);

    // key: studentQuizStatus, value: number of students
    Map<StudentQuizStatus, Integer> findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(
            Long authorId, Long groupId, StudentQuizStatus studentQuizStatus);

    // key: teacherQuizStatus, value: number of quizzes
    Map<TeacherQuizStatus, Integer> FindQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId);

    // key: quiz's name, value: result
    Map<String, Integer> findAllStudentResults(Long studentId);

    List<String> findQuizNamesByStudentIdAndReopenCounter(Long studentId, Integer reopenCounter);

    List<String> findQuizNamesByStudentIdAndAuthorId(Long studentId, Long authorId);

    Integer findResultByStudentIdAndQuizId(Long studentId, Long quizId);

    LocalDateTime findSubmitDateByStudentIdAndQuizId(Long studentId, Long quizId);

    LocalDateTime findFinishDateByStudentIdAndQuizId(Long studentId, Long quizId);

    Integer findReopenCounterByStudentIdAndQuizId(Long studentId, Long quizId);

    StudentQuizStatus findStudentQuizStatusByStudentIdAndQuizId(Long studentId, Long quizId);

    Long addQuiz(Quiz quiz);

    void editTeacherQuizStatusByQuizId(TeacherQuizStatus teacherQuizStatus, Long quizId);

    void editQuiz(Quiz quiz);

    void deleteQuiz(Long quizId);
}
