package com.company.training_portal.model;

import java.util.List;

public class AnswerSequence {

    private Long answerSequenceId;
    private Long questionId;
    private List<String> correctList;

    public AnswerSequence(AnswerSequenceBuilder builder) {
        this.answerSequenceId = builder.answerSequenceId;
        this.questionId = builder.questionId;
        this.correctList = builder.correctList;
    }

    public Long getAnswerSequenceId() {
        return answerSequenceId;
    }

    public void setAnswerSequenceId(Long answerSequenceId) {
        this.answerSequenceId = answerSequenceId;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public List<String> getCorrectList() {
        return correctList;
    }

    public void setCorrectList(List<String> correctList) {
        this.correctList = correctList;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        AnswerSequence that = (AnswerSequence) o;

        if (answerSequenceId != null ? !answerSequenceId.equals(that.answerSequenceId) : that.answerSequenceId != null)
            return false;
        if (questionId != null ? !questionId.equals(that.questionId) : that.questionId != null) return false;
        return correctList != null ? correctList.equals(that.correctList) : that.correctList == null;
    }

    @Override
    public int hashCode() {
        int result = answerSequenceId != null ? answerSequenceId.hashCode() : 0;
        result = 31 * result + (questionId != null ? questionId.hashCode() : 0);
        result = 31 * result + (correctList != null ? correctList.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "AnswerSequence{" +
                "answerSequenceId=" + answerSequenceId +
                ", questionId=" + questionId +
                ", correctList=" + correctList +
                '}';
    }

    public static final class AnswerSequenceBuilder {

        private Long answerSequenceId;
        private Long questionId;
        private List<String> correctList;

        public AnswerSequenceBuilder() {
        }

        public AnswerSequenceBuilder answerSequenceId(Long answerSequenceId) {
            this.answerSequenceId = answerSequenceId;
            return this;
        }

        public AnswerSequenceBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerSequenceBuilder setCorrectList(List<String> correctList) {
            this.correctList = correctList;
            return this;
        }

        public AnswerSequence build() {
            return new AnswerSequence(this);
        }
    }
}
