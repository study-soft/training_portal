<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Compare results</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Compare results</h2>
<h3>Quizzes in group</h3>
<table>
    <tr>
        <th>Name</th>
        <th></th>
    </tr>
    <c:forEach items="${groupQuizzes}" var="quiz">
        <tr>
            <td>${quiz.name}</td>
            <td><a href="/student/compare-results/${quiz.quizId}">Compare</a></td>
        </tr>
    </c:forEach>
</table>
<div>
    <a href="/student/results">Results</a>
    <a href="/student/quizzes">Quizzes</a>
</div>
</body>
</html>