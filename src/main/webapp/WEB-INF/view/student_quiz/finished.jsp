<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Finished quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var finishSuccess = "${finishSuccess}";
            if (finishSuccess) {
                $("#finish-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#finish-success").fadeOut("slow");
            });

            $("#back").click(function () {
                var currentUri = window.location.href;
                var previousUri = document.referrer;
                if (currentUri === previousUri) {
                    window.history.go(-2);
                } else {
                    window.history.go(-1);
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="finish-success" class="col-4 mx-auto text-center correct edit-success">
        Quiz successfully finished
        <button id="close" class="close">&times;</button>
    </div>
    <h2>${finishedQuiz.quizName}</h2>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-one-row">
        This quiz is finished
    </div>
    <h3>Information about result</h3>
    <table class="col-6 table-info">
        <tr>
            <td>Result</td>
            <td>${finishedQuiz.result} / ${finishedQuiz.score}</td>
        </tr>
        <tr>
            <td>Time spent</td>
            <td><duration:format value="${finishedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td>Attempts</td>
            <td>${finishedQuiz.attempt}</td>
        </tr>
        <tr>
            <td>Finished</td>
            <td><localDateTime:format value="${finishedQuiz.finishDate}"/> </td>
        </tr>
    </table>
    <h3>Information about quiz</h3>
    <c:if test="${finishedQuiz.description ne null}">
        <div class="col-6"><strong>Description: </strong>${finishedQuiz.description}</div>
    </c:if>
    <table class="col-6 table-info">
        <tr>
            <td>Submitted</td>
            <td><localDateTime:format value="${finishedQuiz.submitDate}"/></td>
        </tr>
        <tr>
            <td>Passing time</td>
            <td><duration:format value="${finishedQuiz.passingTime}"/></td>
        </tr>
        <tr>
            <td>Number of questions</td>
            <td>${finishedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Total score</td>
            <td>${finishedQuiz.score}</td>
        </tr>
        <tr>
            <td>Author</td>
            <td>${finishedQuiz.authorName}</td>
        </tr>
    </table>
    <c:if test="${finishedQuiz.explanation ne null}">
        <div class="col-6"><strong>Explanation: </strong>${finishedQuiz.explanation}</div>
    </c:if>
    <div>
        <button id="back" value="Back" class="btn btn-primary">Back</button>
        <a href="/student/quizzes/${finishedQuiz.quizId}/answers" class="btn btn-primary">Answers</a>
        <a href="/student/compare-results/${finishedQuiz.quizId}" class="btn btn-primary">Results</a>
    </div>
</div>
<br>
</body>
</html>
