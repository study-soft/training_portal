<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Results</h2>
<div>Search...</div>
<div>Passed quizzes</div>
<c:choose>
    <c:when test="${empty passedQuizzes}">
        <div>You have finally completed all your quizzes</div>
    </c:when>
    <c:otherwise>
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
                    <td>${passedQuiz.result}/${passedQuiz.score}</td>
                    <td>${passedQuiz.attempt}</td>
                    <td><duration:format value="${passedQuiz.timeSpent}"/></td>
                    <td><localDateTime:format value="${passedQuiz.finishDate}"/></td>
                    <td><a href="/student/quizzes/${passedQuiz.quizId}/initialize">Repass</a></td>
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
<br>
<div>Finished quizzes</div>
<c:choose>
    <c:when test="${empty finishedQuizzes}">
        <div>You do not have finished quizzes.</div>
    </c:when>
    <c:otherwise>
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
                    <td><duration:format value="${finishedQuiz.timeSpent}"/></td>
                    <td><localDateTime:format value="${finishedQuiz.finishDate}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<div>
    <a href="/student/compare-results">Compare results</a>
</div>
<div>
    <a href="/student">Back</a>
</div>
</body>
</html>