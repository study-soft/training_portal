package com.company.training_portal.controller;

import com.company.training_portal.dao.QuizDao;
import com.company.training_portal.model.Quiz;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;

import static com.company.training_portal.controller.QuizController.roundOff;
import static com.company.training_portal.controller.SessionAttributes.CURRENT_QUIZ;
import static com.company.training_portal.controller.SessionAttributes.RESULT;
import static com.company.training_portal.model.enums.StudentQuizStatus.PASSED;

@Component
public class LogoutFilter extends GenericFilterBean {

    private QuizDao quizDao;

    private static final Logger logger = Logger.getLogger(LogoutFilter.class);

    @Autowired
    public LogoutFilter(QuizDao quizDao) {
        this.quizDao = quizDao;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        logger.info(">>>>>>> entering logout interceptor");
        HttpSession session = httpRequest.getSession();
        Long studentId = (Long) session.getAttribute("studentId");
        Long quizId = ((Quiz) session.getAttribute(CURRENT_QUIZ)).getQuizId();
        Double result = (Double) session.getAttribute(RESULT);
        if (session.getAttribute(RESULT) != null) {
            Integer attempt = quizDao.findAttempt(studentId, quizId);
            Integer roundedResult = roundOff(result * (1 - 0.1 * attempt));
            attempt += 1;
            LocalDateTime finishDate = LocalDateTime.now();
            quizDao.editStudentInfoAboutOpenedQuiz(studentId, quizId, roundedResult,
                    finishDate, attempt, PASSED);
            logger.info(">>>>>>> WRITING RESULT TO DATABASE");
        }
        chain.doFilter(request, response);
    }
}
