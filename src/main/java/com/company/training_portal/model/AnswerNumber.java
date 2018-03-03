package com.company.training_portal.model;

public class AnswerNumber {

    private Long answerNumberId;
    private Long questionId;
    private Integer correct;

    private AnswerNumber(AnswerNumberBuilder builder) {
        this.answerNumberId = builder.answerNumberId;
        this.questionId = builder.questionId;
        this.correct = builder.correct;
    }

    public Long getAnswerNumberId() {
        return answerNumberId;
    }

    public void setAnswerNumberId(Long answerNumberId) {
        this.answerNumberId = answerNumberId;
    }

    public Long getQuestionId() {
        return questionId;
    }


    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public Integer getCorrect() {
        return correct;
    }

    public void setCorrect(Integer correct) {
        this.correct = correct;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        AnswerNumber that = (AnswerNumber) o;

        if (!answerNumberId.equals(that.answerNumberId)) return false;
        if (!questionId.equals(that.questionId)) return false;
        return correct.equals(that.correct);
    }

    @Override
    public int hashCode() {
        int result = answerNumberId.hashCode();
        result = 31 * result + questionId.hashCode();
        result = 31 * result + correct.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "AnswerNumber{" +
                "answerNumberId=" + answerNumberId +
                ", questionId=" + questionId +
                ", correct='" + correct + '\'' +
                '}';
    }

    public static final class AnswerNumberBuilder {

        private Long answerNumberId;
        private Long questionId;
        private Integer correct;

        public AnswerNumberBuilder() {
        }

        public AnswerNumberBuilder answerNumberId(Long answerNumberId) {
            this.answerNumberId = answerNumberId;
            return this;
        }

        public AnswerNumberBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerNumberBuilder correct(Integer correct) {
            this.correct = correct;
            return this;
        }

        public AnswerNumber build() {
            return new AnswerNumber(this);
        }
    }
}
