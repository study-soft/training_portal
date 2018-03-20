<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <!-- Popper JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="script" href="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<br>
<div class="container">
    <div class="text-center">
        <img src="/resources/training-portal-favicon.png" width="30" height="30" style="margin-bottom: 15px">
        <h2 style="display: inline">Training portal</h2>
    </div>
    <br>
    <br>
    <form action="/login" method="post" class="col-6 center">
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
    </form>
    <br>
    <br>
    <div class="text-center">Do not have an account? <a href="/register">Register</a></div>
</div>
</body>
</html>