package com.studysoft.trainingportal.dao;

import com.studysoft.trainingportal.model.Question;
import com.studysoft.trainingportal.model.enums.QuestionType;

import java.util.List;
import java.util.Map;

public interface QuestionDao {

    Question findQuestion(Long questionId);

    List<Question> findQuestions(Long quizId);

    List<Question> findQuestions(Long quizId, QuestionType questionType);

    // key: questionType, value: count of question type
    Map<QuestionType, Integer> findQuestionTypesAndCount(Long quizId);

    Long addQuestion(Question question);

    void editQuestion(Question question);

    void deleteQuestion(Long questionId);

    void deleteQuestions(Long quizId);
}
