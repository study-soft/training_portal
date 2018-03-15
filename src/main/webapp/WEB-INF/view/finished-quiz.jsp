<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Finished quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Finished quiz</h2>
<h3>${finishedQuiz.quizName}</h3>
<div>Finish date: ${finishedQuiz.finishDate}</div>
<div>Result: ${finishedQuiz.result}/${finishedQuiz.score}</div>
<div>Attempt: ${finishedQuiz.attempt}</div>
<div>Time spent: ${finishedQuiz.timeSpent.toMinutes()}</div>
<div>
    <a href="/student/quizzes/${finishedQuiz.quizId}/answers">Answers</a>
    <a href="#">Compare results</a>
</div>
<div>Passing time: ${finishedQuiz.passingTime}</div>
<div>Score: ${finishedQuiz.score}</div>
<div>Questions: ${finishedQuiz.questionsNumber}</div>
<div>Author: ${finishedQuiz.authorName}</div>
<div>Submit date: ${finishedQuiz.submitDate}</div>
<div>Description: ${finishedQuiz.description}</div>
<div>Explanation: ${finishedQuiz.explanation}</div>
<div>
    <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>
