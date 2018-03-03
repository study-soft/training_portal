package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerNumber;

public interface AnswerNumberDao {

    AnswerNumber findAnswerNumberByQuestionId(Long questionId);

    Long addAnswerNumber(AnswerNumber answerNumber);

    void editAnswerNumber(AnswerNumber answerNumber);

    void deleteAnswerNumber(Long answerNumberId);
}
