<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Teachers</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<h2>Student teachers</h2>
<div>Search...</div>
<table>
    <tr>
        <th>Name</th>
        <th>E-mail</th>
        <th>Phone number</th>
        <th></th>
    </tr>
    <c:forEach items="${teachers}" var="teacher">
        <tr>
            <td>${teacher.lastName} ${teacher.firstName}</td>
            <td>${teacher.email}</td>
            <td>${teacher.phoneNumber}</td>
            <td><a href="/student/teachers/${teacher.userId}">Details</a></td>
        </tr>
    </c:forEach>
</table>
<div>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>