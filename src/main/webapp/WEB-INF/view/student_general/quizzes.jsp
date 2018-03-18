<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Quizzes</h2>
<div>Search...</div>
<h3>Opened quizzes</h3>
<c:choose>
    <c:when test="${empty openedQuizzes}">
        <div>You do not have any opened quizzes. Say your teachers to give you some</div>
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
                    <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
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
                    <td><localDateTime:format value="${passedQuiz.submitDate}"/></td>
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
                    <td><localDateTime:format value="${finishedQuiz.submitDate}"/></td>
                    <td>${finishedQuiz.authorName}</td>
                    <td><a href="/student/quizzes/${finishedQuiz.quizId}">Details</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<div>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
