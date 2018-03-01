package com.company.training_portal.model;

import java.util.Map;

public class AnswerAccordance {

    private Long answerAccordanceId;
    private Long questionId;
    private Map<String, String> correctMap;

    private AnswerAccordance(AnswerAccordanceBuilder builder) {
        this.answerAccordanceId = builder.answerAccordanceId;
        this.questionId = builder.questionId;
        this.correctMap = builder.correctMap;
    }

    public Long getAnswerAccordanceId() {
        return answerAccordanceId;
    }

    public void setAnswerAccordanceId(Long answerAccordanceId) {
        this.answerAccordanceId = answerAccordanceId;
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

        if (answerAccordanceId != null ? !answerAccordanceId.equals(that.answerAccordanceId) : that.answerAccordanceId != null)
            return false;
        if (questionId != null ? !questionId.equals(that.questionId) : that.questionId != null) return false;
        return correctMap != null ? correctMap.equals(that.correctMap) : that.correctMap == null;
    }

    @Override
    public int hashCode() {
        int result = answerAccordanceId != null ? answerAccordanceId.hashCode() : 0;
        result = 31 * result + (questionId != null ? questionId.hashCode() : 0);
        result = 31 * result + (correctMap != null ? correctMap.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "AnswerAccordance{" +
                "answerAccordanceId=" + answerAccordanceId +
                ", questionId=" + questionId +
                ", correctMap=" + correctMap +
                '}';
    }

    public static final class AnswerAccordanceBuilder {

        private Long answerAccordanceId;
        private Long questionId;
        private Map<String, String> correctMap;

        public AnswerAccordanceBuilder() {
        }

        public AnswerAccordanceBuilder answerAccordanceId(Long answerAccordanceId) {
            this.answerAccordanceId = answerAccordanceId;
            return this;
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
