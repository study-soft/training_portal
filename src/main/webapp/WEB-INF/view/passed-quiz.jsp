<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Passed quiz</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>Passed quiz</h2>
<h3>${passedQuiz.quizName}</h3>
<div>Passed: ${passedQuiz.finishDate}</div>
<div>Result: ${passedQuiz.result}/${passedQuiz.score}</div>
<div>Attempt: ${passedQuiz.attempt}</div>
<div>Time spent: ${passedQuiz.timeSpent.toMinutes()} mins</div>
<div>
    <a href="/student/quizzes/${passedQuiz.quizId}/questions">Answers</a>
    <a href="#">Compare results</a>
</div>
<div>Passing time: ${passedQuiz.passingTime.toMinutes()}</div>
<div>Score: ${passedQuiz.score}</div>
<div>Questions: ${passedQuiz.questionsNumber}</div>
<div>Submit date: ${passedQuiz.submitDate}</div>
<div>Author: ${passedQuiz.authorName}</div>
<div>Description: ${passedQuiz.description}</div>
<div>If you are satisfied with your result, you need to finish quiz</div>
<div>Also you can try again but score will be less</div>
<div>
    <form style="display: inline" action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="submit" value="Finish">
    </form>
    <a href="#">Repass</a>
    <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>
