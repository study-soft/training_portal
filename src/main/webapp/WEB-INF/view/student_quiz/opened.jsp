<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Opened quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${openedQuiz.quizName}</h2>
    <div class="highlight-success">
        <img src="/resources/icon-success.png" width="25" height="25" class="icon-one-row">
        This quiz is opened
    </div>
    <h3>Information about quiz</h3>
    <div class="col-6"><strong>Description: </strong>${openedQuiz.description}</div>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Submitted</td>
            <td class="table-home"><localDateTime:format value="${openedQuiz.submitDate}"/></td>
        </tr>
        <tr>
            <td class="table-home">Passing time</td>
            <td class="table-home"><duration:format value="${openedQuiz.passingTime}"/></td>
        </tr>
        <tr>
            <td class="table-home">Total score</td>
            <td class="table-home">${openedQuiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">Number of questions</td>
            <td class="table-home">${openedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td class="table-home">Author</td>
            <td class="table-home">${openedQuiz.authorName}</td>
        </tr>
    </table>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${openedQuiz.quizId}/start" class="btn btn-success">Start</a>
    </div>
</div>
<br>
</body>
</html>
