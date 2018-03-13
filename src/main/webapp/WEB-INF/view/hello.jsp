<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h1>Hello Training portal!</h1>
<div>
    <a href="/student">Student page</a>
</div>
<form action="/logout" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    <input type="submit" value="Logout">
</form>
</body>
</html>
