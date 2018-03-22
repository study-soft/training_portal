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
                    var html = 'You should <a href="/student/quizzes/${sessionScope.currentQuiz.quizId}/passing">continue</a> ' +
                        'or <a href="/student/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">finish</a> ' +
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
    <h2>${passedQuiz.quizName}</h2>
    <div class="highlight-success">
        <img src="/resources/icon-success.png" width="25" height="25" class="icon-one-row">
        This quiz is passed
    </div>
    <h3>Information about result</h3>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Result</td>
            <td class="table-home">${passedQuiz.result} / ${passedQuiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">Time spent</td>
            <td class="table-home"><duration:format value="${passedQuiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td class="table-home">Attempts</td>
            <td class="table-home">${passedQuiz.attempt}</td>
        </tr>
        <tr>
            <td class="table-home">Finished</td>
            <td class="table-home"><localDateTime:format value="${passedQuiz.finishDate}"/> </td>
        </tr>
    </table>
    <h3>Information about quiz</h3>
    <c:if test="${passedQuiz.description ne null}">
        <div class="col-6"><strong>Description: </strong>${passedQuiz.description}</div>
    </c:if>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Submitted</td>
            <td class="table-home"><localDateTime:format value="${passedQuiz.submitDate}"/></td>
        </tr>
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
        <tr>
            <td class="table-home">Author</td>
            <td class="table-home">${passedQuiz.authorName}</td>
        </tr>
    </table>
    <div class="highlight-primary">
        <img src="/resources/icon-primary.png" width="25" height="25" class="icon-two-rows">
        <div class="inline">If you are satisfied with your result, you need to finish quiz</div>
        <div class="non-first-row">Also you can try again but score will be less</div>
    </div>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <a href="/student/quizzes/${passedQuiz.quizId}/answers" class="btn btn-primary">Answers</a>
        <a href="/student/compare-results/${passedQuiz.quizId}" class="btn btn-primary">Results</a>
        <a href="/student/quizzes/${passedQuiz.quizId}/repass" id="repass" class="btn btn-success">Repass</a>
        <input type="submit" value="Finish"> Don't work
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
                      action="/student/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <input type="submit" id="yes" class="btn btn-primary" value="Yes">
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
