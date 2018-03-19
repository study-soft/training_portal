<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Repass quiz</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<h2>${passedQuiz.quizName}</h2>
<h3>Information about result</h3>
<div>Score: ${passedQuiz.result}/${passedQuiz.score}</div>
<div>Time spent: <duration:format value="${passedQuiz.passingTime}"/></div>
<div>Attempts: ${passedQuiz.attempt}</div>
<h3>Information about passing</h3>
<div>Passing time: <duration:format value="${passedQuiz.passingTime}"/></div>
<div>Score: ${passedQuiz.score}</div>
<div>Number of questions: ${passedQuiz.questionsNumber}</div>
<br>
<div class="highlight-green">
    <div>If you press "Repass" you will begin repassing the quiz</div>
    <div>Your total score will be less on ${passedQuiz.attempt * 10}%</div>
    <div>If you press "Finish" you will finish quiz with current result</div>
    <div>If you do not want to repass it than press "Back"</div>
</div>
<div>
    <a href="/student/quizzes/${passedQuiz.quizId}/initialize" class="btn-custom">Repass</a>
    <form style="display: inline" action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="submit" class="btn-custom" value="Finish"/>
    </form>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
