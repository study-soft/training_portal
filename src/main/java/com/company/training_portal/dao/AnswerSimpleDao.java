package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerSimple;

import java.util.List;

public interface AnswerSimpleDao {

    AnswerSimple findAnswerSimpleByAnswerSimpleId(Long answerSimpleId);

    List<AnswerSimple> findAllAnswersSimpleByQuestionId(Long questionId);

    Long addAnswerSimple(AnswerSimple answerSimple);

    void editAnswerSimple(AnswerSimple answerSimple);

    void deleteAnswerSimple(Long answerSimpleId);
}
