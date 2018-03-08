package com.company.training_portal.model;

import java.util.Map;

public class AnswerAccordance {

    private Long questionId;
    private Map<String, String> correctMap;

    private AnswerAccordance(AnswerAccordanceBuilder builder) {
        this.questionId = builder.questionId;
        this.correctMap = builder.correctMap;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public Map<String, String> getCorrectMap() {
        return correctMap;
    }

    public void setCorrectMap(Map<String, String> correctMap) {
        this.correctMap = correctMap;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        AnswerAccordance that = (AnswerAccordance) o;

        if (questionId != null ? !questionId.equals(that.questionId) : that.questionId != null) return false;
        return correctMap != null ? correctMap.equals(that.correctMap) : that.correctMap == null;
    }

    @Override
    public int hashCode() {
        int result = questionId != null ? questionId.hashCode() : 0;
        result = 31 * result + (correctMap != null ? correctMap.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "AnswerAccordance{" +
                "questionId=" + questionId +
                ", correctMap=" + correctMap +
                '}';
    }

    public static final class AnswerAccordanceBuilder {

        private Long questionId;
        private Map<String, String> correctMap;

        public AnswerAccordanceBuilder() {
        }

        public AnswerAccordanceBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerAccordanceBuilder correctMap(Map<String, String> correctMap) {
            this.correctMap = correctMap;
            return this;
        }

        public AnswerAccordance build() {
            return new AnswerAccordance(this);
        }
    }
}
