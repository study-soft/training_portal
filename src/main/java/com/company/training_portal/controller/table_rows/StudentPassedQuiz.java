package com.company.training_portal.controller.table_rows;

import java.time.Duration;
import java.time.LocalDateTime;

public class StudentPassedQuiz {
    private String quizName;
    private String authorName;
    private Integer result;
    private Integer score;
    private Integer attempt;
    private LocalDateTime finishDate;
    private Duration timeSpent;

    public StudentPassedQuiz(String quizName,
                             String authorName,
                             Integer result,
                             Integer score,
                             Integer attempt,
                             LocalDateTime finishDate,
                             Duration timeSpent) {
        this.quizName = quizName;
        this.authorName = authorName;
        this.result = result;
        this.score = score;
        this.attempt = attempt;
        this.finishDate = finishDate;
        this.timeSpent = timeSpent;
    }

    public String getQuizName() {
        return quizName;
    }

    public void setQuizName(String quizName) {
        this.quizName = quizName;
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

    public Integer getAttempt() {
        return attempt;
    }

    public void setAttempt(Integer attempt) {
        this.attempt = attempt;
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

        StudentPassedQuiz that = (StudentPassedQuiz) o;

        if (!quizName.equals(that.quizName)) return false;
        if (!authorName.equals(that.authorName)) return false;
        if (!result.equals(that.result)) return false;
        if (!score.equals(that.score)) return false;
        if (!attempt.equals(that.attempt)) return false;
        if (!finishDate.equals(that.finishDate)) return false;
        return timeSpent.equals(that.timeSpent);
    }

    @Override
    public int hashCode() {
        int result1 = quizName.hashCode();
        result1 = 31 * result1 + authorName.hashCode();
        result1 = 31 * result1 + result.hashCode();
        result1 = 31 * result1 + score.hashCode();
        result1 = 31 * result1 + attempt.hashCode();
        result1 = 31 * result1 + finishDate.hashCode();
        result1 = 31 * result1 + timeSpent.hashCode();
        return result1;
    }

    @Override
    public String toString() {
        return "StudentPassedQuiz{" +
                "quizName='" + quizName + '\'' +
                ", authorName='" + authorName + '\'' +
                ", result=" + result +
                ", score=" + score +
                ", attempt=" + attempt +
                ", finishDate=" + finishDate +
                ", timeSpent=" + timeSpent +
                '}';
    }
}