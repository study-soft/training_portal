<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
</head>
<body>
<h2>Results</h2>
<div>Search...</div>
<div>Passed quizzes</div>
<table>
    <tr>
        <th>Name</th>
        <th>Result</th>
        <th>Attempt</th>
        <th>Time spent</th>
        <th>Finish date</th>
        <th></th>
        <th></th>
    </tr>
    <c:forEach items="${passedQuizzes}" var="passedQuiz">
    <tr>
        <td>${passedQuiz.quizName}</td>
        <td>${passedQuiz.result}</td>
        <td>${passedQuiz.attempt}</td>
        <td>${passedQuiz.timeSpent.toMinutes()} mins</td>
        <td>${passedQuiz.finishDate}</td>
        <td><a href="#">Repass</a></td>
        <td><a href="#">Finish</a></td>
    </tr>
    </c:forEach>
</table>
<br>
<div>Finished quizzes</div>
<table>
    <tr>
        <th>Name</th>
        <th>Result</th>
        <th>Attempt</th>
        <th>Time spent</th>
        <th>Finish date</th>
    </tr>
    <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
        <tr>
            <td>${finishedQuiz.quizName}</td>
            <td>${finishedQuiz.result}</td>
            <td>${finishedQuiz.attempt}</td>
            <td>${finishedQuiz.timeSpent.toMinutes()} mins</td>
            <td>${finishedQuiz.finishDate}</td>
        </tr>
    </c:forEach>
</table>
<div>
    <a href="#">Compare results</a>
</div>
<div>
    <a href="/student">Back</a>
</div>
</body>
</html>