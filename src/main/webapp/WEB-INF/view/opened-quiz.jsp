<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Opened quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Opened quiz</h2>
<h3>${openedQuiz.quizName}</h3>
<div>Submitted: <localDateTime:format value="${openedQuiz.submitDate}"/></div>
<div>${openedQuiz.description}</div>
<div>Passing time: <duration:format value="${openedQuiz.passingTime}"/></div>
<div>Score: ${openedQuiz.score}</div>
<div>Questions: ${openedQuiz.questionsNumber}</div>
<div>Author: ${openedQuiz.authorName}</div>
<div>
    <a href="/student/quizzes/${openedQuiz.quizId}/start">Start</a>
    <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>
