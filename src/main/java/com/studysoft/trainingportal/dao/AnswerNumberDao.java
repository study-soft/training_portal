package com.studysoft.trainingportal.dao;

import com.studysoft.trainingportal.model.AnswerNumber;

public interface AnswerNumberDao {

    AnswerNumber findAnswerNumber(Long questionId);

    void addAnswerNumber(AnswerNumber answerNumber);

    void editAnswerNumber(AnswerNumber answerNumber);

    void deleteAnswerNumber(Long questionId);
}
