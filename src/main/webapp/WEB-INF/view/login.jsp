<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<form action="/login" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <c:if test="${param.error ne null}">
        <p class="error">Invalid login or password</p>
    </c:if>
    <span class="success">${registrationSuccess}</span>
    <div>
        <label for="username">Login: </label>
    </div>
    <div>
        <input type="text" id="username" name="username"/>
    </div>
    <div>
        <label for="password">Password: </label>
    </div>
    <div>
        <input type="password" id="password" name="password"/>
    </div>
    <input type="submit" value="Log in">
</form>
<div>Do not have an account? <a href="/register">Register</a></div>
</body>
</html>