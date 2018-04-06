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
                        var openedQuizzes = $("#openedQuizzes");
                        var passedQuizzes = $("#passedQuizzes");
                        var closedQuizzes = $("#closedQuizzes");

                        // Insert closedQuizzes table header
                        if (closedQuizzes.length === 0 && passedQuizzes.length === 0) {
                            openedQuizzes.after('<h4>Closed</h4>\n' +
                                '                <table id="closedQuizzes" class="table">\n' +
                                '                    <tr>\n' +
                                '                        <th style="width: 18%">Name</th>\n' +
                                '                        <th style="width: 21%">Submitted</th>\n' +
                                '                        <th style="width: 21%;">Passed</th>\n' +
                                '                        <th style="width: 9%">Result</th>\n' +
                                '                        <th style="width: 9%">Attempt</th>\n' +
                                '                        <th style="width: 22%">Time spent</th>\n' +
                                '                    </tr>\n' +
                                '                </table>');
                        } else if (closedQuizzes.length === 0) {
                            passedQuizzes.after('<h4>Closed</h4>\n' +
                                '                <table id="closedQuizzes" class="table">\n' +
                                '                    <tr>\n' +
                                '                        <th style="width: 18%">Name</th>\n' +
                                '                        <th style="width: 21%">Submitted</th>\n' +
                                '                        <th style="width: 21%;">Passed</th>\n' +
                                '                        <th style="width: 9%">Result</th>\n' +
                                '                        <th style="width: 9%">Attempt</th>\n' +
                                '                        <th style="width: 22%">Time spent</th>\n' +
                                '                    </tr>\n' +
                                '                </table>');
                        }

                        // Insert row to closedQuizzes table
                        if (closedQuizInfo.length === 0) {
                            // Case passed
                            var row = passedQuizzes.find("a[href*=" + quizId + "]").parents("tr");
                            row.children().last().remove();
                            var copy = row.clone();
                            row.remove();
                            $("#closedQuizzes").append(copy);
                            if (passedQuizzes.find("tr").length === 1) {
                                passedQuizzes.prev().remove();
                                passedQuizzes.remove();
                            }
                        } else {
                            // Case opened
                            var row = openedQuizzes.find("a[href*=" + quizId + "]").parents("tr");
                            var quizName = row.children().first().text();
                            var submitted = row.children().first().next().text();
                            var passed = closedQuizInfo[0];
                            var result = closedQuizInfo[1];
                            var attempt = closedQuizInfo[2];
                            var timeSpent = closedQuizInfo[3];
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
            <c:if test="${not empty openedQuizzes}">
                <h4>Opened</h4>
                <table id="openedQuizzes" class="table">
                    <tr>
                        <th style="width: 18%">Name</th>
                        <th style="width: 32%">Submitted</th>
                        <th colspan="4" style="width: 40%"></th>
                        <th style="width: 10%;"></th>
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
                                    <i class="fa fa-close"></i> Close
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            <c:if test="${not empty passedQuizzes}">
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
                    <c:forEach items="${passedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/teacher/quizzes/${quiz.quizId}">${quiz.quizName}</a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td><localDateTime:format value="${quiz.finishDate}"/></td>
                            <td>${quiz.result} / ${quiz.score}</td>
                            <td>${quiz.attempt}</td>
                            <td><duration:format value="${quiz.timeSpent}"/></td>
                            <td>
                                <button class="danger-button" value="${quiz.quizId}">
                                    <i class="fa fa-close"></i> Close
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            <c:if test="${not empty closedQuizzes}">
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
                    <c:forEach items="${closedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/teacher/quizzes/${quiz.quizId}">${quiz.quizName}</a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td><localDateTime:format value="${quiz.finishDate}"/></td>
                            <td>${quiz.result} / ${quiz.score}</td>
                            <td>${quiz.attempt}</td>
                            <td><duration:format value="${quiz.timeSpent}"/></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
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
