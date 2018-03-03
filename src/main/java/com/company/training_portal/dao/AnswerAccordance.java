package com.company.training_portal.dao;

public interface AnswerAccordance {

    AnswerAccordance findAnswerAccordanceByQuestionId(Long quizId);

    Long addAnswerAccordance(AnswerAccordance answerAccordance);

    void editAnswerAccordance(AnswerAccordance answerAccordance);

    void deleteAnswerAccordance(Long answerAccordanceId);
}
