<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.just.passed"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="just.passed"/></h2>
    <a href="/teacher/quizzes/${quizId}" class="btn btn-primary btn-wide">
        <spring:message code="quiz.back"/>
    </a>
</div>
</body>
</html>
