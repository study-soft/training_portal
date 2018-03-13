<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz finished</title>
</head>
<body>
<h2>Quiz finished</h2>
<div>You have finished quiz with name ${finishedQuiz.quizName} at the ${finishedQuiz.attempt} attempt.</div>
<div>Your result: ${finishedQuiz.result}/${finishedQuiz.score}</div>
<div>Time spent: ${finishedQuiz.timeSpent}</div>
<div>Finish date: ${finishedQuiz.finishDate}</div>
<div>More information about this quiz <a href="/student/quizzes/${finishedQuiz.quizId}">here</a></div>
<div>
    <a href="/student/results">Back</a>
</div>
</body>
</html>
