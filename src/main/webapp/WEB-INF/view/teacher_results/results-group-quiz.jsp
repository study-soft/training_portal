<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz results</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("td[id]").each(function () {
                if (this.id === "/OPENED") {
                    $(this).text("");
                }
                if (this.id === "OPENED" || this.id === "PASSED") {
                    $(this).find("button").html('<i class="fa fa-close"></i> Close');
                }
            });

            $("button:contains(Close)").click(function () {
                var studentName = $(this).val();
                var studentId = $(this).parents("tr").attr("id").replace("selectedStudent", "");
                $("#yes").val(studentId);
                $(".modal-body").text("Are you sure you want to close " +
                    "'${quiz.name}' quiz to " + studentName + "?");
                $("#modal").modal();
            });

            $("#yes").click(function () {
                $("#modal").modal("toggle");
                var studentId = $("#yes").val();
                $.ajax({
                    type: "POST",
                    url: "/teacher/results/group/${group.groupId}/quiz/${quiz.quizId}/close",
                    data: "studentId=" + studentId,
                    success: function (closedQuizInfo) {
                        var selectedRow = $("#selectedStudent" + studentId).children();
                        if (selectedRow.last().prev().text() === "OPENED") {
                            for (var i = 0; i < 4; i++) {
                                selectedRow[i].text(closedQuizInfo[i]);
                            }
                        }
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
    <h3><a href="/teacher/groups/${group.groupId}">${group.name}</a></h3>
    <h3><a href="/teacher/quizzes/${quiz.quizId}">${quiz.name}</a></h3>
    <table class="table">
        <tr>
            <th style="width: 25%">Name</th>
            <th style="width: 10%">Result</th>
            <th style="width: 10%">Attempt</th>
            <th style="width: 12.5%">Time spent</th>
            <th style="width: 22.5%">Passed</th>
            <th style="width: 10%">Status</th>
            <th style="width: 10%"></th>
        </tr>
        <c:forEach items="${students}" var="student" varStatus="status">
            <c:set var="i" value="${status.index}"/>
            <tr id="selectedStudent${student.userId}">
                <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                <td id="/${statusList[i]}">${results[i].result} / ${results[i].score}</td>
                <td>${results[i].attempt}</td>
                <td><duration:format value="${results[i].timeSpent}"/></td>
                <td><localDateTime:format value="${results[i].finishDate}"/></td>
                <td>${statusList[i]}</td>
                <td id="${statusList[i]}">
                    <button type="button" class="danger-button"
                            value="${student.lastName} ${student.firstName}"></button>
                </td>
            </tr>
        </c:forEach>
    </table>
    <button class="btn btn-primary" onclick="window.history.go(-1)">Back</button>

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
