<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Opened quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>Opened quiz</h2>
<h3>${openedQuiz.quizName}</h3>
<div>Submitted: ${openedQuiz.submitDate}</div>
<div>${openedQuiz.description}</div>
<div>Passing time: ${openedQuiz.passingTime.toMinutes()}</div>
<div>Score: ${openedQuiz.score}</div>
<div>Questions: ${openedQuiz.questionsNumber}</div>
<div>Author: ${openedQuiz.authorName}</div>
<div>
    <a href="#">Start</a> <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>
