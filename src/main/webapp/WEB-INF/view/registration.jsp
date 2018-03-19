<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Registration</title>
    <c:import url="fragment/student-navbar.jsp"/>
</head>
<body>
<form:form action="/register" method="post" modelAttribute="user">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div>
        <div>Login<span class="error">*</span>:</div>
        <form:input path="login"/>
        <form:errors path="login" cssClass="error"/>
    </div>
    <div>
        <div>Password<span class="error">*</span>:</div>
        <form:input path="password"/>
        <form:errors path="password" cssClass="error"/>
    </div>
    <div>
        <div>E-mail<span class="error">*</span>:</div>
        <form:input path="email"/>
        <form:errors path="email" cssClass="error"/>
    </div>
    <div>
        <div>Phone number<span class="error">*</span>:</div>
        <form:input path="phoneNumber"/>
        <form:errors path="phoneNumber" cssClass="error"/>
    </div>
    <div>
        <div>User role<span class="error">*</span>:</div>
        <form:select path="userRole">
            <form:option value="STUDENT" label="Student"/>
            <form:option value="TEACHER" label="Teacher"/>
        </form:select>
        <form:errors path="userRole" cssClass="error"/>
    </div>
    <div>
        <div>First name<span class="error">*</span>:</div>
        <form:input path="firstName"/>
        <form:errors path="firstName" cssClass="error"/>
    </div>
    <div>
        <div>Last name<span class="error">*</span>:</div>
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
        <input type="reset" value="Reset">
    </div>
</form:form>
<div>
    <a href="/login">Login page</a>
</div>
</body>
</html>