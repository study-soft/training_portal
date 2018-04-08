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
    <h4>Information about result</h4>
    <table class="col-lg-6 table-info">
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
    <h4>Information about passing</h4>
    <table class="col-lg-6 table-info">
        <c:if test="${passedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${passedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Number of questions</td>
            <td>${passedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Total score</td>
            <td>${passedQuiz.score}</td>
        </tr>
    </table>
    <div class="row no-gutters align-items-center highlight-primary">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                 width="25" height="25">
        </div>
        <div class="col">
            If you press "Repass" you will begin repassing the quiz
            <br><span id="attempt">Your total score will be less on ${passedQuiz.attempt * 10}%</span>
            <br>If you do not want to repass quiz than press "Back"
        </div>
    </div>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/quizzes/${passedQuiz.quizId}/initialize" id="repass"
           class="btn btn-success">Repass</a>
    </div>
</div>
<br>
</body>
</html>
