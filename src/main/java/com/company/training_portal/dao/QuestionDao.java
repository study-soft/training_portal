package com.company.training_portal.dao;

import com.company.training_portal.model.Question;
import com.company.training_portal.model.enums.QuestionType;

import java.util.List;
import java.util.Map;

public interface QuestionDao {

    Question findQuestionByQuestionId(Long questionId);

    List<Question> findQuestionsByQuizId(Long quizId);

    List<Question> findQuestionsByQuizIdAndQuestionType(Long quizId, QuestionType questionType);

    // key: questionType, value: count of question type
    Map<QuestionType, Integer> findQuestionTypesAndCountByQuizId(Long quizId);

    List<Question> findQuestionsByQuizIdAndScore(Long quizId, Integer score);

    Integer findQuestionsNumberByQuizId(Long quizId);

    Integer findQuizScoreByQuizId(Long quizId);

    Long addQuestion(Question question);

    void editQuestion(Question question);

    void deleteQuestion(Long questionId);
}
