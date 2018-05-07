<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Passed quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("#repass").click(function (event) {
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
    <h2><c:out value="${passedQuiz.quizName}"/></h2>
    <div class="row no-gutters align-items-center highlight-success">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-success.png"
                 width="25" height="25">
        </div>
        <div class="col">
            This quiz is passed
        </div>
    </div>
    <h4>Information about result</h4>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Result</td>
            <td>${passedQuiz.result}/${passedQuiz.score}</td>
        </tr>
        <tr>
            <td>Time spent</td>
            <td><duration:format value="${passedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td>Attempts</td>
            <td>${passedQuiz.attempt}</td>
        </tr>
        <tr>
            <td>Passed</td>
            <td><localDateTime:format value="${passedQuiz.finishDate}"/></td>
        </tr>
    </table>
    <h4>Information about quiz</h4>
    <c:if test="${passedQuiz.description ne null}">
        <div class="col-lg-6">
            <strong>Description: </strong><c:out value="${passedQuiz.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Submitted</td>
            <td><localDateTime:format value="${passedQuiz.submitDate}"/></td>
        </tr>
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
        <tr>
            <td>Author</td>
            <td>${passedQuiz.authorName}</td>
        </tr>
    </table>
    <div class="row no-gutters align-items-center highlight-primary">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                 width="25" height="25">
        </div>
        <div class="col">
            If you are satisfied with your result, you need to close quiz
            <br>Also you can tru again but score will be less
        </div>
    </div>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    <c:if test="${allStudents ne 1}">
        <a href="/student/results/${passedQuiz.quizId}" class="btn btn-primary">Results</a>
    </c:if>
    <a href="/student/quizzes/${passedQuiz.quizId}/repass" id="repass" class="btn btn-success">Repass</a>
    <form class="inline" action="/student/quizzes/${passedQuiz.quizId}" method="post">
        <input type="submit" value="Close" class="btn btn-success">
    </form>
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
