package com.company.training_portal.model;

import java.time.Duration;
import java.time.LocalDate;

public class Quiz {

    private Long quizId;
    private String name;
    private String description;
    private String explanation;
    private LocalDate creationDate;
    private Duration passingTime;
    private Long authorId;
    private Boolean published;

    private Quiz(QuizBuilder builder) {
        this.quizId = builder.quizId;
        this.name = builder.name;
        this.description = builder.description;
        this.explanation = builder.explanation;
        this.creationDate = builder.creationDate;
        this.passingTime = builder.passingTime;
        this.authorId = builder.authorId;
        this.published = builder.published;
    }

    public Long getQuizId() {
        return quizId;
    }

    public void setQuizId(Long quizId) {
        this.quizId = quizId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public LocalDate getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDate creationDate) {
        this.creationDate = creationDate;
    }

    public Duration getPassingTime() {
        return passingTime;
    }

    public void setPassingTime(Duration passingTime) {
        this.passingTime = passingTime;
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }

    public Boolean isPublished() {
        return published;
    }

    public void setPublished(Boolean published) {
        this.published = published;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Quiz quiz = (Quiz) o;

        if (!quizId.equals(quiz.quizId)) return false;
        if (!name.equals(quiz.name)) return false;
        if (description != null ? !description.equals(quiz.description) : quiz.description != null) return false;
        if (explanation != null ? !explanation.equals(quiz.explanation) : quiz.explanation != null) return false;
        if (!creationDate.equals(quiz.creationDate)) return false;
        if (!passingTime.equals(quiz.passingTime)) return false;
        if (!authorId.equals(quiz.authorId)) return false;
        return published.equals(quiz.published);
    }

    @Override
    public int hashCode() {
        int result = quizId.hashCode();
        result = 31 * result + name.hashCode();
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + (explanation != null ? explanation.hashCode() : 0);
        result = 31 * result + creationDate.hashCode();
        result = 31 * result + passingTime.hashCode();
        result = 31 * result + authorId.hashCode();
        result = 31 * result + published.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "Quiz{" +
                "quizId=" + quizId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", explanation='" + explanation + '\'' +
                ", creationDate=" + creationDate +
                ", passingTime=" + passingTime +
                ", authorId=" + authorId +
                ", published=" + published +
                '}';
    }

    public static final class QuizBuilder {

        private Long quizId;
        private String name;
        private String description;
        private String explanation;
        private LocalDate creationDate;
        private Duration passingTime;
        private Long authorId;
        private Boolean published;

        public QuizBuilder() {
        }

        public QuizBuilder quizId(Long quizId) {
            this.quizId = quizId;
            return this;
        }

        public QuizBuilder name(String name) {
            this.name = name;
            return this;
        }

        public QuizBuilder description(String description) {
            this.description = description;
            return this;
        }

        public QuizBuilder explanation(String explanation) {
            this.explanation = explanation;
            return this;
        }

        public QuizBuilder creationDate(LocalDate creationDate) {
            this.creationDate = creationDate;
            return this;
        }

        public QuizBuilder passingTime(Duration passingTime) {
            this.passingTime = passingTime;
            return this;
        }

        public QuizBuilder authorId(Long authorId) {
            this.authorId = authorId;
            return this;
        }

        public QuizBuilder published(Boolean published) {
            this.published = published;
            return this;
        }

        public Quiz build() {
            return new Quiz(this);
        }
    }
}
