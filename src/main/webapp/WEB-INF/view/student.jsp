<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
</head>
<body>
<h2>Hello, student! Welcome to the training portal!</h2>
<div>
    <a href="/student/quizzes">Quizzes</a>
</div>
<div>
    <a href="/student/teachers">Teachers</a>
</div>
<div>
    <a href="/student/results">Results</a>
</div>
<div>
    <form action="/logout" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="submit" value="Logout">
    </form>
</div>
<div>----------Student information---------</div>
<div>First name: ${student.firstName}</div>
<div>Last name: ${student.lastName}</div>
<div>E-mail: ${student.email}</div>
<div>Phone number: ${student.phoneNumber}</div>
<div>Date of birth: ${student.dateOfBirth}</div>
<div>---------Login and password---------</div>
<div>Login: ${student.login}</div>
<div>Password: ${student.password}</div>
<div>
    <a href="/student/edit-profile">Edit profile</a>
</div>
<br>
<div>---------Group information---------</div>
<c:choose>
    <c:when test="${group eq null}">
        <div>You do not belong to any group</div>
    </c:when>
    <c:otherwise>
        <div>Name: ${group.name}</div>
        <div>Creation date: ${group.creationDate}</div>
        <div>Author: ${authorName}</div>
        <div>Description:</div>
        <div>${group.description}</div>
    </c:otherwise>
</c:choose>
</body>
</html>
