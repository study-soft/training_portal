<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Repass quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var percent = "${passedQuiz.attempt * 10}";
            var attempt = $("#attempt");
            var repass = $("#repass");
            if (percent >= 100) {
                attempt.text("You used maximum number of attempts and need to close quiz");
                repass.remove();
            }
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${passedQuiz.quizName}</h2>
    <h3>Information about result</h3>
    <table class="col-6 table-info">
        <tr>
            <td>Result</td>
            <td>${passedQuiz.result} / ${passedQuiz.score}</td>
        </tr>
        <tr>
            <td>Time spent</td>
            <td><duration:format value="${passedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td>Attempts</td>
            <td>${passedQuiz.attempt}</td>
        </tr>
    </table>
    <h3>Information about passing</h3>
    <table class="col-6 table-info">
        <tr>
            <td>Passing time</td>
            <td><duration:format value="${passedQuiz.passingTime}"/></td>
        </tr>
        <tr>
            <td>Number of questions</td>
            <td>${passedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Total score</td>
            <td>${passedQuiz.score}</td>
        </tr>
    </table>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-four-rows">
        <div class="inline">If you press "Repass" you will begin repassing the quiz</div>
        <div id="attempt" class="non-first-row">Your total score will be less on ${passedQuiz.attempt * 10}%</div>
        <div class="non-first-row">If you press "Close" you will close quiz with current result</div>
        <div class="non-first-row">If you do not want to repass it than press "Back"</div>
    </div>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${passedQuiz.quizId}/initialize" id="repass"
           class="btn btn-success">Repass</a>
        <form class="inline" action="/student/quizzes/${passedQuiz.quizId}" method="post">
            <input type="submit" value="Close" class="btn btn-success"/>
        </form>
    </div>
</div>
<br>
</body>
</html>
