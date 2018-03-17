<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Not completed</title>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Wait, please</h2>
<div>You must wait for all students in your group finish <strong>${quiz.name}</strong> quiz </div>
<div>Finished students: ${finishedStudents}/${allStudents}</div>
<div>
    <a href="/student/quizzes/${quiz.quizId}">Back</a>
    <a href="/student/compare-results/${quiz.quizId}">Compare results</a>
</div>
</body>
</html>
