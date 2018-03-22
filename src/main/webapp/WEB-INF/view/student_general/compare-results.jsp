<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Compare results</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
<h2>Quizzes in group</h2>
<table class="table">
    <tr>
        <th style="width: 50%">Name</th>
        <th style="width: 50%"></th>
    </tr>
    <c:forEach items="${groupQuizzes}" var="quiz">
        <tr>
            <td>${quiz.name}</td>
            <td><a href="/student/compare-results/${quiz.quizId}">Compare</a></td>
        </tr>
    </c:forEach>
</table>
<div>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
</div>
<br>
</body>
</html>