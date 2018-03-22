<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Repass quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${passedQuiz.quizName}</h2>
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
    </table>
    <h3>Information about passing</h3>
    <table class="col-6 table-home">
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
    </table>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-four-rows">
        <div class="inline">If you press "Repass" you will begin repassing the quiz</div>
        <div class="non-first-row">Your total score will be less on ${passedQuiz.attempt * 10}%</div>
        <div class="non-first-row">If you press "Finish" you will finish quiz with current result</div>
        <div class="non-first-row">If you do not want to repass it than press "Back"</div>
    </div>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${passedQuiz.quizId}/initialize" class="btn btn-success">Repass</a>
        <form class="inline" action="/student/quizzes/${passedQuiz.quizId}/finished" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="submit" value="Finish"/>
        </form>
    </div>
</div>
<br>
</body>
</html>
