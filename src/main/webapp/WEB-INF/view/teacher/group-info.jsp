<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group info</title>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="../fragment/teacher-navbar.jsp"/>
<h2>Group '${group.name}'</h2>
<small>Creation date: <localDate:format value="${group.creationDate}"/></small>
<div>Number of students: ${studentsNumber}</div>
<div>Description:</div>
<div>${group.description}</div>
<h3 style="display: inline">Students</h3>
<a href="/teacher/groups/${group.groupId}/add-students">+ Add students</a>
<br>
<table>
    <tr>
        <th>Name</th>
        <th></th>
        <th></th>
    </tr>
    <c:forEach items="${students}" var="student">
        <tr>
            <td>${student.lastName} ${student.firstName}</td>
            <td><a href="#">More</a></td>
            <td><a href="#">Delete</a></td>
        </tr>
    </c:forEach>
</table>
<div>
    <input type="button" value="Back" onclick="window.history.go(-1);">
</div>
</body>
</html>
