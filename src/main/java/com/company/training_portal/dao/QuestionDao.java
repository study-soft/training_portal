package com.company.training_portal.dao;

import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;

import java.util.Collection;

public interface QuestionDao {

    Question findQuestionById(Long questionId);

    Collection<Question> findQuestionsByQuizId(Long quizId);

    Collection<Question> findQuestionsByQuizIdAndQuestionType(Long quizId, QuestionType questionType);

    Collection<Question> findQuestionsByQuizIdAndScore(Long quizId, Integer score);

    Integer findQuestionsNumberByQuizId(Long quizId);

    Integer findQuizScoreByQuizId(Long quizId);

    Long addQuestion(Question question);

    void editQuestion(Question question);

    void deleteQuestion(Long questionId);
}
