package com.company.training_portal.dao;

import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;

import java.util.List;

public interface QuestionDao {

    Question findQuestionById(Long questionId);

    List<Question> findQuestionsByQuizId(Long quizId);

    List<Question> findQuestionsByQuizIdAndQuestionType(Long quizId, QuestionType questionType);

    List<Question> findQuestionsByQuizIdAndScore(Long quizId, Integer score);

    Integer findQuestionsNumberByQuizId(Long quizId);

    Integer findQuizScoreByQuizId(Long quizId);

    Long addQuestion(Question question);

    void editQuestion(Question question);

    void deleteQuestion(Long questionId);
}
