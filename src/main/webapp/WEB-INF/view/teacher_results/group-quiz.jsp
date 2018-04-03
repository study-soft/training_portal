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
    <h2><a href="/teacher/groups/${group.groupId}">${group.name}</a></h2>
    <h2><a href="/teacher/quizzes/${quiz.quizId}">${quiz.name}</a></h2>
    <c:choose>
        <c:when test="${not empty openedStudents or not empty passedStudents}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                There are students who pass this quiz with different quiz status
            </div>
        </c:when>
        <c:otherwise>
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                All students in this group closed this quiz
            </div>
        </c:otherwise>
    </c:choose>
    <c:if test="${not empty openedStudents}">
        <h4>Opened</h4>
        <table id="openedQuizzes" class="table">
            <tr>
                <th style="width: 18%">Name</th>
                <th style="width: 21%">Submitted</th>
                <th colspan="4" style="width: 51%"></th>
                <th style="width: 10%"></th>
            </tr>
            <c:forEach items="${openedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${openedQuizzes[i].submitDate}"/></td>
                    <td colspan="4"></td>
                    <td>
                        <button class="danger-button" value="${student.userId}">
                            <i class="fa fa-close"></i> Close
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty passedStudents}">
        <h4>Passed</h4>
        <table id="passedQuizzes" class="table">
            <tr>
                <th style="width: 18%">Name</th>
                <th style="width: 21%">Submitted</th>
                <th style="width: 21%;">Passed</th>
                <th style="width: 9%">Result</th>
                <th style="width: 9%">Attempt</th>
                <th style="width: 12%">Time spent</th>
                <th style="width: 10%"></th>
            </tr>
            <c:forEach items="${passedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${passedQuizzes[i].submitDate}"/></td>
                    <td><localDateTime:format value="${passedQuizzes[i].finishDate}"/></td>
                    <td>${passedQuizzes[i].result} / ${passedQuizzes[i].score}</td>
                    <td>${passedQuizzes[i].attempt}</td>
                    <td><duration:format value="${passedQuizzes[i].timeSpent}"/></td>
                    <td>
                        <button class="danger-button" value="${student.userId}">
                            <i class="fa fa-close"></i> Close
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty closedStudents}">
        <h4>Closed</h4>
        <table id="closedQuizzes" class="table">
            <tr>
                <th style="width: 18%">Name</th>
                <th style="width: 21%">Submitted</th>
                <th style="width: 21%;">Passed</th>
                <th style="width: 9%">Result</th>
                <th style="width: 9%">Attempt</th>
                <th style="width: 22%">Time spent</th>
            </tr>
            <c:forEach items="${closedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${closedQuizzes[i].submitDate}"/></td>
                    <td><localDateTime:format value="${closedQuizzes[i].finishDate}"/></td>
                    <td>${closedQuizzes[i].result} / ${closedQuizzes[i].score}</td>
                    <td>${closedQuizzes[i].attempt}</td>
                    <td><duration:format value="${closedQuizzes[i].timeSpent}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
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
