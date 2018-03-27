<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
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
    <c:if test="${not empty passedQuizzes}">
        <h3>Progress of passed quizzes</h3>
        <table class="table">
            <tr>
                <th style="width: 25%">Name</th>
                <th style="width: 25%">Opened students</th>
                <th style="width: 25%;">Passed students</th>
                <th style="width: 25%">Closed students</th>
            </tr>
            <c:forEach items="${passedQuizzes}" var="passedQuiz" varStatus="status">
                <c:set var="map" value="${students[status.index]}"/>
                <tr>
                    <td>
                        <a href="/teacher/results/group/${group.groupId}/quiz/${passedQuiz.quizId}">${passedQuiz.name}</a>
                    </td>
                    <td>${map['OPENED']}</td>
                    <td>${map['PASSED']}</td>
                    <td>${map['CLOSED']}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty closedQuizzes}">
        <h3>Results of closed quizzes</h3>
        <table class="table">
            <tr>
                <th style="width: 50%">Name</th>
                <th style="width: 50%">Closing date</th>
            </tr>
            <c:forEach items="${closedQuizzes}" var="closedQuiz" varStatus="status">
                <tr>
                    <td>
                        <a href="/teacher/results/group/${group.groupId}/quiz/${closedQuiz.quizId}">${closedQuiz.name}</a>
                    </td>
                    <td><localDateTime:format value="${closingDates[status.index]}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <button class="btn btn-primary" onclick="window.history.go(-1)">Back</button>
</div>
<br>
</body>
</html>
