<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/teacher-navbar.jsp"/>
<h2>Hello, teacher! Welcome to the training portal!</h2>
<div>
    <a href="/teacher/groups/create">+ Create group</a>
    <a href="#">+ Create quiz</a>
</div>
<h3>Teacher information</h3>
<div>First name: ${teacher.firstName}</div>
<div>Last name: ${teacher.lastName}</div>
<div>E-mail: ${teacher.email}</div>
<div>Phone number: ${teacher.phoneNumber}</div>
<c:if test="${teacher.dateOfBirth ne null}">
    <div>Date of birth: <localDate:format value="${teacher.dateOfBirth}"/></div>
</c:if>
<h4>Login and password</h4>
<div>Login: ${teacher.login}</div>
<div>Password: ${teacher.password}</div>
<div>
    <a href="/teacher/edit-profile">Edit profile</a>
</div>
</body>
</html>