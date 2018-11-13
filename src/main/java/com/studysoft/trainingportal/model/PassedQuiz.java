package com.studysoft.trainingportal.model;

import java.time.Duration;
import java.time.LocalDateTime;

public class PassedQuiz {
    private Long quizId;
    private String quizName;
    private String description;
    private String explanation;
    private String authorName;
    private Integer result;
    private Integer score;
    private Integer questionsNumber;
    private Integer attempt;
    private Duration passingTime;
    private LocalDateTime submitDate;
    private LocalDateTime finishDate;
    private Duration timeSpent;

    public PassedQuiz() {
    }

    private PassedQuiz(PassedQuizBuilder builder) {
        this.quizId = builder.quizId;
        this.quizName = builder.quizName;
        this.description = builder.description;
        this.explanation = builder.explanation;
        this.authorName = builder.authorName;
        this.result = builder.result;
        this.score = builder.score;
        this.questionsNumber = builder.questionsNumber;
        this.attempt = builder.attempt;
        this.passingTime = builder.passingTime;
        this.submitDate = builder.submitDate;
        this.finishDate = builder.finishDate;
        this.timeSpent = builder.timeSpent;
    }


    public Long getQuizId() {
        return quizId;
    }

    public void setQuizId(Long quizId) {
        this.quizId = quizId;
    }

    public String getQuizName() {
        return quizName;
    }

    public void setQuizName(String quizName) {
        this.quizName = quizName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public Integer getResult() {
        return result;
    }

    public void setResult(Integer result) {
        this.result = result;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getQuestionsNumber() {
        return questionsNumber;
    }

    public void setQuestionsNumber(Integer questionsNumber) {
        this.questionsNumber = questionsNumber;
    }

    public Integer getAttempt() {
        return attempt;
    }

    public void setAttempt(Integer attempt) {
        this.attempt = attempt;
    }

    public Duration getPassingTime() {
        return passingTime;
    }

    public void setPassingTime(Duration passingTime) {
        this.passingTime = passingTime;
    }

    public LocalDateTime getSubmitDate() {
        return submitDate;
    }

    public void setSubmitDate(LocalDateTime submitDate) {
        this.submitDate = submitDate;
    }

    public LocalDateTime getFinishDate() {
        return finishDate;
    }

    public void setFinishDate(LocalDateTime finishDate) {
        this.finishDate = finishDate;
    }

    public Duration getTimeSpent() {
        return timeSpent;
    }

    public void setTimeSpent(Duration timeSpent) {
        this.timeSpent = timeSpent;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PassedQuiz that = (PassedQuiz) o;

        if (!quizId.equals(that.quizId)) return false;
        if (!quizName.equals(that.quizName)) return false;
        if (description != null ? !description.equals(that.description) : that.description != null) return false;
        if (explanation != null ? !explanation.equals(that.explanation) : that.explanation != null) return false;
        if (!authorName.equals(that.authorName)) return false;
        if (!result.equals(that.result)) return false;
        if (!score.equals(that.score)) return false;
        if (!questionsNumber.equals(that.questionsNumber)) return false;
        if (!attempt.equals(that.attempt)) return false;
        if (passingTime != null ? !passingTime.equals(that.passingTime) : that.passingTime != null) return false;
        if (!submitDate.equals(that.submitDate)) return false;
        if (!finishDate.equals(that.finishDate)) return false;
        return timeSpent != null ? timeSpent.equals(that.timeSpent) : that.timeSpent == null;
    }

    @Override
    public int hashCode() {
        int result1 = quizId.hashCode();
        result1 = 31 * result1 + quizName.hashCode();
        result1 = 31 * result1 + (description != null ? description.hashCode() : 0);
        result1 = 31 * result1 + (explanation != null ? explanation.hashCode() : 0);
        result1 = 31 * result1 + authorName.hashCode();
        result1 = 31 * result1 + result.hashCode();
        result1 = 31 * result1 + score.hashCode();
        result1 = 31 * result1 + questionsNumber.hashCode();
        result1 = 31 * result1 + attempt.hashCode();
        result1 = 31 * result1 + (passingTime != null ? passingTime.hashCode() : 0);
        result1 = 31 * result1 + submitDate.hashCode();
        result1 = 31 * result1 + finishDate.hashCode();
        result1 = 31 * result1 + (timeSpent != null ? timeSpent.hashCode() : 0);
        return result1;
    }

    @Override
    public String toString() {
        return "PassedQuiz{" +
                "quizId=" + quizId +
                ", quizName='" + quizName + '\'' +
                ", description='" + description + '\'' +
                ", explanation='" + explanation + '\'' +
                ", authorName='" + authorName + '\'' +
                ", result=" + result +
                ", score=" + score +
                ", questionsNumber=" + questionsNumber +
                ", attempt=" + attempt +
                ", passingTime=" + passingTime +
                ", submitDate=" + submitDate +
                ", finishDate=" + finishDate +
                ", timeSpent=" + timeSpent +
                '}';
    }

    public static final class PassedQuizBuilder {
        private Long quizId;
        private String quizName;
        private String description;
        private String explanation;
        private String authorName;
        private Integer result;
        private Integer score;
        private Integer questionsNumber;
        private Integer attempt;
        private Duration passingTime;
        private LocalDateTime submitDate;
        private LocalDateTime finishDate;
        private Duration timeSpent;

        public PassedQuizBuilder quizId(Long quizId) {
            this.quizId = quizId;
            return this;
        }

        public PassedQuizBuilder quizName(String quizName) {
            this.quizName = quizName;
            return this;
        }

        public PassedQuizBuilder description(String description) {
            this.description = description;
            return this;
        }

        public PassedQuizBuilder explanation(String explanation) {
            this.explanation = explanation;
            return this;
        }

        public PassedQuizBuilder authorName(String authorName) {
            this.authorName = authorName;
            return this;
        }

        public PassedQuizBuilder result(Integer result) {
            this.result = result;
            return this;
        }

        public PassedQuizBuilder score(Integer score) {
            this.score = score;
            return this;
        }

        public PassedQuizBuilder questionsNumber(Integer questionsNumber) {
            this.questionsNumber = questionsNumber;
            return this;
        }

        public PassedQuizBuilder attempt(Integer attempt) {
            this.attempt = attempt;
            return this;
        }

        public PassedQuizBuilder passingTime(Duration passingTime) {
            this.passingTime = passingTime;
            return this;
        }

        public PassedQuizBuilder submitDate(LocalDateTime submitDate) {
            this.submitDate = submitDate;
            return this;
        }

        public PassedQuizBuilder finishDate(LocalDateTime finishDate) {
            this.finishDate = finishDate;
            return this;
        }

        public PassedQuizBuilder timeSpent(Duration timeSpent) {
            this.timeSpent = timeSpent;
            return this;
        }

        public PassedQuiz build() {
            return new PassedQuiz(this);
        }
    }
}