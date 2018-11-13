package com.studysoft.trainingportal.dao;

import com.studysoft.trainingportal.model.AnswerAccordance;

public interface AnswerAccordanceDao {

    AnswerAccordance findAnswerAccordance(Long questionId);

    void addAnswerAccordance(AnswerAccordance answerAccordance);

    void editAnswerAccordance(AnswerAccordance answerAccordance);

    void deleteAnswerAccordance(Long questionId);
}
