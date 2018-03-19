<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/teacher-navbar.jsp"/>
<h2>Quizzes</h2>
<div>
    Search...
    <a href="#">+ Create</a>
</div>
<h3>Unpublished quizzes</h3>
<c:choose>
    <c:when test="${empty unpublishedQuizzes}">
        You do not have any unpublished quizzes
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Name</th>
                <th>Questions</th>
                <th>Score</th>
                <th>Creation date</th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
            </tr>
            <c:forEach items="${unpublishedQuizzes}" var="unpublishedQuiz">
                <tr>
                    <td>${unpublishedQuiz.name}</td>
                    <td>${unpublishedQuiz.questionsNumber}</td>
                    <td>${unpublishedQuiz.score}</td>
                    <td><localDate:format value="${unpublishedQuiz.creationDate}"/></td>
                    <td><a href="/teacher/quizzes/${unpublishedQuiz.quizId}">Details</a></td>
                    <td><a href="#">Publish</a></td>
                    <td><a href="#">Edit</a></td>
                    <td><a href="#">Delete</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<h3>Published quizzes</h3>
<c:choose>
    <c:when test="${empty unpublishedQuizzes}">
        You do not have any published quizzes
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Name</th>
                <th>Questions</th>
                <th>Score</th>
                <th>Creation date</th>
                <th></th>
                <th></th>
            </tr>
            <c:forEach items="${publishedQuizzes}" var="publishedQuiz">
                <tr>
                    <td>${publishedQuiz.name}</td>
                    <td>${publishedQuiz.questionsNumber}</td>
                    <td>${publishedQuiz.score}</td>
                    <td><localDate:format value="${publishedQuiz.creationDate}"/></td>
                    <td><a href="/teacher/quizzes/${publishedQuiz.quizId}">Details</a></td>
                    <td><a href="#">Unpublish</a></td>
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
