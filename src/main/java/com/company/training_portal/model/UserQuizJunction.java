package com.company.training_portal.model;

import com.company.training_portal.model.enums.QuizStatus;

import java.time.LocalDateTime;

public class UserQuizJunction {

    private Long userQuizJunctionId;
    private Long userId;
    private Long quizId;
    private Integer result;
    private LocalDateTime finishDate;
    private LocalDateTime submitDate;
    private Integer reopenCounter;
    private QuizStatus quizStatus;

    private UserQuizJunction(UserQuizJunctionBuilder builder) {
        this.userQuizJunctionId = builder.userQuizJunctionId;
        this.userId = builder.userId;
        this.quizId = builder.quizId;
        this.result = builder.result;
        this.finishDate = builder.finishDate;
        this.submitDate = builder.submitDate;
        this.reopenCounter = builder.reopenCounter;
        this.quizStatus = builder.quizStatus;
    }

    public Long getUserQuizJunctionId() {
        return userQuizJunctionId;
    }

    public void setUserQuizJunctionId(Long userQuizJunctionId) {
        this.userQuizJunctionId = userQuizJunctionId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getQuizId() {
        return quizId;
    }

    public void setQuizId(Long quizId) {
        this.quizId = quizId;
    }

    public Integer getResult() {
        return result;
    }

    public void setResult(Integer result) {
        this.result = result;
    }

    public LocalDateTime getFinishDate() {
        return finishDate;
    }

    public void setFinishDate(LocalDateTime finishDate) {
        this.finishDate = finishDate;
    }

    public LocalDateTime getSubmitDate() {
        return submitDate;
    }

    public void setSubmitDate(LocalDateTime submitDate) {
        this.submitDate = submitDate;
    }

    public Integer getReopenCounter() {
        return reopenCounter;
    }

    public void setReopenCounter(Integer reopenCounter) {
        this.reopenCounter = reopenCounter;
    }

    public QuizStatus getQuizStatus() {
        return quizStatus;
    }

    public void setQuizStatus(QuizStatus quizStatus) {
        this.quizStatus = quizStatus;
    }

    @Override
    public String toString() {
        return "UserQuizJunction{" +
                "userQuizJunctionId=" + userQuizJunctionId +
                ", userId=" + userId +
                ", quizId=" + quizId +
                ", result=" + result +
                ", finishDate=" + finishDate +
                ", submitDate=" + submitDate +
                ", reopenCounter=" + reopenCounter +
                ", quizStatus=" + quizStatus +
                '}';
    }

    public static final class UserQuizJunctionBuilder {

        private Long userQuizJunctionId;
        private Long userId;
        private Long quizId;
        private Integer result;
        private LocalDateTime finishDate;
        private LocalDateTime submitDate;
        private Integer reopenCounter;
        private QuizStatus quizStatus;

        public UserQuizJunctionBuilder() {
        }

        public UserQuizJunctionBuilder userQuizJunctionId(Long userQuizJunctionId) {
            this.userQuizJunctionId = userQuizJunctionId;
            return this;
        }

        public UserQuizJunctionBuilder userId(Long userId) {
            this.userId = userId;
            return this;
        }

        public UserQuizJunctionBuilder quizId(Long quizId) {
            this.quizId = quizId;
            return this;
        }

        public UserQuizJunctionBuilder result(Integer result) {
            this.result = result;
            return this;
        }

        public UserQuizJunctionBuilder finishDate(LocalDateTime finishDate) {
            this.finishDate = finishDate;
            return this;
        }

        public UserQuizJunctionBuilder submitDate(LocalDateTime submitDate) {
            this.submitDate = submitDate;
            return this;
        }

        public UserQuizJunctionBuilder reopenCounter(Integer reopenCounter) {
            this.reopenCounter = reopenCounter;
            return this;
        }

        public UserQuizJunctionBuilder quizStatus(QuizStatus quizStatus) {
            this.quizStatus = quizStatus;
            return this;
        }

        public UserQuizJunction build() {
            return new UserQuizJunction(this);
        }
    }
}
