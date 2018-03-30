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
    <h2><a href="/teacher/groups/${group.groupId}">${group.name}</a></h2>
    <div class="col-6">
        <table class="table-info">
            <tr>
                <td>Number of students</td>
                <td>${studentsNumber}</td>
            </tr>
        </table>
    </div>
    <c:if test="${not empty passedQuizzes}">
        <h3>Progress of passed quizzes</h3>
        <table class="table">
            <tr>
                <th></th>
                <th colspan="4" class="text-center">Students</th>
                <th></th>
            </tr>
            <tr>
                <th style="width: 30%;">Quiz name</th>
                <th style="width: 12.5%">Total</th>
                <th style="width: 12.5%;">Opened</th>
                <th style="width: 12.5%;">Passed</th>
                <th style="width: 12.5%;">Closed</th>
                <th style="width: 20%"></th>
            </tr>
            <c:forEach items="${passedQuizzes}" var="passedQuiz" varStatus="status">
                <c:set var="map" value="${quizStudents[status.index]}"/>
                <tr>
                    <td>
                        <a href="/teacher/results/group/${group.groupId}/quiz/${passedQuiz.quizId}">${passedQuiz.name}</a>
                    </td>
                    <td>${map['TOTAL']}</td>
                    <td>${map['OPENED']}</td>
                    <td>${map['PASSED']}</td>
                    <td>${map['CLOSED']}</td>
                    <td><a href="#" class="danger"><i class="fa fa-close"></i> Close all</a></td>
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
