<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h3>${group.name}</h3>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Name</td>
            <td class="table-home">${group.name}</td>
        </tr>
        <tr>
            <td class="table-home">Creation date</td>
            <td class="table-home"><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td class="table-home">Number of students</td>
            <td class="table-home">${studentsNumber}</td>
        </tr>
        <tr>
            <td class="table-home">Author</td>
            <td class="table-home">${authorName}</td>
        </tr>
    </table>
    <h3>List of students</h3>
    <table class="table">
        <tr>
            <th style="width: 50%">Name</th>
            <th style="width: 50%"></th>
        </tr>
        <c:forEach items="${students}" var="student">
            <c:choose>
                <c:when test="${student.userId eq studentId}">
                    <tr>
                        <td><strong>${student.lastName} ${student.firstName}</strong></td>
                        <td><a href="/student">Home</a></td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td>${student.lastName} ${student.firstName}</td>
                        <td><a href="/student/${student.userId}">More</a></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </table>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
