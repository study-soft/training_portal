<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Start quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>${quiz.name}</h2>
<div>Passing time: ${quiz.passingTime}</div>
<div>Score: ${quizScore}</div>
<div>Number of questions: ${questionsNumber}</div>
<div>If you press "Start" you will begin passing the quiz</div>
<div>If you do not want to pass it than press "Back"</div>
<div>
    <a href="/student/quizzes/${quiz.quizId}/0">Start</a>
    <a href="/student/quizzes/${quiz.quizId}">Back</a>
</div>
</body>
</html>
