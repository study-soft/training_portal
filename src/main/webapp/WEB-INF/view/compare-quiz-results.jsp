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
                    <td><b>${student.lastName} ${student.firstName}</b></td>
                    <td><b>${studentsQuizzes[status.index].result}/${studentsQuizzes[status.index].score}</b></td>
                    <td><b>${studentsQuizzes[status.index].attempt}</b></td>
                    <td><b><duration:format value="${studentsQuizzes[status.index].timeSpent}"/></b></td>
                    <td><b>${statusList[status.index]}</b></td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr>
                    <td>${student.lastName} ${student.firstName}</td>
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
