<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.opened"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("#start").click(function (event) {
                window.scrollTo(0, 0);
                let currentQuiz = "${sessionScope.currentQuiz.name}";
                if (currentQuiz) {
                    event.preventDefault();
                    let currentQuestion = "${sessionScope.currentQuestionSerial}";
                    let questionsNumber = "${sessionScope.questionsNumber - 1}";
                    let html = '<spring:message code="quiz.continue.you.should"/> ' +
                        '<a href="/quizzes/${sessionScope.currentQuiz.quizId}/passing"><spring:message code="quiz.continue.continue"/></a> ' +
                        '<spring:message code="quiz.continue.or"/> ' +
                        '<a href="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations"><spring:message code="quiz.continue.finish"/></a> ' +
                        '<spring:message code="quiz.continue.quiz"/>&nbsp;\'<strong>' + currentQuiz + '</strong>\'' +
                        '<br><spring:message code="quiz.continue.answered"/> ' + currentQuestion + ' / ' +
                        questionsNumber + ' <spring:message code="quiz.continue.questions"/>';
                    $(".modal-body").html(html);
                    $("#modal").modal();
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${openedQuiz.quizName}"/></h2>
    <div class="row no-gutters align-items-center highlight-success">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icons/icon-success.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="quiz.opened"/>
        </div>
    </div>
    <h4><spring:message code="quiz.info.quiz"/></h4>
    <c:if test="${openedQuiz.description ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="quiz.description"/>: </strong><c:out value="${openedQuiz.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="quiz.submitted"/></td>
            <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
        </tr>
        <c:if test="${openedQuiz.passingTime ne null}">
            <tr>
                <td><spring:message code="quiz.passing.time"/></td>
                <td><duration:format value="${openedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td><spring:message code="quiz.score"/></td>
            <td>${openedQuiz.score}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.total.questions"/></td>
            <td>${openedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.author"/></td>
            <td>${openedQuiz.authorName}</td>
        </tr>
    </table>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
        <a id="start" href="/student/quizzes/${openedQuiz.quizId}/start" class="btn btn-success">
            <spring:message code="quiz.start"/>
        </a>
    </div>
</div>
<br>
<div class="modal fade" id="modal" tabindex="-1" role="dialog"
     aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalLabel"><spring:message code="back"/></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <form id="congratulationsForm" method="post"
                      action="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <spring:message code="no"/>
                    </button>
                    <input type="submit" id="yes" class="btn btn-primary" value="<spring:message code="yes"/>">
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
