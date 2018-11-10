<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.repass"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            let percent = "${passedQuiz.attempt * 10}";
            let attempt = $("#attempt");
            let repass = $("#repass");
            if (percent >= 100) {
                attempt.text('<spring:message code="quiz.max.attempts"/>');
                repass.remove();
            }
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${passedQuiz.quizName}"/></h2>
    <h4><spring:message code="quiz.info.result"/></h4>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="quiz.result"/></td>
            <td>${passedQuiz.result}/${passedQuiz.score}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.time.spent"/></td>
            <td><duration:format value="${passedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td><spring:message code="quiz.attempts"/></td>
            <td>${passedQuiz.attempt}</td>
        </tr>
    </table>
    <h4><spring:message code="quiz.info.quiz"/></h4>
    <table class="col-lg-6 table-info">
        <c:if test="${passedQuiz.passingTime ne null}">
            <tr>
                <td><spring:message code="quiz.passing.time"/></td>
                <td><duration:format value="${passedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td><spring:message code="quiz.total.questions"/></td>
            <td>${passedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.score"/></td>
            <td>${passedQuiz.score}</td>
        </tr>
    </table>
    <div class="row no-gutters align-items-center highlight-primary">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="quiz.press.repass"/>
            <br><span id="attempt"><spring:message code="quiz.score.less"/> ${passedQuiz.attempt * 10}%</span>
            <br><spring:message code="quiz.press.back"/>
        </div>
    </div>
    <div class="row no-gutters align-items-center highlight-danger">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="quiz.prev.result"/>
        </div>
    </div>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
        <a href="/quizzes/${passedQuiz.quizId}/initialize" id="repass"
           class="btn btn-success btn-wide"><spring:message code="quiz.repass"/></a>
    </div>
</div>
<br>
</body>
</html>
