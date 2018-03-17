<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit profile</title>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Edit profile: ${student.login}</h2>
<form:form action="/student/edit-profile" method="post" modelAttribute="student">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div>
        <div>Password*:</div>
        <form:input path="password"/>
        <form:errors path="password" cssClass="error"/>
    </div>
    <div>
        <div>E-mail*:</div>
        <form:input path="email"/>
        <form:errors path="email" cssClass="error"/>
    </div>
    <div>
        <div>Phone number*:</div>
        <form:input path="phoneNumber"/>
        <form:errors path="phoneNumber" cssClass="error"/>
    </div>
    <div>
        <div>First name:</div>
        <form:input path="firstName"/>
        <form:errors path="firstName" cssClass="error"/>
    </div>
    <div>
        <div>Last name*:</div>
        <form:input path="lastName"/>
        <form:errors path="lastName" cssClass="error"/>
    </div>
    <div>
        <div>Date of birth*:</div>
        <input type="date" name="dateOfBirth" value="${birthDate}">
        <form:errors path="dateOfBirth" cssClass="error"/>
    </div>
    <div>
        <input type="submit" value="Save">
    </div>
</form:form>
</body>
</html>