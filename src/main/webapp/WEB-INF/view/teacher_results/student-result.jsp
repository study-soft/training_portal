<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.student.info"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("button:has(i[class='fa fa-close'])").click(function () {
                window.scrollTo(0, 0);
                let quizId = $(this).val();
                $("#yes").val(quizId);
                let quizName = $(this).parent().siblings().first().text();
                $(".modal-body").text('<spring:message code="quiz.result.sure.close"/> \'' +
                    quizName.trim() + '\'' + ' <spring:message code="quiz.result.to.student"/>' +
                    ' \'${student.lastName} ${student.firstName}\'?');
                $("#modal").modal();
            });

            $("#yes").click(function () {
                $("#modal").modal("toggle");
                let quizId = $("#yes").val();
                $.ajax({
                    type: "POST",
                    url: "/teacher/students/${student.userId}/close",
                    data: "quizId=" + quizId,
                    success: function (closedQuizInfo) {
                        let openedQuizzes = $("#openedQuizzes");
                        let passedQuizzes = $("#passedQuizzes");
                        let closedQuizzes = $("#closedQuizzes");

                        // Insert closedQuizzes table header
                        if (closedQuizzes.length === 0 && passedQuizzes.length === 0) {
                            openedQuizzes.after('<h4><spring:message code="quiz.quizzes.closed"/></h4>\n' +
                                '                <table id="closedQuizzes" class="table">\n' +
                                '                    <tr>\n' +
                                '                        <th style="width: 18%"><spring:message code="quiz.name"/></th>\n' +
                                '                        <th style="width: 20%"><spring:message code="quiz.submitted"/></th>\n' +
                                '                        <th style="width: 20%"><spring:message code="quiz.passed"/></th>\n' +
                                '                        <th style="width: 9%"><spring:message code="quiz.result"/></th>\n' +
                                '                        <th style="width: 9%"><spring:message code="quiz.attempt"/></th>\n' +
                                '                        <th style="width: 24%"><spring:message code="quiz.time.spent"/></th>\n' +
                                '                    </tr>\n' +
                                '                </table>');
                        } else if (closedQuizzes.length === 0) {
                            passedQuizzes.after('<h4><spring:message code="quiz.quizzes.closed"/></h4>\n' +
                                '                <table id="closedQuizzes" class="table">\n' +
                                '                    <tr>\n' +
                                '                        <th style="width: 18%"><spring:message code="quiz.name"/></th>\n' +
                                '                        <th style="width: 20%"><spring:message code="quiz.submitted"/></th>\n' +
                                '                        <th style="width: 20%;"><spring:message code="quiz.passed"/></th>\n' +
                                '                        <th style="width: 9%"><spring:message code="quiz.result"/></th>\n' +
                                '                        <th style="width: 9%"><spring:message code="quiz.attempt"/></th>\n' +
                                '                        <th style="width: 24%"><spring:message code="quiz.time.spent"/></th>\n' +
                                '                    </tr>\n' +
                                '                </table>');
                        }

                        // Insert row to closedQuizzes table
                        if (closedQuizInfo.length === 0) {
                            // Case passed
                            let row = passedQuizzes.find("a[href*=" + quizId + "]").parents("tr");
                            row.children().last().remove();
                            let copy = row.clone();
                            row.remove();
                            $("#closedQuizzes").append(copy);
                            if (passedQuizzes.find("tr").length === 1) {
                                passedQuizzes.prev().remove();
                                passedQuizzes.remove();
                            }
                        } else {
                            // Case opened
                            let row = openedQuizzes.find("a[href*=" + quizId + "]").parents("tr");
                            let quizName = row.children().first().text();
                            let submitted = row.children().first().next().text();
                            let passed = closedQuizInfo[0];
                            let result = closedQuizInfo[1];
                            let attempt = closedQuizInfo[2];
                            let timeSpent = closedQuizInfo[3];
                            row.remove();
                            $("#closedQuizzes").append('<tr>\n' +
                                '                            <td>\n' +
                                '                                <a href="/teacher/quizzes/' + quizId + '">' + quizName + '</a>\n' +
                                '                            </td>\n' +
                                '                            <td>' + submitted + '</td>\n' +
                                '                            <td>' + passed + '</td>\n' +
                                '                            <td>' + result + '</td>\n' +
                                '                            <td>' + attempt + '</td>\n' +
                                '                            <td>' + timeSpent + '</td>\n' +
                                '                         </tr>');
                            if (openedQuizzes.find("tr").length === 1) {
                                openedQuizzes.prev().remove();
                                openedQuizzes.remove();
                            }
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
    <h2>${student.lastName} ${student.firstName}</h2>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="user.mail"/></td>
            <td>${student.email}</td>
        </tr>
        <tr>
            <td><spring:message code="user.phone"/></td>
            <td>${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td><spring:message code="user.birthday"/></td>
                <td><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
        <c:if test="${group ne null}">
            <tr>
                <td><spring:message code="user.group"/></td>
                <td>${group.name}</td>
            </tr>
        </c:if>
    </table>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty closedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.result.no.quizzes.for.student"/> ${student.firstName}
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
                    <spring:message code="quiz.result.you.published"/> ${student.firstName}
                </div>
            </div>
            <c:if test="${not empty openedQuizzes}">
                <h4><spring:message code="quiz.quizzes.opened"/></h4>
                <table id="openedQuizzes" class="table">
                    <tr>
                        <th style="width: 18%"><spring:message code="quiz.name"/></th>
                        <th style="width: 31%"><spring:message code="quiz.submitted"/></th>
                        <th colspan="4" style="width: 39%"></th>
                        <th style="width: 12%;"></th>
                    </tr>
                    <c:forEach items="${openedQuizzes}" var="openedQuiz">
                        <tr>
                            <td>
                                <a href="/teacher/quizzes/${openedQuiz.quizId}">${openedQuiz.quizName}</a>
                            </td>
                            <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
                            <td colspan="4"></td>
                            <td>
                                <button class="danger-button" value="${openedQuiz.quizId}">
                                    <i class="fa fa-close"></i> <spring:message code="quiz.result.close"/>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            <c:if test="${not empty passedQuizzes}">
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
                    <c:forEach items="${passedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/teacher/quizzes/${quiz.quizId}">${quiz.quizName}</a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td><localDateTime:format value="${quiz.finishDate}"/></td>
                            <td>${quiz.result}/${quiz.score}</td>
                            <td>${quiz.attempt}</td>
                            <td><duration:format value="${quiz.timeSpent}"/></td>
                            <td>
                                <button class="danger-button" value="${quiz.quizId}">
                                    <i class="fa fa-close"></i> <spring:message code="quiz.result.close"/>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            <c:if test="${not empty closedQuizzes}">
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
                    <c:forEach items="${closedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/teacher/quizzes/${quiz.quizId}">${quiz.quizName}</a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td><localDateTime:format value="${quiz.finishDate}"/></td>
                            <td>${quiz.result}/${quiz.score}</td>
                            <td>${quiz.attempt}</td>
                            <td><duration:format value="${quiz.timeSpent}"/></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
        </c:otherwise>
    </c:choose>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
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
                    <form id="deleteForm" action="" method="post">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <spring:message code="no"/>
                        </button>
                        <button type="button" id="yes" class="btn btn-primary" value="">
                            <spring:message code="yes"/>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
