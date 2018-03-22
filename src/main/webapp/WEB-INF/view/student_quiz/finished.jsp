<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Finished quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${finishedQuiz.quizName}</h2>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-one-row">
        This quiz is finished
    </div>
    <h3>Information about result</h3>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Result</td>
            <td class="table-home">${finishedQuiz.result}/${finishedQuiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">Time spent</td>
            <td class="table-home"><duration:format value="${finishedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td class="table-home">Attempts</td>
            <td class="table-home">${finishedQuiz.attempt}</td>
        </tr>
        <tr>
            <td class="table-home">Finished</td>
            <td class="table-home"><localDateTime:format value="${finishedQuiz.finishDate}"/> </td>
        </tr>
    </table>
    <h3>Information about quiz</h3>
    <c:if test="${finishedQuiz.description ne null}">
        <div class="col-6"><strong>Description: </strong>${finishedQuiz.description}</div>
    </c:if>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Submitted</td>
            <td class="table-home"><localDateTime:format value="${finishedQuiz.submitDate}"/></td>
        </tr>
        <tr>
            <td class="table-home">Passing time</td>
            <td class="table-home"><duration:format value="${finishedQuiz.passingTime}"/></td>
        </tr>
        <tr>
            <td class="table-home">Number of questions</td>
            <td class="table-home">${finishedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td class="table-home">Total score</td>
            <td class="table-home">${finishedQuiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">Author</td>
            <td class="table-home">${finishedQuiz.authorName}</td>
        </tr>
    </table>
    <c:if test="${finishedQuiz.explanation ne null}">
        <div class="col-6"><strong>Explanation: </strong>${finishedQuiz.explanation}</div>
    </c:if>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${finishedQuiz.quizId}/answers" class="btn btn-primary">Answers</a>
        <a href="/student/compare-results/${finishedQuiz.quizId}" class="btn btn-primary">Results</a>
    </div>
</div>
<br>
</body>
</html>
