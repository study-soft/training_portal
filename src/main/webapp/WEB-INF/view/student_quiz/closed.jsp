<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.closed"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const closedStudents = "${closedStudents}";
            const allStudents = "${allStudents}";
            const answers = $("#answers");
            if ("${allStudents}" !== "1" && closedStudents !== allStudents) {
                const message = '<spring:message code="quiz.closed.wait"/>: ${closedStudents} / ${allStudents}';
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
    <div id="close-success" class="col-sm-4 mx-auto text-center correct update-success">
        <spring:message code="quiz.closed.success"/>
        <button id="close" class="close">&times;</button>
    </div>
    <h2><c:out value="${closedQuiz.quizName}"/></h2>
    <div class="row no-gutters align-items-center highlight-primary">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="quiz.closed"/>
        </div>
    </div>
    <h4><spring:message code="quiz.info.result"/></h4>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="quiz.result"/></td>
            <td>${closedQuiz.result}/${closedQuiz.score}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.time.spent"/></td>
            <td><duration:format value="${closedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td><spring:message code="quiz.attempts"/></td>
            <td>${closedQuiz.attempt}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.passed"/></td>
            <td><localDateTime:format value="${closedQuiz.finishDate}"/></td>
        </tr>
    </table>
    <h4><spring:message code="quiz.info.quiz"/></h4>
    <c:if test="${closedQuiz.description ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="quiz.description"/>: </strong><c:out value="${closedQuiz.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="quiz.submitted"/></td>
            <td><localDateTime:format value="${closedQuiz.submitDate}"/></td>
        </tr>
        <c:if test="${closedQuiz.passingTime ne null}">
            <tr>
                <td><spring:message code="quiz.passing.time"/></td>
                <td><duration:format value="${closedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td><spring:message code="quiz.questions"/></td>
            <td>${closedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.score"/></td>
            <td>${closedQuiz.score}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.author"/></td>
            <td>${closedQuiz.authorName}</td>
        </tr>
    </table>
    <c:if test="${closedQuiz.explanation ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="quiz.explanation"/>: </strong><c:out value="${closedQuiz.explanation}"/>
        </div>
    </c:if>
    <button id="back" class="btn btn-primary"><spring:message code="back"/></button>
    <span id="answers">
        <a href="/student/quizzes/${closedQuiz.quizId}/answers" class="btn btn-primary btn-wide disabled">
            <i class="fa fa-ban red"></i> <spring:message code="quiz.answers"/>
        </a>
    </span>
    <c:if test="${allStudents ne 1 and allStudents ne 0}">
        <a href="/student/results/${closedQuiz.quizId}" class="btn btn-primary btn-wide">
            <spring:message code="quiz.results"/>
        </a>
    </c:if>
</div>
<br>
</body>
</html>
