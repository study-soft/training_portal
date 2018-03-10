<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
<form action="/login" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <c:if test="${param.error ne null}">
        <p style="color: red">Invalid login or password</p>
    </c:if>
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
</body>
</html>
