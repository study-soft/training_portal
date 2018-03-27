<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Start quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${openedQuiz.quizName}</h2>
    <table class="col-6 table-info">
        <c:if test="${openedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${openedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Number of questions</td>
            <td>${openedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Total score</td>
            <td>${openedQuiz.score}</td>
        </tr>
    </table>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-two-rows">
        <div class="inline">If you press "Start" you will begin passing the quiz</div>
        <div class="non-first-row">If you do not want to pass it than press "Back"</div>
    </div>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${openedQuiz.quizId}/initialize" class="btn btn-success">Start</a>
    </div>
</div>
<br>
</body>
</html>
