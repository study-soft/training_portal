<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("button:contains(Close)").click(function () {
                var quizId = $(this).val();
                $("#yes").val(quizId);
                var quizName = $(this).parent().siblings().first().text();
                $(".modal-body").text("Are you sure you want to close '" +
                    quizName + "' quiz to ${student.lastName} ${student.firstName}?");
                $("#modal").modal();
            });

            $("#yes").click(function () {
                $("#modal").modal("toggle");
                var quizId = $("#yes").val();
                $.ajax({
                    type: "POST",
                    url: "/teacher/students/${student.userId}/close",
                    data: "quizId=" + quizId,
                    success: function (closedQuizInfo) {
                        var selectedRow = $("#selectedQuiz" + quizId).children();
                        if (selectedRow.last().prev().text() === "OPENED") {
                            for (var i = 0; i < 4; i++) {
                                $(selectedRow[i + 1]).text(closedQuizInfo[i]);
                            }
                        }
                        selectedRow.last().empty();
                        selectedRow.last().prev().text("CLOSED");
                    }
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${student.lastName} ${student.firstName}</h2>
    <table class="col-6 table-info">
        <tr>
            <td>E-mail</td>
            <td>${student.email}</td>
        </tr>
        <tr>
            <td>Phone number</td>
            <td>${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td>Date of birth</td>
                <td><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
        <c:if test="${group ne null}">
            <tr>
                <td>Group</td>
                <td>${group.name}</td>
            </tr>
        </c:if>
    </table>
    <h3>You gave ${student.firstName} next quizzes:</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty closedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                There is no quizzes for ${student.firstName}.
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th>Name</th>
                    <th>Result</th>
                    <th>Attempt</th>
                    <th>Time spent</th>
                    <th>Passed</th>
                    <th>Status</th>
                    <th></th>
                </tr>
                <c:forEach items="${openedQuizzes}" var="openedQuiz">
                    <tr id="selectedQuiz${openedQuiz.quizId}">
                        <td>
                            <a href="/teacher/quizzes/${openedQuiz.quizId}">${openedQuiz.quizName}</a>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>OPENED</td>
                        <td>
                            <button class="danger-button" value="${openedQuiz.quizId}">
                                <i class="fa fa-close"></i> Close
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${passedQuizzes}" var="passedQuiz">
                    <tr id="selectedQuiz${passedQuiz.quizId}">
                        <td>
                            <a href="/teacher/quizzes/${passedQuiz.quizId}">${passedQuiz.quizName}</a>
                        </td>
                        <td>${passedQuiz.result}/${passedQuiz.score}</td>
                        <td>${passedQuiz.attempt}</td>
                        <td><duration:format value="${passedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${passedQuiz.finishDate}"/></td>
                        <td>PASSED</td>
                        <td>
                            <button class="danger-button" value="${passedQuiz.quizId}">
                                <i class="fa fa-close"></i> Close
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${closedQuizzes}" var="closedQuiz">
                    <tr>
                        <td>
                            <a href="/teacher/quizzes/${closedQuiz.quizId}">${closedQuiz.quizName}</a>
                        </td>
                        <td>${closedQuiz.result}/${closedQuiz.score}</td>
                        <td>${closedQuiz.attempt}</td>
                        <td><duration:format value="${closedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${closedQuiz.finishDate}"/></td>
                        <td>CLOSED</td>
                        <td></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>

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
                    <form id="deleteForm" action="" method="post">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                        <button type="button" id="yes" class="btn btn-primary" value="">Yes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
