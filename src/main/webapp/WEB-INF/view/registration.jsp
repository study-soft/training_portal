<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Registration</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<form:form action="/register" method="post" modelAttribute="user">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div>
        <div>Login*:</div>
        <form:input path="login"/>
        <form:errors path="login" cssClass="error"/>
    </div>
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
        <div>User role*:</div>
        <form:select path="userRole">
            <form:option value="STUDENT" label="Student"/>
            <form:option value="TEACHER" label="Teacher"/>
        </form:select>
        <form:errors path="userRole" cssClass="error"/>
    </div>
    <div>
        <div>First name:</div>
        <form:input path="firstName"/>
        <form:errors path="firstName" cssClass="error"/>
    </div>
    <div>
        <div>Last name:</div>
        <form:input path="lastName"/>
        <form:errors path="lastName" cssClass="error"/>
    </div>
    <div>
        <div>Date of birth:</div>
        <input type="date" name="dateOfBirth">
        <form:errors path="dateOfBirth" cssClass="error"/>
    </div>
    <div>
        <input type="submit" value="Register">
    </div>
</form:form>
</body>
</html>