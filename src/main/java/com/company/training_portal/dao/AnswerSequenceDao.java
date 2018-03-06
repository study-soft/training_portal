package com.company.training_portal.dao;

import com.company.training_portal.model.AnswerSequence;

public interface AnswerSequenceDao {

    AnswerSequence findAnswerSequenceByQuestionId(Long questionId);

    Long addAnswerSequence(AnswerSequence answerSequence);

    void editAnswerSequence(AnswerSequence answerSequence);

    void deleteAnswerSequence(Long answerSequenceId);
}
