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
    <form>
        <input class="form-control col-4" type="search" placeholder="Search..." aria-label="Search">
    </form>
    <h3>Opened quizzes</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes}">
            <div>You do not have any opened quizzes. Say your teachers to give you some</div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 8.33%">Questions</th>
                    <th style="width: 8.33%">Score</th>
                    <th style="width: 25%">Submit date</th>
                    <th style="width: 25%">Author</th>
                    <th style="width: 8.33%"></th>
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
            <table class="table">
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 8.33%">Questions</th>
                    <th style="width: 8.33%">Score</th>
                    <th style="width: 25%">Submit date</th>
                    <th style="width: 25%">Author</th>
                    <th style="width: 8.33%"></th>
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
            <table class="table">
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 8.33%">Questions</th>
                    <th style="width: 8.33%">Score</th>
                    <th style="width: 25%">Submit date</th>
                    <th style="width: 25%">Author</th>
                    <th style="width: 8.33%"></th>
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
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
