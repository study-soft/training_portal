<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Teacher info</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>Teacher information:</h2>
<div>Name: ${teacher.lastName} ${teacher.firstName}</div>
<div>E-mail: ${teacher.email}</div>
<div>Phone number: ${teacher.phoneNumber}</div>
<div>Date of birth: ${teacher.dateOfBirth}</div>
<h4>This teacher gave you next quizzes:</h4>
<table>
    <tr>
        <th>Name</th>
        <th>Status</th>
        <th></th>
    </tr>
    <c:forEach items="${quizzes}" var="quiz" varStatus="status">
    <tr>
        <td>${quiz.name}</td>
        <td>${statusList[status.index]}</td>
        <td><a href="/student/quizzes/${quiz.quizId}">Details</a></td>
    </tr>
    </c:forEach>
</table>
<div>
    <a href="/student/teachers">Back</a>
</div>
</body>
</html>
