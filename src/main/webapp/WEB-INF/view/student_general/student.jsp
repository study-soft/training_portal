<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Hello, student! Welcome to the training portal!</h2>
<div>
    <form action="/logout" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="submit" value="Logout">
    </form>
</div>
<h3>Student information</h3>
<div>First name: ${student.firstName}</div>
<div>Last name: ${student.lastName}</div>
<div>E-mail: ${student.email}</div>
<div>Phone number: ${student.phoneNumber}</div>
<c:if test="${student.dateOfBirth ne null}">
    <div>Date of birth: <localDate:format value="${student.dateOfBirth}"/></div>
</c:if>
<h4>Login and password</h4>
<div>Login: ${student.login}</div>
<div>Password: ${student.password}</div>
<div>
    <a href="/student/edit-profile">Edit profile</a>
</div>
<h3>Group information</h3>
<c:choose>
    <c:when test="${group eq null}">
        <div>You do not belong to any group</div>
    </c:when>
    <c:otherwise>
        <div>Name: ${group.name}</div>
        <div>Creation date: <localDate:format value="${group.creationDate}"/></div>
        <div>Number of students: ${numberOfStudents}</div>
        <div>Author: ${authorName}</div>
        <div>
            <a href="/student/group">More info</a>
        </div>
    </c:otherwise>
</c:choose>
</body>
</html>
