<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <c:import url="fragment/head.jsp"/>
</head>
<body>
<br>
<div class="container">
    <div class="text-center">
        <img src="/resources/training-portal-favicon.png" width="30" height="35" style="margin-bottom: 15px">
        <h2 style="display: inline">Training portal</h2>
    </div>
    <br>
    <br>
    <form action="/login" method="post" class="col col-md-6 center">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <c:if test="${param.error ne null}">
            <p class="error">Invalid login or password</p>
        </c:if>
        <span class="success">${registrationSuccess}</span>
        <div class="form-group row">
            <label for="username" class="col-4 col-form-label"><strong>Login</strong></label>
            <input type="text" class="col-8 form-control" id="username" name="username" placeholder="Login">
        </div>
        <div class="form-group row">
            <label for="password" class="col-4 col-form-label"><strong>Password</strong></label>
            <input type="password" class="col-8 form-control" id="password" name="password" placeholder="Password">
        </div>
        <div class="right">
            <input type="submit" value="Log in" class="btn btn-primary">
        </div>
        <br>
        <br>
        <div class="right">Do not have an account? <a href="/register">Register</a></div>
    </form>
</div>
</body>
</html>
