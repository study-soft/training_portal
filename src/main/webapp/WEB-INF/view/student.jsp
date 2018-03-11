<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
</head>
<body>
<div>Hello, student! Welcome to the training portal!</div>
<div>Student information:</div>
<div>First name: ${user.firstName}</div>
<div>Last name: ${user.lastName}</div>
<div>E-mail: ${user.email}</div>
<div>User: ${user}</div>
</body>
</html>
