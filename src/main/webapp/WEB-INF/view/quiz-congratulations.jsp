<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Congratulations</title>
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Congratulations!</h2>
<div>You have passed this quiz.</div>
<div>Result: ${sessionScope.result}/${score}</div>
</body>
</html>
