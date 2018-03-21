<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Compare quiz results</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Compare quiz results</h2>
<h3>${quiz.name}</h3>
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
                    <c:choose>
                        <c:when test="${statusList[status.index] ne 'OPENED'}">
                            <td>
                                <strong>${studentsQuizzes[status.index].result}/${studentsQuizzes[status.index].score}</strong>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td></td>
                        </c:otherwise>
                    </c:choose>
                    <td><strong>${studentsQuizzes[status.index].attempt}</strong></td>
                    <td><strong><duration:format value="${studentsQuizzes[status.index].timeSpent}"/></strong></td>
                    <td><strong>${statusList[status.index]}</strong></td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr>
                    <td><a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                    <c:choose>
                        <c:when test="${statusList[status.index] ne 'OPENED'}">
                            <td>${studentsQuizzes[status.index].result}/${studentsQuizzes[status.index].score}</td>
                        </c:when>
                        <c:otherwise>
                            <td></td>
                        </c:otherwise>
                    </c:choose>
                    <td>${studentsQuizzes[status.index].attempt}</td>
                    <td><duration:format value="${studentsQuizzes[status.index].timeSpent}"/></td>
                    <td>${statusList[status.index]}</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</table>
<div>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
