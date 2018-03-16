<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Continue</title>
</head>
<body>
<div>
    You should continue <strong>${sessionScope.currentQuiz.name}</strong> quiz.
    <a href="/student/quizzes/${sessionScope.currentQuiz.quizId}/passing">Continue</a>
</div>
<div>
    Or you can finish <strong>${sessionScope.currentQuiz.name}</strong> quiz.
    <a href="/student/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">Finish</a>
</div>
</body>
</html>