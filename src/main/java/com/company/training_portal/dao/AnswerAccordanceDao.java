package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerAccordance;

public interface AnswerAccordanceDao {

    AnswerAccordance findAnswerAccordanceByQuestionId(Long questionId);

    Long addAnswerAccordance(AnswerAccordance answerAccordance);

    void editAnswerAccordance(AnswerAccordance answerAccordance);

    void deleteAnswerAccordance(Long questionId);
}
