package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerNumber;

public interface AnswerNumberDao {

    AnswerNumber findAnswerNumber(Long questionId);

    void addAnswerNumber(AnswerNumber answerNumber);

    void editAnswerNumber(AnswerNumber answerNumber);

    void deleteAnswerNumber(Long questionId);
}
