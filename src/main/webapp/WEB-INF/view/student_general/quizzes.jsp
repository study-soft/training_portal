<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
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
    <h2>Quizzes</h2>
    <form>
        <input class="form-control col-4" type="search" placeholder="Search..." aria-label="Search">
    </form>
    <h3>Opened quizzes</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have opened quizzes. Say your teachers to give you some
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 30%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 20%">Submit date</th>
                    <th style="width: 30%">Author</th>
                </tr>
                <c:forEach items="${openedQuizzes}" var="openedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${openedQuiz.quizId}">${openedQuiz.quizName}</a></td>
                        <td>${openedQuiz.questionsNumber}</td>
                        <td>${openedQuiz.score}</td>
                        <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
                        <td>${openedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Passed quizzes</h3>
    <c:choose>
        <c:when test="${empty passedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have passed quizzes
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 30%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 20%">Submit date</th>
                    <th style="width: 30%">Author</th>
                </tr>
                <c:forEach items="${passedQuizzes}" var="passedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${passedQuiz.quizId}">${passedQuiz.quizName}</a></td>
                        <td>${passedQuiz.questionsNumber}</td>
                        <td>${passedQuiz.score}</td>
                        <td><localDateTime:format value="${passedQuiz.submitDate}"/></td>
                        <td>${passedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Finished quizzes</h3>
    <c:choose>
        <c:when test="${empty finishedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have closed quizzes
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 30%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 20%">Submit date</th>
                    <th style="width: 30%">Author</th>
                </tr>
                <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${finishedQuiz.quizId}">${finishedQuiz.quizName}</a></td>
                        <td>${finishedQuiz.questionsNumber}</td>
                        <td>${finishedQuiz.score}</td>
                        <td><localDateTime:format value="${finishedQuiz.submitDate}"/></td>
                        <td>${finishedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
