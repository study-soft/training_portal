<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group results</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${group.name}</h2>
    <div>Number of students: ${studentsNumber}</div>
    <h3>Progress of passed quizzes</h3>
    <table class="table">
        <tr>
            <th>Name</th>
            <th>Opened students</th>
            <th>Passed students</th>
            <th>Closed students</th>
        </tr>
        <c:forEach items="${quizzes}" var="quiz" varStatus="status">
            <c:set var="map" value="${students[status.index]}"/>
            <tr>
                <td>
                    <a href="/teacher/results/group/${group.groupId}/quiz/${quiz.quizId}">${quiz.name}</a>
                </td>
                <td>${map['OPENED']}</td>
                <td>${map['PASSED']}</td>
                <td>${map['CLOSED']}</td>
            </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>
