<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Compare quiz results</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>Compare quiz results</h2>
<h3>${quiz.name}</h3>
<h4>Quiz results</h4>
<table>
    <tr>
        <th>Name</th>
        <th>Result</th>
        <th>Attempt</th>
        <th>Time spent</th>
        <th>Status</th>
    </tr>
    <c:forEach items="${studentsInGroup}" var="student" varStatus="status">
        <tr>
            <td>${student.lastName} ${student.firstName}</td>
            <td>${studentsQuizzes[status.index].result}/${studentsQuizzes[status.index].score}</td>
            <td>${studentsQuizzes[status.index].attempt}</td>
            <td>${studentsQuizzes[status.index].timeSpent}</td>
            <td>${statusList[status.index]}</td>
            <td></td>
        </tr>
    </c:forEach>
</table>
<div>
    <a href="/student/compare-results">Back</a>
</div>
</body>
</html>
