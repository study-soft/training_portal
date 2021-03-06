<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.group.results"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("button:has(i[class='fa fa-close'])").click(function () {
                window.scrollTo(0, 0);
                $("#yes").data("quizId", $(this).val());
                const quizName = $(this).parent().siblings().first().text();
                $(".modal-body").text('<spring:message code="quiz.result.sure.close"/> \'' + quizName.trim() +
                    '\' <spring:message code="quiz.result.to.group"/> \'${group.name}\'?');
                $("#modal").modal();
            });

            $("#yes").click(function () {
                $("#modal").modal("toggle");
                const quizId = $(this).data("quizId");
                $.ajax({
                    type: "POST",
                    url: "/teacher/results/group/${group.groupId}/close",
                    data: "quizId=" + quizId,
                    success: function (closedQuizInfo) {
                        const closedQuizName = closedQuizInfo[0];
                        const closingDate = closedQuizInfo[1];
                        const passedQuizzes = $("#passedQuizzes");
                        const closedQuizzes = $("#closedQuizzes");

                        passedQuizzes.find("a:contains(" + closedQuizName + ")").parents("tr").remove();

                        if (closedQuizzes.length === 0) {
                            passedQuizzes.after(
                                '<h3><spring:message code="quiz.result.results.closed"/>\n' +
                                '<table id="closedQuizzes" class="table">\n' +
                                '    <tr>\n' +
                                '        <th style="width: 50%"><spring:message code="quiz.name"/></th>\n' +
                                '        <th style="width: 50%"><spring:message code="quiz.result.closing.date"/></th>\n' +
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

                        if (passedQuizzes.find("tr").length === 2) {
                            passedQuizzes.prev().remove();
                            passedQuizzes.remove();
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
                <td><spring:message code="group.students.number"/></td>
                <td>${studentsNumber}</td>
            </tr>
        </table>
    </div>
    <c:if test="${not empty passedQuizzes}">
        <h3><spring:message code="quiz.result.progress.passed"/></h3>
        <table id="passedQuizzes" class="table">
            <tr>
                <th></th>
                <th colspan="4" class="text-center"><spring:message code="quiz.students"/></th>
                <th></th>
            </tr>
            <tr>
                <th style="width: 30%;"><spring:message code="quiz.quiz.name"/></th>
                <th style="width: 12.5%"><spring:message code="quiz.result.total"/></th>
                <th style="width: 12.5%;"><spring:message code="quiz.result.opened"/></th>
                <th style="width: 12.5%;"><spring:message code="quiz.result.passed"/></th>
                <th style="width: 12.5%;"><spring:message code="quiz.result.closed"/></th>
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
                            <i class="fa fa-close"></i> <spring:message code="quiz.result.close.all"/>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty closedQuizzes}">
        <h3><spring:message code="quiz.result.results.closed"/></h3>
        <table id="closedQuizzes" class="table">
            <tr>
                <th style="width: 50%"><spring:message code="quiz.name"/></th>
                <th style="width: 50%"><spring:message code="quiz.result.closing.date"/></th>
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
    <button class="btn btn-primary" onclick="window.history.go(-1)"><spring:message code="back"/></button>

    <div id="modal" class="modal fade" tabindex="-1" role="dialog"
         aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel"><spring:message code="attention"/></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <spring:message code="no"/>
                    </button>
                    <button id="yes" type="button" class="btn btn-primary">
                        <spring:message code="yes"/>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
