<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Repass quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>${passedQuiz.quizName}</h2>
<div>Passing time: ${passedQuiz.passingTime}</div>
<div>Score: ${passedQuiz.score}</div>
<div>Number of questions: ${passedQuiz.questionsNumber}</div>
<h4>Your current result</h4>
<div>Score: ${passedQuiz.result}/${passedQuiz.score}</div>
<div>Time spent: ${passedQuiz.timeSpent}</div>
<div>Current attempt: ${passedQuiz.attempt}</div>
<br>
<div>If you press "Repass" you will begin repassing the quiz</div>
<div>Your total score will be less on ${passedQuiz.attempt * 10}%</div>
<div>If you press "Finish" you will finish quiz with current result</div>
<div>If you do not want to repass it than press "Back"</div>
<div>
    <a href="/student/quizzes/${passedQuiz.quizId}/0">Repass</a>
    <form style="display: inline" action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="submit" value="Finish"/>
    </form>
    <a href="/student/quizzes/${passedQuiz.quizId}">Back</a>
</div>
</body>
</html>
