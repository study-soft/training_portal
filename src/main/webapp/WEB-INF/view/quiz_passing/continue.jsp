<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Continue</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Attention</h2>
    <div>
        You should
        <a href="/quizzes/${sessionScope.currentQuiz.quizId}/passing"> continue</a> or
        <a href="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations"> finish</a>
        <strong> ${sessionScope.currentQuiz.name}</strong> quiz
    </div>
    <div>You have answered only ${sessionScope.currentQuestionSerial} / ${sessionScope.questionsNumber} questions yet</div>
</div>
<br>
</body>
</html>