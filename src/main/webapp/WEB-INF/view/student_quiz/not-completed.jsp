<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Not completed</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<h2>Wait, please</h2>
<div>You must wait for all students in your group finish <strong>${quiz.name}</strong> quiz </div>
<div>Finished students: ${finishedStudents}/${allStudents}</div>
<div>
    <a href="/student/compare-results/${quiz.quizId}">Compare results</a>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
