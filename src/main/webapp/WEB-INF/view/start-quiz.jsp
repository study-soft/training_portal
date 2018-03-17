<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Start quiz</title>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>${openedQuiz.quizName}</h2>
<div>Passing time: <duration:format value="${openedQuiz.passingTime}"/></div>
<div>Score: ${openedQuiz.score}</div>
<div>Number of questions: ${openedQuiz.questionsNumber}</div>
<div>If you press "Start" you will begin passing the quiz</div>
<div>If you do not want to pass it than press "Back"</div>
<div>
    <a href="/student/quizzes/${openedQuiz.quizId}/initialize">Start</a>
    <a href="/student/quizzes/${openedQuiz.quizId}">Back</a>
</div>
</body>
</html>
