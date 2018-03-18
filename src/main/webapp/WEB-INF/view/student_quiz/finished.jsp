<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Finished quiz</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/student-navbar.jsp"/>
<h2>${finishedQuiz.quizName}</h2>
<h3>Information about result</h3>
<div>Finish date: <localDateTime:format value="${finishedQuiz.finishDate}"/></div>
<div>Result: ${finishedQuiz.result}/${finishedQuiz.score}</div>
<div>Attempt: ${finishedQuiz.attempt}</div>
<div>Time spent: <duration:format value="${finishedQuiz.timeSpent}"/></div>
<h3>Information about quiz</h3>
<div>Passing time: <duration:format value="${finishedQuiz.passingTime}"/></div>
<div>Score: ${finishedQuiz.score}</div>
<div>Questions: ${finishedQuiz.questionsNumber}</div>
<div>Author: ${finishedQuiz.authorName}</div>
<div>Submit date: <localDateTime:format value="${finishedQuiz.submitDate}"/></div>
<div>Description: ${finishedQuiz.description}</div>
<div>Explanation: ${finishedQuiz.explanation}</div>
<div>
    <a href="/student/quizzes/${finishedQuiz.quizId}/answers">Answers</a>
    <a href="/student/compare-results/${finishedQuiz.quizId}">Compare results</a>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
