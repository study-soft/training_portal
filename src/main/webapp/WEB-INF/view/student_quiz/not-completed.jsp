<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Not completed</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Wait, please</h2>
<div>You must wait for all students in your group finish <strong>${quiz.name}</strong> quiz </div>
<div>Finished students: ${finishedStudents}/${allStudents}</div>
<div>
    <a href="/student/compare-results/${quiz.quizId}">Compare results</a>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
