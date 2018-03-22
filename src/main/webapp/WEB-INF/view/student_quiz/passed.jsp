<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Passed quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${passedQuiz.quizName}</h2>
    <div class="highlight-success">
        <img src="/resources/icon-success.png" width="25" height="25" class="icon-one-row">
        This quiz is passed
    </div>
    <h3>Information about result</h3>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Result</td>
            <td class="table-home">${passedQuiz.result}/${passedQuiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">Time spent</td>
            <td class="table-home"><duration:format value="${passedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td class="table-home">Attempts</td>
            <td class="table-home">${passedQuiz.attempt}</td>
        </tr>
        <tr>
            <td class="table-home">Finished</td>
            <td class="table-home"><localDateTime:format value="${passedQuiz.finishDate}"/> </td>
        </tr>
    </table>
    <h3>Information about quiz</h3>
    <c:if test="${passedQuiz.description ne null}">
        <div class="col-6"><strong>Description: </strong>${passedQuiz.description}</div>
    </c:if>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Submitted</td>
            <td class="table-home"><localDateTime:format value="${passedQuiz.submitDate}"/></td>
        </tr>
        <tr>
            <td class="table-home">Passing time</td>
            <td class="table-home"><duration:format value="${passedQuiz.passingTime}"/></td>
        </tr>
        <tr>
            <td class="table-home">Number of questions</td>
            <td class="table-home">${passedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td class="table-home">Total score</td>
            <td class="table-home">${passedQuiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">Author</td>
            <td class="table-home">${passedQuiz.authorName}</td>
        </tr>
    </table>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-two-rows">
        <div class="inline">If you are satisfied with your result, you need to finish quiz</div>
        <div class="non-first-row">Also you can try again but score will be less</div>
    </div>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${passedQuiz.quizId}/answers" class="btn btn-primary">Answers</a>
        <a href="/student/compare-results/${passedQuiz.quizId}" class="btn btn-primary">Results</a>
        <a href="/student/quizzes/${passedQuiz.quizId}/repass" class="btn btn-success">Repass</a>
        <form class="inline" action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="submit" value="Finish">
        </form>
    </div>
</div>
<br>
</body>
</html>
