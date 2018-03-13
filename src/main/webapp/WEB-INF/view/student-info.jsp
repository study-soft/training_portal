<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student info</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<h2>Student information</h2>
<h3>${student.lastName} ${student.firstName}</h3>
<div>E-mail: ${student.email}</div>
<div>Phone number: ${student.phoneNumber}</div>
<div>Date of birth: ${student.dateOfBirth}</div>
<div>Group: ${group.name}</div>
<h4>This student passes next quizzes:</h4>
<table>
    <tr>
        <th>Name</th>
        <th>Status</th>
        <th>Result</th>
        <th>Attempt</th>
    </tr>
    <c:forEach items="${openedQuizzes}" var="openedQuiz">
        <tr>
            <td>${openedQuiz.quizName}</td>
            <td>OPENED</td>
            <td></td>
            <td></td>
        </tr>
    </c:forEach>
    <c:forEach items="${passedQuizzes}" var="passedQuiz">
        <tr>
            <td>${passedQuiz.quizName}</td>
            <td>PASSED</td>
            <td>${passedQuiz.result}/${passedQuiz.score}</td>
            <td>${passedQuiz.attempt}</td>
        </tr>
    </c:forEach>
    <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
        <tr>
            <td>${finishedQuiz.quizName}</td>
            <td>FINISHED</td>
            <td>${finishedQuiz.result}/${finishedQuiz.score}</td>
            <td>${finishedQuiz.attempt}</td>
        </tr>
    </c:forEach>
</table>
<div>
    <a href="/student/group">Back</a>
</div>
</body>
</html>