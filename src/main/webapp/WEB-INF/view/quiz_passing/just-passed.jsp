<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Just passed</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>You have just passed this quiz</h2>
    <a href="/teacher/quizzes/${quizId}" class="btn btn-primary btn-wide">Back to quiz</a>
</div>
</body>
</html>
