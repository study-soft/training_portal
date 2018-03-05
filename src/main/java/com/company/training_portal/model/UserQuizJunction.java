package com.company.training_portal.model;

import com.company.training_portal.model.enums.StudentQuizStatus;

import java.time.LocalDateTime;

public class UserQuizJunction {

    private Long userQuizJunctionId;
    private Long userId;
    private Long quizId;
    private Integer result;
    private LocalDateTime submitDate;
    private LocalDateTime finishDate;
    private Integer reopenCounter;
    private StudentQuizStatus studentQuizStatus;

    private UserQuizJunction(UserQuizJunctionBuilder builder) {
        this.userQuizJunctionId = builder.userQuizJunctionId;
        this.userId = builder.userId;
        this.quizId = builder.quizId;
        this.result = builder.result;
        this.submitDate = builder.submitDate;
        this.finishDate = builder.finishDate;
        this.reopenCounter = builder.reopenCounter;
        this.studentQuizStatus = builder.studentQuizStatus;
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

    public StudentQuizStatus getStudentQuizStatus() {
        return studentQuizStatus;
    }

    public void setStudentQuizStatus(StudentQuizStatus studentQuizStatus) {
        this.studentQuizStatus = studentQuizStatus;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        UserQuizJunction that = (UserQuizJunction) o;

        if (!userQuizJunctionId.equals(that.userQuizJunctionId)) return false;
        if (!userId.equals(that.userId)) return false;
        if (!quizId.equals(that.quizId)) return false;
        if (result != null ? !result.equals(that.result) : that.result != null) return false;
        if (submitDate != null ? !submitDate.equals(that.submitDate) : that.submitDate != null) return false;
        if (finishDate != null ? !finishDate.equals(that.finishDate) : that.finishDate != null) return false;
        if (reopenCounter != null ? !reopenCounter.equals(that.reopenCounter) : that.reopenCounter != null)
            return false;
        return studentQuizStatus == that.studentQuizStatus;
    }

    @Override
    public int hashCode() {
        int result1 = userQuizJunctionId.hashCode();
        result1 = 31 * result1 + userId.hashCode();
        result1 = 31 * result1 + quizId.hashCode();
        result1 = 31 * result1 + (result != null ? result.hashCode() : 0);
        result1 = 31 * result1 + (submitDate != null ? submitDate.hashCode() : 0);
        result1 = 31 * result1 + (finishDate != null ? finishDate.hashCode() : 0);
        result1 = 31 * result1 + (reopenCounter != null ? reopenCounter.hashCode() : 0);
        result1 = 31 * result1 + studentQuizStatus.hashCode();
        return result1;
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
                ", studentQuizStatus=" + studentQuizStatus +
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
        private StudentQuizStatus studentQuizStatus;

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

        public UserQuizJunctionBuilder quizStatus(StudentQuizStatus studentQuizStatus) {
            this.studentQuizStatus = studentQuizStatus;
            return this;
        }

        public UserQuizJunction build() {
            return new UserQuizJunction(this);
        }
    }
}
