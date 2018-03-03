package com.company.training_portal.dao;

import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.QuizStatus;

import java.util.Collection;

public interface QuizDao {

    Quiz findQuizByQuizId(Long quizId);

    Collection<Quiz> findAllQuizzes();

    Collection<String> findAllQuizNames();

    Collection<Quiz> findAllQuizzesByAuthorId(Long authorId);

    Collection<String> findAllQuizNamesByAuthorId(Long authorId);

    Collection<Quiz> findAllQuizzesByStudentId(Long studentId);

    Collection<String> findAllQuizNamesByStudentId(Long studentId);

    Collection<String> findAllClosedQuizNamesByAuthorId(Long authorId);

    Collection<Quiz> findAllNotPublishedQuizzesByAuthorId(Long authorId);

    Collection<String> findAllQuizNamesByStudentIdAndQuizStatus (Long studentId, QuizStatus quizStatus);

    Integer findQuizzesNumberByAuthorId(Long authorId);

    Integer findClosedQuizzesNumberByAuthorId(Long authorId);

    Collection<String> findQuizNamesByStudentIdAndReopenCounter(Long studentId, Integer reopenCounter);

    Collection<String> findQuizzesByStudentIdAndAuthorId(Long studentId, Long authorId);

    Long addQuiz(Quiz quiz);

    void editQuiz(Quiz quiz);

    void deleteQuiz(Long quizId);
}
