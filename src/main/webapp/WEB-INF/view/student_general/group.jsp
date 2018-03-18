<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Group information</h2>
<h3>${group.name}</h3>
<div>Created: <localDate:format value="${group.creationDate}"/></div>
<div>Author: ${authorName}</div>
<div>Number of students: ${studentsNumber}</div>
<div>Description: ${group.description}</div>
<h3>List of students: </h3>
<table>
    <tr>
        <th>Name</th>
        <th></th>
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
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
