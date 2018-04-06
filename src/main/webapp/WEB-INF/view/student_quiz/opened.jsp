<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Opened quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("#start").click(function (event) {
                var currentQuiz = "${sessionScope.currentQuiz.name}";
                if (currentQuiz) {
                    event.preventDefault();
                    var currentQuestion = "${sessionScope.currentQuestionSerial}";
                    var questionsNumber = "${sessionScope.questionsNumber - 1}";
                    var html = 'You should <a href="/quizzes/${sessionScope.currentQuiz.quizId}/passing">continue</a> ' +
                        'or <a href="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">finish</a> ' +
                        '<strong>' + currentQuiz + '</strong> quiz' +
                        '<br> You have answered only ' + currentQuestion + " / " +
                        questionsNumber + ' questions yet';
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
    <h2>${openedQuiz.quizName}</h2>
    <div class="highlight-success">
        <img src="/resources/icon-success.png" width="25" height="25" class="icon-one-row">
        This quiz is opened
    </div>
    <h3>Information about quiz</h3>
    <c:if test="${openedQuiz.description ne null}">
        <div class="col-lg-6"><strong>Description: </strong>${openedQuiz.description}</div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Submitted</td>
            <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
        </tr>
        <c:if test="${openedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${openedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Total score</td>
            <td>${openedQuiz.score}</td>
        </tr>
        <tr>
            <td>Number of questions</td>
            <td>${openedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Author</td>
            <td>${openedQuiz.authorName}</td>
        </tr>
    </table>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a id="start" href="/student/quizzes/${openedQuiz.quizId}/start" class="btn btn-success">Start</a>
    </div>
</div>
<br>
<div class="modal fade" id="modal" tabindex="-1" role="dialog"
     aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalLabel">Attention</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <form id="congratulationsForm" method="post"
                      action="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <input type="submit" id="yes" class="btn btn-primary" value="Yes">
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
