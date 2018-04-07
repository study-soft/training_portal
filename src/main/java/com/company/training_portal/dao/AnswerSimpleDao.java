package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerSimple;

import java.util.List;

public interface AnswerSimpleDao {

    AnswerSimple findAnswerSimple(Long answerSimpleId);

    List<AnswerSimple> findAnswersSimple(Long questionId);

    Long addAnswerSimple(AnswerSimple answerSimple);

    // No usages
    void editAnswerSimple(AnswerSimple answerSimple);

    void deleteAnswersSimple(Long questionId);
}
