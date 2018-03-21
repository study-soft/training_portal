<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Opened quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>${openedQuiz.quizName}</h2>
<h3>Information about quiz</h3>
<div>Submitted: <localDateTime:format value="${openedQuiz.submitDate}"/></div>
<div>${openedQuiz.description}</div>
<div>Passing time: <duration:format value="${openedQuiz.passingTime}"/></div>
<div>Score: ${openedQuiz.score}</div>
<div>Questions: ${openedQuiz.questionsNumber}</div>
<div>Author: ${openedQuiz.authorName}</div>
<div>
    <a href="/student/quizzes/${openedQuiz.quizId}/start">Start</a>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
