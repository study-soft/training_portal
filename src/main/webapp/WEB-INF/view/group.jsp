<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Group information</h2>
<h3>${group.name}</h3>
<div>Created: ${group.creationDate}</div>
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
                    <td><b>${student.lastName} ${student.firstName}</b></td>
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
    <a href="/student">Back</a>
</div>
</body>
</html>
