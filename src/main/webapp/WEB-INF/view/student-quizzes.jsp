<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 3/11/2018
  Time: 5:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
</head>
<body>
<h2>Student quizzes</h2>
<div>Search...</div>
<c:if test="${not empty openedQuizzes}"><h3>Opened</h3>
    <table>
        <tr>
            <th>Name</th>
            <th>Author</th>
            <th>Questions</th>
            <th>Score</th>
            <th>Submit date</th>
            <th></th>
        </tr>
        <c:forEach items="${openedQuizzes}" var="openedQuiz">
            <tr>
                <td>${openedQuiz.quizName}</td>
                <td>${openedQuiz.authorName}</td>
                <td>${openedQuiz.questionsNumber}</td>
                <td>${openedQuiz.score}</td>
                <td>${openedQuiz.submitDate}</td>
                <td><a href="/student/quizzes/${openedQuiz.quizId}">Details</a></td>
            </tr>
        </c:forEach>
    </table>
</c:if>
<c:if test="${not empty passedQuizzes}"><h3>Passed</h3>
    <table>
        <tr>
            <th>Name</th>
            <th>Author</th>
            <th>Result</th>
            <th>Attempt</th>
            <th>Time spent</th>
            <th></th>
        </tr>
        <c:forEach items="${passedQuizzes}" var="passedQuiz">
            <tr>
                <td>${passedQuiz.quizName}</td>
                <td>${passedQuiz.authorName}</td>
                <td>${passedQuiz.result}/${passedQuiz.score}</td>
                <td>${passedQuiz.attempt}</td>
                <td>${passedQuiz.timeSpent.toMinutes()} mins</td>
                <td><a href="/student/quizzes/${passedQuiz.quizId}">Details</a></td>
            </tr>
        </c:forEach>
    </table>
</c:if>
<c:if test="${not empty finishedQuizzes}"><h3>Closed</h3>
    <table>
        <tr>
            <th>Name</th>
            <th>Author</th>
            <th>Result</th>
            <th>Attempt</th>
            <th>Time spent</th>
            <th></th>
        </tr>
        <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
            <tr>
                <td>${finishedQuiz.quizName}</td>
                <td>${finishedQuiz.authorName}</td>
                <td>${finishedQuiz.result}/${finishedQuiz.score}</td>
                <td>${finishedQuiz.attempt}</td>
                <td>${finishedQuiz.timeSpent.toMinutes()} mins</td>
                <td><a href="/student/quizzes/${finishedQuiz.quizId}">Details</a></td>
            </tr>
        </c:forEach>
    </table>
</c:if>
<div>
    <a href="/student">Back</a>
</div>
</body>
</html>
