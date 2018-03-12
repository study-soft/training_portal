package com.company.training_portal.controller.table_rows;

import java.time.LocalDateTime;

public class StudentOpenedQuiz {
    private String quizName;
    private String authorName;
    private Integer questionsNumber;
    private Integer score;
    private LocalDateTime submitDate;

    public StudentOpenedQuiz(String quizName,
                             String authorName,
                             Integer questionsNumber,
                             Integer score,
                             LocalDateTime submitDate) {
        this.quizName = quizName;
        this.authorName = authorName;
        this.questionsNumber = questionsNumber;
        this.score = score;
        this.submitDate = submitDate;
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

        StudentOpenedQuiz that = (StudentOpenedQuiz) o;

        if (!quizName.equals(that.quizName)) return false;
        if (!authorName.equals(that.authorName)) return false;
        if (!questionsNumber.equals(that.questionsNumber)) return false;
        if (!score.equals(that.score)) return false;
        return submitDate.equals(that.submitDate);
    }

    @Override
    public int hashCode() {
        int result = quizName.hashCode();
        result = 31 * result + authorName.hashCode();
        result = 31 * result + questionsNumber.hashCode();
        result = 31 * result + score.hashCode();
        result = 31 * result + submitDate.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "StudentOpenedQuiz{" +
                "quizName='" + quizName + '\'' +
                ", authorName='" + authorName + '\'' +
                ", questionsNumber=" + questionsNumber +
                ", score=" + score +
                ", submitDate=" + submitDate +
                '}';
    }
}