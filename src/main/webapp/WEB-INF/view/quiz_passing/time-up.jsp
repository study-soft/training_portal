<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Time is up</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<h2>Oops... Time is up</h2>
<div>You have forcibly completed <strong>${quiz.quizName}</strong> quiz with ${quiz.attempt} attempt</div>
<div>You have asked on ${currentQuestionSerial}/${quiz.questionsNumber} questions</div>
<div>Result: ${quiz.result}/${quiz.score}</div>
<div>You spent all time: <duration:format value="${quiz.passingTime}"/></div>
<div>Finish date: <localDateTime:format value="${quiz.finishDate}"/></div>
<div>Explanation: ${quiz.explanation}</div>
<div><a href="/student/quizzes/${quiz.quizId}">Back to quiz</a></div>
</body>
</html>