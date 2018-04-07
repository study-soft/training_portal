<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group results</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("button:contains(Close all)").click(function () {
                $("#yes").data("quizId", $(this).val());
                var quizName = $(this).parent().siblings().first().text();
                $(".modal-body").text("Are you sure you want to close '" + quizName +
                    "' quiz to group '${group.name}'?");
                $("#modal").modal();
            });

            $("#yes").click(function () {
                $("#modal").modal("toggle");
                var quizId = $(this).data("quizId");
                $.ajax({
                    type: "POST",
                    url: "/teacher/results/group/${group.groupId}/close",
                    data: "quizId=" + quizId,
                    success: function (closedQuizInfo) {
                        var closedQuizName = closedQuizInfo[0];
                        var closingDate = closedQuizInfo[1];
                        var passedQuizzes = $("#passedQuizzes");
                        var closedQuizzes = $("#closedQuizzes");

                        passedQuizzes.find("a:contains(" + closedQuizName + ")").parents("tr").remove();

                        if (closedQuizzes.length === 0) {
                            passedQuizzes.after(
                                '<h3>Results of closed quizzes</h3>\n' +
                                '<table id="closedQuizzes" class="table">\n' +
                                '    <tr>\n' +
                                '        <th style="width: 50%">Name</th>\n' +
                                '        <th style="width: 50%">Closing date</th>\n' +
                                '    </tr>\n' +
                                '    <tr>\n' +
                                '        <td>\n' +
                                '            <a href="/teacher/results/group/${group.groupId}/quiz/'
                                                    + quizId + '">' + closedQuizName + '</a>\n' +
                                '        </td>\n' +
                                '        <td>' + closingDate + '</td>\n' +
                                '    </tr>\n' +
                                '</table>');
                        } else {
                            closedQuizzes.append(
                            '<tr>\n' +
                            '    <td>\n' +
                            '        <a href="/teacher/results/group/${group.groupId}/quiz/'
                                        + quizId + '">' + closedQuizName + '</a>\n' +
                            '    </td>\n' +
                            '    <td>' + closingDate + '</td>\n' +
                            '</tr>\n');
                        }
                    }
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><a href="/teacher/groups/${group.groupId}">${group.name}</a></h2>
    <div class="col-sm-6">
        <table class="table-info">
            <tr>
                <td>Number of students</td>
                <td>${studentsNumber}</td>
            </tr>
        </table>
    </div>
    <c:if test="${not empty passedQuizzes}">
        <h3>Progress of passed quizzes</h3>
        <table id="passedQuizzes" class="table">
            <tr>
                <th></th>
                <th colspan="4" class="text-center">Students</th>
                <th></th>
            </tr>
            <tr>
                <th style="width: 30%;">Quiz name</th>
                <th style="width: 12.5%">Total</th>
                <th style="width: 12.5%;">Opened</th>
                <th style="width: 12.5%;">Passed</th>
                <th style="width: 12.5%;">Closed</th>
                <th style="width: 20%"></th>
            </tr>
            <c:forEach items="${passedQuizzes}" var="quiz" varStatus="status">
                <c:set var="map" value="${quizStudents[status.index]}"/>
                <tr>
                    <td>
                        <a href="/teacher/results/group/${group.groupId}/quiz/${quiz.quizId}">${quiz.name}</a>
                    </td>
                    <td>${map['TOTAL']}</td>
                    <td>${map['OPENED']}</td>
                    <td>${map['PASSED']}</td>
                    <td>${map['CLOSED']}</td>
                    <td>
                        <button type="button" value="${quiz.quizId}" class="danger-button">
                            <i class="fa fa-close"></i> Close all
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty closedQuizzes}">
        <h3>Results of closed quizzes</h3>
        <table id="closedQuizzes" class="table">
            <tr>
                <th style="width: 50%">Name</th>
                <th style="width: 50%">Closing date</th>
            </tr>
            <c:forEach items="${closedQuizzes}" var="quiz" varStatus="status">
                <tr>
                    <td>
                        <a href="/teacher/results/group/${group.groupId}/quiz/${quiz.quizId}">${quiz.name}</a>
                    </td>
                    <td><localDateTime:format value="${closingDates[status.index]}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <button class="btn btn-primary" onclick="window.history.go(-1)">Back</button>

    <div id="modal" class="modal fade" tabindex="-1" role="dialog"
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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <button id="yes" type="button" class="btn btn-primary">Yes</button>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
