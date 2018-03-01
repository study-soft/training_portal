package com.company.training_portal.model;

public class AnswerSimple {

    private Long answerSimpleId;
    private Long questionId;
    private String body;
    private boolean correct;

    private AnswerSimple(AnswerSimpleBuilder builder) {
        this.answerSimpleId = builder.answerSimpleId;
        this.questionId = builder.questionId;
        this.body = builder.body;
        this.correct = builder.correct;
    }

    public Long getAnswerSimpleId() {
        return answerSimpleId;
    }

    public void setAnswerSimpleId(Long answerSimpleId) {
        this.answerSimpleId = answerSimpleId;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    @Override
    public String toString() {
        return "AnswerSimple{" +
                "answerSimpleId=" + answerSimpleId +
                ", questionId=" + questionId +
                ", body='" + body + '\'' +
                ", correct=" + correct +
                '}';
    }

    public static final class AnswerSimpleBuilder {
        private Long answerSimpleId;
        private Long questionId;
        private String body;
        private boolean correct;

        public AnswerSimpleBuilder() {
        }

        public AnswerSimpleBuilder answerSimpleId(Long answerSimpleId) {
            this.answerSimpleId = answerSimpleId;
            return this;
        }

        public AnswerSimpleBuilder questionId(Long questionId) {
            this.questionId = questionId;
            return this;
        }

        public AnswerSimpleBuilder body(String body) {
            this.body = body;
            return this;
        }

        public AnswerSimpleBuilder correct(boolean correct) {
            this.correct = correct;
            return this;
        }

        public AnswerSimple build() {
            return new AnswerSimple(this);
        }
    }
}
