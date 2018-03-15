<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz finished</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Quiz finished</h2>
<div>You have finished quiz with name ${finishedQuiz.quizName} at the ${finishedQuiz.attempt} attempt.</div>
<div>Your result: ${finishedQuiz.result}/${finishedQuiz.score}</div>
<div>Time spent: ${finishedQuiz.timeSpent.toMinutes()}</div>
<div>Finish date: ${finishedQuiz.finishDate}</div>
<div>More information about this quiz <a href="/student/quizzes/${finishedQuiz.quizId}">here</a></div>
<div>
    <a href="/student/results">Results</a>
    <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>
