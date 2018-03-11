package com.company.training_portal.model;

import java.util.List;

public class AnswerSequence {

    private Long questionId;
    private List<String> correctList;

    private AnswerSequence(AnswerSequenceBuilder builder) {
        this.questionId = builder.questionId;
        this.correctList = builder.correctList;
    }

    public AnswerSequence() {
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

        if (questionId != null ? !questionId.equals(that.questionId) : that.questionId != null) return false;
        return correctList != null ? correctList.equals(that.correctList) : that.correctList == null;
    }

    @Override
    public int hashCode() {
        int result = questionId != null ? questionId.hashCode() : 0;
        result = 31 * result + (correctList != null ? correctList.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "AnswerSequence{" +
                "questionId=" + questionId +
                ", correctList=" + correctList +
                '}';
    }

    public static final class AnswerSequenceBuilder {

        private Long questionId;
        private List<String> correctList;

        public AnswerSequenceBuilder() {
        }

        public AnswerSequenceBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerSequenceBuilder correctList(List<String> correctList) {
            this.correctList = correctList;
            return this;
        }

        public AnswerSequence build() {
            return new AnswerSequence(this);
        }
    }
}
