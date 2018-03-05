package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.model.Quiz;
import com.company.training_portal.model.enums.StudentQuizStatus;
import com.company.training_portal.model.enums.TeacherQuizStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;

@Repository
public class QuizDaoJdbc implements QuizDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public QuizDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public Quiz findQuizByQuizId(Long quizId) {
        return null;
    }

    @Override
    public List<Quiz> findAllQuizzes() {
        return null;
    }

    @Override
    public List<String> findAllQuizNames() {
        return null;
    }

    @Override
    public List<Quiz> findAllQuizzesByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public List<String> findAllQuizNamesByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public List<Quiz> findAllQuizzesByStudentId(Long studentId) {
        return null;
    }

    @Override
    public List<String> findAllQuizNamesByStudentId(Long studentId) {
        return null;
    }

    @Override
    public List<String> findAllClosedQuizNamesByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public List<Quiz> findAllNotPublishedQuizzesByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public List<String> findAllQuizNamesByStudentIdAndStudentQuizStatus(Long studentId, StudentQuizStatus studentQuizStatus) {
        return null;
    }

    @Override
    public Integer findQuizzesNumberByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public Map<StudentQuizStatus, Integer> findStudentsNumberByAuthorIdAndGroupIdAndQuizIdWithStudentQuizStatus(Long authorId, StudentQuizStatus studentQuizStatus) {
        return null;
    }

    @Override
    public Map<TeacherQuizStatus, Integer> FindQuizzesNumberByAuthorIdWithTeacherQuizStatus(Long authorId) {
        return null;
    }

    @Override
    public Map<String, Integer> findAllStudentResults(Long userId) {
        return null;
    }

    @Override
    public List<String> findQuizNamesByStudentIdAndReopenCounter(Long studentId, Integer reopenCounter) {
        return null;
    }

    @Override
    public List<String> findQuizNamesByStudentIdAndAuthorId(Long studentId, Long authorId) {
        return null;
    }

    @Override
    public Long addQuiz(Quiz quiz) {
        return null;
    }

    @Override
    public void editQuiz(Quiz quiz) {

    }

    @Override
    public void deleteQuiz(Long quizId) {

    }
}
