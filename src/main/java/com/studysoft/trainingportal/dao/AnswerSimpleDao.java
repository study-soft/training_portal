package com.studysoft.trainingportal.dao;

import com.studysoft.trainingportal.model.AnswerSimple;

import java.util.List;

public interface AnswerSimpleDao {

    AnswerSimple findAnswerSimple(Long answerSimpleId);

    List<AnswerSimple> findAnswersSimple(Long questionId);

    Long addAnswerSimple(AnswerSimple answerSimple);

    // No usages
    void editAnswerSimple(AnswerSimple answerSimple);

    void deleteAnswersSimple(Long questionId);
}
