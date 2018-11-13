package com.studysoft.trainingportal.model;

import java.util.List;

public class AnswerAccordance {

    private Long questionId;
    private List<String> leftSide;
    private List<String> rightSide;

    private AnswerAccordance(AnswerAccordanceBuilder builder) {
        this.questionId = builder.questionId;
        this.leftSide = builder.leftSide;
        this.rightSide = builder.rightSide;
    }

    public AnswerAccordance() {
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public List<String> getLeftSide() {
        return leftSide;
    }

    public void setLeftSide(List<String> leftSide) {
        this.leftSide = leftSide;
    }

    public List<String> getRightSide() {
        return rightSide;
    }

    public void setRightSide(List<String> rightSide) {
        this.rightSide = rightSide;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        AnswerAccordance that = (AnswerAccordance) o;

        if (!questionId.equals(that.questionId)) return false;
        if (!leftSide.equals(that.leftSide)) return false;
        return rightSide.equals(that.rightSide);
    }

    @Override
    public int hashCode() {
        int result = questionId.hashCode();
        result = 31 * result + leftSide.hashCode();
        result = 31 * result + rightSide.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "AnswerAccordance{" +
                "questionId=" + questionId +
                ", leftSide=" + leftSide +
                ", rightSide=" + rightSide +
                '}';
    }

    public static final class AnswerAccordanceBuilder {

        private Long questionId;
        private List<String> leftSide;
        private List<String> rightSide;


        public AnswerAccordanceBuilder() {
        }

        public AnswerAccordanceBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerAccordanceBuilder leftSide(List<String> leftSide) {
            this.leftSide = leftSide;
            return this;
        }

        public AnswerAccordanceBuilder rightSide(List<String> rightSide) {
            this.rightSide = rightSide;
            return this;
        }

        public AnswerAccordance build() {
            return new AnswerAccordance(this);
        }
    }
}
