package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerSequence;

public interface AnswerSequenceDao {

    AnswerSequence findAnswerSequence(Long questionId);

    void addAnswerSequence(AnswerSequence answerSequence);

    void editAnswerSequence(AnswerSequence answerSequence);

    void deleteAnswerSequence(Long questionId);
}
