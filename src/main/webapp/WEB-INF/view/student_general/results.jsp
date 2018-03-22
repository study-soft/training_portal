<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Results</h2>
    <form>
        <input class="form-control col-4" type="search" placeholder="Search..." aria-label="Search">
    </form>
    <h3>Passed quizzes</h3>
    <c:choose>
        <c:when test="${empty passedQuizzes}">
            <div>You have finally completed all your quizzes</div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Result</th>
                    <th style="width: 10%">Attempt</th>
                    <th style="width: 13.33%">Time spent</th>
                    <th style="width: 25%">Finish date</th>
                    <th style="width: 8.33%"></th>
                    <th style="width: 8.33%">ВЫПИЛИТЬ</th>
                </tr>
                <c:forEach items="${passedQuizzes}" var="passedQuiz">
                    <tr>
                        <td>${passedQuiz.quizName}</td>
                        <td>${passedQuiz.result} / ${passedQuiz.score}</td>
                        <td>${passedQuiz.attempt}</td>
                        <td><duration:format value="${passedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${passedQuiz.finishDate}"/></td>
                        <td><a href="/student/quizzes/${passedQuiz.quizId}/repass">Repass</a></td>
                        <td>
                            <form action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="submit" value="Finish"/>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Finished quizzes</h3>
    <c:choose>
        <c:when test="${empty finishedQuizzes}">
            <div>You do not have finished quizzes.</div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 30%">Name</th>
                    <th style="width: 13.33%">Result</th>
                    <th style="width: 13.33%">Attempt</th>
                    <th style="width: 13.33%">Time spent</th>
                    <th style="width: 30%">Finish date</th>
                </tr>
                <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
                    <tr>
                        <td>${finishedQuiz.quizName}</td>
                        <td>${finishedQuiz.result} / ${finishedQuiz.score}</td>
                        <td>${finishedQuiz.attempt}</td>
                        <td><duration:format value="${finishedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${finishedQuiz.finishDate}"/></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <div>
        <a href="/student/compare-results" class="btn btn-primary">Compare</a>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>