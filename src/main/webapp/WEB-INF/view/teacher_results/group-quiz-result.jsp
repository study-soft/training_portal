<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.results"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("button:has(i[class='fa fa-close'])").click(function () {
                window.scrollTo(0, 0);
                const studentId = $(this).val();
                let firstTd = $(this).parent().siblings().first();
                const studentName = firstTd.find("a").text();
                const submitDate = firstTd.next().text();

                $("#yes").data("studentId", studentId)
                    .data("studentName", studentName)
                    .data("submitDate", submitDate);

                $(".modal-body").text('<spring:message code="quiz.result.sure.close"/> \'${quiz.name}\' ' +
                    '<spring:message code="quiz.result.to.student"/> \'' + studentName.trim() + '\'?');
                $("#modal").modal();
            });

            $("#yes").click(function () {
                $("#modal").modal("toggle");

                const studentId = $(this).data("studentId");
                const studentName = $(this).data("studentName");
                const submitDate = $(this).data("submitDate");
                const groupId = window.location.pathname.split("/")[4];

                $.ajax({
                    type: "POST",
                    url: "/teacher/results/group/" + groupId + "/quiz/${quiz.quizId}/close",
                    data: "studentId=" + studentId,
                    success: function (closedQuizInfo) {
                        if ($("#closedQuizzes").length === 0) {
                            $("#insertClosedQuizzesHere").after(
                                '<h4><spring:message code="quiz.quizzes.closed"/></h4>\n' +
                                '<table id="closedQuizzes" class="table">\n' +
                                '    <tr>\n' +
                                '        <th style="width: 18%"><spring:message code="quiz.name"/></th>\n' +
                                '        <th style="width: 20%"><spring:message code="quiz.submitted"/></th>\n' +
                                '        <th style="width: 20%;"><spring:message code="quiz.passed"/></th>\n' +
                                '        <th style="width: 9%"><spring:message code="quiz.result"/></th>\n' +
                                '        <th style="width: 9%"><spring:message code="quiz.attempt"/></th>\n' +
                                '        <th style="width: 24%"><spring:message code="quiz.time.spent"/></th>\n' +
                                '    </tr>\n' +
                                '</table>\n');
                        }

                        if (closedQuizInfo.length !== 0) {
                            // closing opened quiz
                            const finishDate = closedQuizInfo[0];
                            const result = closedQuizInfo[1];
                            const attempt = closedQuizInfo[2];
                            const timeSpent = closedQuizInfo[3];

                            $("#closedQuizzes").append(
                                '<tr>\n' +
                                '    <td>\n' +
                                '        <a href="/teacher/students/' + studentId + '">' + studentName + '</a>\n' +
                                '    </td>\n' +
                                '    <td>' + submitDate + '</td>\n' +
                                '    <td>' + finishDate + '</td>\n' +
                                '    <td>' + result + '</td>\n' +
                                '    <td>' + attempt + '</td>\n' +
                                '    <td>' + timeSpent + '</td>\n' +
                                '</tr>\n');

                            const openedQuizzes = $("#openedQuizzes");
                            openedQuizzes.find("a:contains(" + studentName + ")")
                                .parents("tr").remove();
                            if (openedQuizzes.find("tr").length === 1) {
                                openedQuizzes.prev().remove();
                                openedQuizzes.remove();
                            }
                        } else {
                            // closing passed quiz
                            const passedQuizzes = $("#passedQuizzes");
                            const selectedRow = passedQuizzes
                                .find("a:contains(" + studentName + ")")
                                .parents("tr");
                            const rowToInsert = selectedRow.clone();
                            rowToInsert.find("td").last().remove();

                            $("#closedQuizzes").append(rowToInsert);

                            selectedRow.remove();
                            if (passedQuizzes.find("tr").length === 1) {
                                passedQuizzes.prev().remove();
                                passedQuizzes.remove();
                            }
                        }

                        if ($("#passedQuizzes").length === 0 && $("#openedQuizzes").length === 0) {
                            $("#info").html(
                                '<div class="col-auto mr-3">\n' +
                                '   <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                '       width="25" height="25">\n' +
                                '</div>\n' +
                                '<div class="col">\n' +
                                '   <spring:message code="quiz.result.students.closed"/>\n' +
                                '</div>\n');
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
    <h2><a href="/teacher/quizzes/${quiz.quizId}">${quiz.name}</a></h2>
    <c:choose>
        <c:when test="${not empty openedStudents or not empty passedStudents}">
            <div id="info" class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.result.students.passes"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.result.students.closed"/>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <c:if test="${not empty openedStudents}">
        <h4><spring:message code="quiz.quizzes.opened"/></h4>
        <table id="openedQuizzes" class="table">
            <tr>
                <th style="width: 18%"><spring:message code="quiz.name"/></th>
                <th style="width: 20%"><spring:message code="quiz.submitted"/></th>
                <th colspan="4" style="width: 50%"></th>
                <th style="width: 12%"></th>
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
                            <i class="fa fa-close"></i> <spring:message code="quiz.result.close"/>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty passedStudents}">
        <h4><spring:message code="quiz.quizzes.passed"/></h4>
        <table id="passedQuizzes" class="table">
            <tr>
                <th style="width: 18%"><spring:message code="quiz.name"/></th>
                <th style="width: 20%"><spring:message code="quiz.submitted"/></th>
                <th style="width: 20%;"><spring:message code="quiz.passed"/></th>
                <th style="width: 9%"><spring:message code="quiz.result"/></th>
                <th style="width: 9%"><spring:message code="quiz.attempt"/></th>
                <th style="width: 12%"><spring:message code="quiz.time.spent"/></th>
                <th style="width: 12%"></th>
            </tr>
            <c:forEach items="${passedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${passedQuizzes[i].submitDate}"/></td>
                    <td><localDateTime:format value="${passedQuizzes[i].finishDate}"/></td>
                    <td>${passedQuizzes[i].result}/${passedQuizzes[i].score}</td>
                    <td>${passedQuizzes[i].attempt}</td>
                    <td><duration:format value="${passedQuizzes[i].timeSpent}"/></td>
                    <td>
                        <button class="danger-button" value="${student.userId}">
                            <i class="fa fa-close"></i> <spring:message code="quiz.result.close"/>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <span id="insertClosedQuizzesHere"></span>
    <c:if test="${not empty closedStudents}">
        <h4><spring:message code="quiz.quizzes.closed"/></h4>
        <table id="closedQuizzes" class="table">
            <tr>
                <th style="width: 18%"><spring:message code="quiz.name"/></th>
                <th style="width: 20%"><spring:message code="quiz.submitted"/></th>
                <th style="width: 20%;"><spring:message code="quiz.passed"/></th>
                <th style="width: 9%"><spring:message code="quiz.result"/></th>
                <th style="width: 9%"><spring:message code="quiz.attempt"/></th>
                <th style="width: 24%"><spring:message code="quiz.time.spent"/></th>
            </tr>
            <c:forEach items="${closedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${closedQuizzes[i].submitDate}"/></td>
                    <td><localDateTime:format value="${closedQuizzes[i].finishDate}"/></td>
                    <td>${closedQuizzes[i].result}/${closedQuizzes[i].score}</td>
                    <td>${closedQuizzes[i].attempt}</td>
                    <td><duration:format value="${closedQuizzes[i].timeSpent}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1)"><spring:message code="back"/></button>
    </div>

    <div class="modal fade" id="modal" tabindex="-1" role="dialog"
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
                    <button type="button" id="yes" class="btn btn-primary" value="">
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
