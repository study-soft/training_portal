package com.company.training_portal.model;

public class AnswerSpace {

    private Long answerSpaceId;
    private Long questionId;
    private String studentAnswer;

    private AnswerSpace(AnswerSpaceBuilder builder) {
        this.answerSpaceId = builder.answerSpaceId;
        this.questionId = builder.questionId;
        this.studentAnswer = builder.studentAnswer;
    }

    public Long getAnswerSpaceId() {
        return answerSpaceId;
    }

    public void setAnswerSpaceId(Long answerSpaceId) {
        this.answerSpaceId = answerSpaceId;
    }

    public Long getQuestionId() {
        return questionId;
    }


    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public String getStudentAnswer() {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer) {
        this.studentAnswer = studentAnswer;
    }

    @Override
    public String toString() {
        return "AnswerSpace{" +
                "answerSpaceId=" + answerSpaceId +
                ", questionId=" + questionId +
                ", studentAnswer='" + studentAnswer + '\'' +
                '}';
    }

    public static final class AnswerSpaceBuilder {

        private Long answerSpaceId;
        private Long questionId;
        private String studentAnswer;

        public AnswerSpaceBuilder() {
        }

        public AnswerSpaceBuilder answerSpaceId(Long answerSpaceId) {
            this.answerSpaceId = answerSpaceId;
            return this;
        }

        public AnswerSpaceBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerSpaceBuilder studentAnswer(String studentAnswer) {
            this.studentAnswer = studentAnswer;
            return this;
        }

        public AnswerSpace build() {
            return new AnswerSpace(this);
        }
    }
}
