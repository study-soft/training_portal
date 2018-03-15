<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Student quizzes</h2>
<div>Search...</div>
<h3>Opened quizzes</h3>
<c:choose>
    <c:when test="${empty openedQuizzes}">
        <div>You do not have any quizzes. Say your teachers to add you.</div>
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Name</th>
                <th>Questions</th>
                <th>Score</th>
                <th>Submit date</th>
                <th>Author</th>
                <th></th>
            </tr>
            <c:forEach items="${openedQuizzes}" var="openedQuiz">
                <tr>
                    <td>${openedQuiz.quizName}</td>
                    <td>${openedQuiz.questionsNumber}</td>
                    <td>${openedQuiz.score}</td>
                    <td>${openedQuiz.submitDate}</td>
                    <td>${openedQuiz.authorName}</td>
                    <td><a href="/student/quizzes/${openedQuiz.quizId}">Details</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<h3>Passed quizzes</h3>
<c:choose>
    <c:when test="${empty passedQuizzes}">
        <div>You do not have any passed quizzes</div>
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Name</th>
                <th>Questions</th>
                <th>Score</th>
                <th>Submit date</th>
                <th>Author</th>
                <th></th>
            </tr>
            <c:forEach items="${passedQuizzes}" var="passedQuiz">
                <tr>
                    <td>${passedQuiz.quizName}</td>
                    <td>${passedQuiz.questionsNumber}</td>
                    <td>${passedQuiz.score}</td>
                    <td>${passedQuiz.submitDate}</td>
                    <td>${passedQuiz.authorName}</td>
                    <td><a href="/student/quizzes/${passedQuiz.quizId}">Details</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<h3>Finished quizzes</h3>
<c:choose>
    <c:when test="${empty finishedQuizzes}">
        <div>You do not have finished quizzes</div>
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Name</th>
                <th>Questions</th>
                <th>Score</th>
                <th>Submit date</th>
                <th>Author</th>
                <th></th>
            </tr>
            <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
                <tr>
                    <td>${finishedQuiz.quizName}</td>
                    <td>${finishedQuiz.questionsNumber}</td>
                    <td>${finishedQuiz.score}</td>
                    <td>${finishedQuiz.submitDate}</td>
                    <td>${finishedQuiz.authorName}</td>
                    <td><a href="/student/quizzes/${finishedQuiz.quizId}">Details</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<div>
    <a href="/student">Back</a>
</div>
</body>
</html>
