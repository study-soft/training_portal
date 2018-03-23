<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <input class="form-control col-4" type="search" placeholder="Search..." aria-label="Search">
    <a href="#" class="btn btn-success float-right">New quiz</a>
    <h3>Unpublished quizzes</h3>
    <c:choose>
        <c:when test="${empty unpublishedQuizzes}">
            You do not have any unpublished quizzes
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 35%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 15%;">Creation date</th>
                    <th style="width: 10%"></th>
                    <th style="width: 10%"></th>
                    <th style="width: 10%"></th>
                </tr>
                <c:forEach items="${unpublishedQuizzes}" var="unpublishedQuiz">
                    <tr>
                        <td><a href="/teacher/quizzes/${unpublishedQuiz.quizId}">${unpublishedQuiz.name}</a></td>
                        <td>${unpublishedQuiz.questionsNumber}</td>
                        <td>${unpublishedQuiz.score}</td>
                        <td><localDate:format value="${unpublishedQuiz.creationDate}"/></td>
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
            <table class="table">
                <tr>
                    <th style="width: 35%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 15%">Creation date</th>
                    <th style="width: 30%"></th>
                </tr>
                <c:forEach items="${publishedQuizzes}" var="publishedQuiz">
                    <tr>
                        <td><a href="/teacher/quizzes/${publishedQuiz.quizId}">${publishedQuiz.name}</a></td>
                        <td>${publishedQuiz.questionsNumber}</td>
                        <td>${publishedQuiz.score}</td>
                        <td><localDate:format value="${publishedQuiz.creationDate}"/></td>
                        <td class="text-center"><a href="#">Unpublish</a></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" value="Back" onclick="window.history.go(-1);">Back</button>
    <br>
</div>
</body>
</html>
