package com.company.training_portal.model;

import java.time.Duration;
import java.time.LocalDateTime;

public class OpenedQuiz {
    private Long quizId;
    private String quizName;
    private String description;
    private Duration passingTime;
    private String authorName;
    private Integer questionsNumber;
    private Integer score;
    private LocalDateTime submitDate;

    public OpenedQuiz() {
    }

    private OpenedQuiz(OpenedQuizBuilder builder) {
        this.quizId = builder.quizId;
        this.quizName = builder.quizName;
        this.description = builder.description;
        this.passingTime = builder.passingTime;
        this.authorName = builder.authorName;
        this.questionsNumber = builder.questionsNumber;
        this.score = builder.score;
        this.submitDate = builder.submitDate;
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

    public Duration getPassingTime() {
        return passingTime;
    }

    public void setPassingTime(Duration passingTime) {
        this.passingTime = passingTime;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public Integer getQuestionsNumber() {
        return questionsNumber;
    }

    public void setQuestionsNumber(Integer questionsNumber) {
        this.questionsNumber = questionsNumber;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public LocalDateTime getSubmitDate() {
        return submitDate;
    }

    public void setSubmitDate(LocalDateTime submitDate) {
        this.submitDate = submitDate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OpenedQuiz that = (OpenedQuiz) o;

        if (!quizId.equals(that.quizId)) return false;
        if (!quizName.equals(that.quizName)) return false;
        if (description != null ? !description.equals(that.description) : that.description != null) return false;
        if (!passingTime.equals(that.passingTime)) return false;
        if (!authorName.equals(that.authorName)) return false;
        if (!questionsNumber.equals(that.questionsNumber)) return false;
        if (!score.equals(that.score)) return false;
        return submitDate.equals(that.submitDate);
    }

    @Override
    public int hashCode() {
        int result = quizId.hashCode();
        result = 31 * result + quizName.hashCode();
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + passingTime.hashCode();
        result = 31 * result + authorName.hashCode();
        result = 31 * result + questionsNumber.hashCode();
        result = 31 * result + score.hashCode();
        result = 31 * result + submitDate.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "OpenedQuiz{" +
                "quizId=" + quizId +
                ", quizName='" + quizName + '\'' +
                ", description='" + description + '\'' +
                ", passingTime=" + passingTime +
                ", authorName='" + authorName + '\'' +
                ", questionsNumber=" + questionsNumber +
                ", score=" + score +
                ", submitDate=" + submitDate +
                '}';
    }

    public static final class OpenedQuizBuilder {
        private Long quizId;
        private String quizName;
        private String description;
        private Duration passingTime;
        private String authorName;
        private Integer questionsNumber;
        private Integer score;
        private LocalDateTime submitDate;

        public OpenedQuizBuilder quizId(Long quizId) {
            this.quizId = quizId;
            return this;
        }

        public OpenedQuizBuilder quizName(String quizName) {
            this.quizName = quizName;
            return this;
        }

        public OpenedQuizBuilder description(String description) {
            this.description = description;
            return this;
        }

        public OpenedQuizBuilder passingTime(Duration passingTime) {
            this.passingTime = passingTime;
            return this;
        }

        public OpenedQuizBuilder authorName(String authorName) {
            this.authorName = authorName;
            return this;
        }

        public OpenedQuizBuilder questionsNumber(Integer questionsNumber) {
            this.questionsNumber = questionsNumber;
            return this;
        }

        public OpenedQuizBuilder score(Integer score) {
            this.score = score;
            return this;
        }

        public OpenedQuizBuilder submitDate(LocalDateTime submitDate) {
            this.submitDate = submitDate;
            return this;
        }

        public OpenedQuiz build() {
            return new OpenedQuiz(this);
        }
    }
}