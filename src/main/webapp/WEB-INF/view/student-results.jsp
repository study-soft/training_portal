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
                    <td>${passedQuiz.timeSpent.toMinutes()} mins</td>
                    <td>${passedQuiz.finishDate}</td>
                    <td><a href="#">Repass</a></td>
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
                    <td>${finishedQuiz.timeSpent.toMinutes()} mins</td>
                    <td>${finishedQuiz.finishDate}</td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
<div>
    <a href="#">Compare results</a>
</div>
<div>
    <a href="/student">Back</a>
</div>
</body>
</html>