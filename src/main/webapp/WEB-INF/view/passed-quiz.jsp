<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Passed quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Passed quiz</h2>
<h3>${passedQuiz.quizName}</h3>
<div>Finish date: <localDateTime:format value="${passedQuiz.finishDate}"/></div>
<div>Result: ${passedQuiz.result}/${passedQuiz.score}</div>
<div>Attempt: ${passedQuiz.attempt}</div>
<div>Time spent: <duration:format value="${passedQuiz.timeSpent}"/></div>
<div>
    <a href="/student/quizzes/${passedQuiz.quizId}/answers">Answers</a>
    <a href="/student/compare-results/${passedQuiz.quizId}">Compare results</a>
</div>
<div>Passing time: <duration:format value="${passedQuiz.passingTime}"/></div>
<div>Score: ${passedQuiz.score}</div>
<div>Questions: ${passedQuiz.questionsNumber}</div>
<div>Submit date: <localDateTime:format value="${passedQuiz.submitDate}"/></div>
<div>Author: ${passedQuiz.authorName}</div>
<div>Description: ${passedQuiz.description}</div>
<div>If you are satisfied with your result, you need to finish quiz</div>
<div>Also you can try again but score will be less</div>
<div>
    <form style="display: inline" action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="submit" value="Finish">
    </form>
    <a href="/student/quizzes/${passedQuiz.quizId}/repass">Repass</a>
    <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>
