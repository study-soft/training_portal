package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerSimple;

import java.util.Collection;

public interface AnswerSimpleDao {

    Collection<AnswerSimple> findAllAnswersSimpleByQuestionId(Long questionId);

    Long addAnswerSimple(AnswerSimple answerSimple);

    void editAnswerSimple(AnswerSimple answerSimple);

    void deleteAnswerSimple(Long answerSimpleId);
}
