<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Closed quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var closedStudents = "${closedStudents}";
            var allStudents = "${allStudents}";
            var answers = $("#answers");
            if ("${allStudents}" !== "1" && closedStudents !== allStudents) {
                var message = "You have to wait until all students in your group close this quiz. " +
                    "Closed students: ${closedStudents} / ${allStudents}";
                answers.addClass("d-inline-block");
                answers.attr("tabindex", "0");
                answers.attr("data-toggle", "tooltip");
                answers.attr("data-placement", "top");
                answers.attr("title", message);
                answers.tooltip();
            } else {
                answers.find("a").removeClass("disabled");
                answers.find("i").remove();
            }
        });
    </script>
    <script>
        $(document).ready(function () {
            var closeSuccess = "${closeSuccess}";
            if (closeSuccess) {
                $("#close-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#close-success").fadeOut("slow");
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
    <div id="close-success" class="col-4 mx-auto text-center correct update-success">
        Quiz successfully closed
        <button id="close" class="close">&times;</button>
    </div>
    <h2>${closedQuiz.quizName}</h2>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-one-row">
        This quiz is closed
    </div>
    <h3>Information about result</h3>
    <table class="col-6 table-info">
        <tr>
            <td>Result</td>
            <td>${closedQuiz.result} / ${closedQuiz.score}</td>
        </tr>
        <tr>
            <td>Time spent</td>
            <td><duration:format value="${closedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td>Attempts</td>
            <td>${closedQuiz.attempt}</td>
        </tr>
        <tr>
            <td>Passed</td>
            <td><localDateTime:format value="${closedQuiz.finishDate}"/></td>
        </tr>
    </table>
    <h3>Information about quiz</h3>
    <c:if test="${closedQuiz.description ne null}">
        <div class="col-6"><strong>Description: </strong>${closedQuiz.description}</div>
    </c:if>
    <table class="col-6 table-info">
        <tr>
            <td>Submitted</td>
            <td><localDateTime:format value="${closedQuiz.submitDate}"/></td>
        </tr>
        <c:if test="${closedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${closedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Number of questions</td>
            <td>${closedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Total score</td>
            <td>${closedQuiz.score}</td>
        </tr>
        <tr>
            <td>Author</td>
            <td>${closedQuiz.authorName}</td>
        </tr>
    </table>
    <c:if test="${closedQuiz.explanation ne null}">
        <div class="col-6"><strong>Explanation: </strong>${closedQuiz.explanation}</div>
    </c:if>
    <button id="back" value="Back" class="btn btn-primary">Back</button>
    <span id="answers">
            <a href="/student/quizzes/${closedQuiz.quizId}/answers"
               class="btn btn-primary disabled"><i class="fa fa-ban error"></i> Answers</a>
        </span>
    <c:if test="${allStudents ne 1}">
        <a href="/student/results/${closedQuiz.quizId}" class="btn btn-primary">Results</a>
    </c:if>
</div>
<br>
</body>
</html>
