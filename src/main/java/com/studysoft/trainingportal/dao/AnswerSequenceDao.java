package com.studysoft.trainingportal.dao;

import com.studysoft.trainingportal.model.AnswerSequence;

public interface AnswerSequenceDao {

    AnswerSequence findAnswerSequence(Long questionId);

    void addAnswerSequence(AnswerSequence answerSequence);

    void editAnswerSequence(AnswerSequence answerSequence);

    void deleteAnswerSequence(Long questionId);
}
