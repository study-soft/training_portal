<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Congratulations</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Congratulations!</h2>
<div>You have passed <strong>${quiz.quizName}</strong> quiz with ${quiz.attempt} attempt</div>
<div>You have asked on ${currentQuestionSerial}/${quiz.questionsNumber} questions</div>
<div>Result: ${quiz.result}/${quiz.score}</div>
<div>Time spent: <duration:format value="${quiz.timeSpent}"/></div>
<div>Finish date: <localDateTime:format value="${quiz.finishDate}"/></div>
<div>Explanation: ${quiz.explanation}</div>
<div><a href="/student/quizzes/${quiz.quizId}">Back to quiz</a></div>
</body>
</html>
