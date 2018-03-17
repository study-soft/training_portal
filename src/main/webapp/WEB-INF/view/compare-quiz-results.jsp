<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Compare quiz results</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
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
        <c:choose>
            <c:when test="${student.userId eq studentId}">
                <tr>
                    <td><strong><a href="/student">${student.lastName} ${student.firstName}</a></strong></td>
                    <td><strong>${studentsQuizzes[status.index].result}/${studentsQuizzes[status.index].score}</strong></td>
                    <td><strong>${studentsQuizzes[status.index].attempt}</strong></td>
                    <td><strong><duration:format value="${studentsQuizzes[status.index].timeSpent}"/></strong></td>
                    <td><strong>${statusList[status.index]}</strong></td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr>
                    <td><a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                    <td>${studentsQuizzes[status.index].result}/${studentsQuizzes[status.index].score}</td>
                    <td>${studentsQuizzes[status.index].attempt}</td>
                    <td><duration:format value="${studentsQuizzes[status.index].timeSpent}"/></td>
                    <td>${statusList[status.index]}</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</table>
<div>
    <a href="/student/compare-results">Back</a>
</div>
</body>
</html>
