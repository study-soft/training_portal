package com.company.training_portal.dao;

import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.QuizStatus;

import java.util.Collection;
import java.util.List;
import java.util.Map;

public interface QuizDao {

    Quiz findQuizByQuizId(Long quizId);

    List<Quiz> findAllQuizzes();

    List<String> findAllQuizNames();

    List<Quiz> findAllQuizzesByAuthorId(Long authorId);

    List<String> findAllQuizNamesByAuthorId(Long authorId);

    List<Quiz> findAllQuizzesByStudentId(Long studentId);

    List<String> findAllQuizNamesByStudentId(Long studentId);

    List<String> findAllClosedQuizNamesByAuthorId(Long authorId);

    List<Quiz> findAllNotPublishedQuizzesByAuthorId(Long authorId);

    List<String> findAllQuizNamesByStudentIdAndQuizStatus(Long studentId, QuizStatus quizStatus);

    Integer findQuizzesNumberByAuthorId(Long authorId);

    // key: quizStatus, value: number of students
    Map<QuizStatus, Integer> findQuizzesNumberByAuthorIdWithQuizStatus(Long authorId);

    // key: quiz's name, value: result
    Map<String, Integer> findAllStudentResults(Long userId);

    List<String> findQuizNamesByStudentIdAndReopenCounter(Long studentId, Integer reopenCounter);

    List<String> findQuizNamesByStudentIdAndAuthorId(Long studentId, Long authorId);

    Long addQuiz(Quiz quiz);

    void editQuiz(Quiz quiz);

    void deleteQuiz(Long quizId);
}
