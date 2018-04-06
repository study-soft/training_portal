<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $('button:contains(Close)').click(function (event) {
                event.preventDefault();
                var quizId = $(this).val();
                var button = $(this);
                $.ajax({
                    type: "POST",
                    url: "/student/quizzes/" + quizId + "/close",
                    success: function () {
                        var selectedRow = button.parents("tr");
                        var quizName = selectedRow.children().first().find("a").text();
                        var copiedSelectedRow = selectedRow.clone();
                        selectedRow.remove();
                        var passedQuizzes = $("#passedQuizzes");
                        if (passedQuizzes.find("tr").length === 1) {
                            passedQuizzes.after('<div class="highlight-primary">\n' +
                                '                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                '                     width="25" height="25" class="icon-one-row">\n' +
                                '                You do not have passed quizzes\n' +
                                '            </div>');
                            passedQuizzes.remove();
                        }
                        alert("Quiz '" + quizName + "' successfully closed");
                        var closedQuizzesBody = $("#closedQuizzes").find("tbody");
                        if (closedQuizzesBody.length === 0) {
                            var info = $("#noClosedQuizzesInfo");
                            info.after(
                                '<table id="closedQuizzes" class="table">\n' +
                                '    <thead>\n' +
                                '    <tr>\n' +
                                '        <th style="width: 25%">Name</th>\n' +
                                '        <th style="width: 10%">Questions</th>\n' +
                                '        <th style="width: 7.5%">Score</th>\n' +
                                '        <th style="width: 22.5%">Submit date</th>\n' +
                                '        <th style="width: 35%">Author</th>\n' +
                                '    </tr>\n' +
                                '    </thead>\n' +
                                '    <tbody>\n' +
                                '    </tbody>\n' +
                                '</table>');
                            info.remove();
                            closedQuizzesBody = $("#closedQuizzes").find("tbody");
                        }
                        closedQuizzesBody.append(copiedSelectedRow);
                        closedQuizzesBody.find("td").last().remove();
                    }
                });
            });

            $("input[type=search]").on("keyup", function () {
                var value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Quizzes</h2>
    <div class="input-group">
        <input type="search" class="col-sm-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <h3>Opened quizzes</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have opened quizzes. Say your teachers to give you some
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 7.5%">Score</th>
                    <th style="width: 22.5%">Submit date</th>
                    <th style="width: 35%">Author</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${openedQuizzes}" var="openedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${openedQuiz.quizId}">${openedQuiz.quizName}</a></td>
                        <td>${openedQuiz.questionsNumber}</td>
                        <td>${openedQuiz.score}</td>
                        <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
                        <td>${openedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Passed quizzes</h3>
    <c:choose>
        <c:when test="${empty passedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have passed quizzes
            </div>
        </c:when>
        <c:otherwise>
            <table id="passedQuizzes" class="table">
                <thead>
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 7.5%">Score</th>
                    <th style="width: 22.5%">Submit date</th>
                    <th style="width: 25%">Author</th>
                    <th style="width: 10%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${passedQuizzes}" var="quiz">
                    <tr>
                        <td>
                            <a href="/student/quizzes/${quiz.quizId}">${quiz.quizName}</a>
                        </td>
                        <td>${quiz.questionsNumber}</td>
                        <td>${quiz.score}</td>
                        <td><localDateTime:format value="${quiz.submitDate}"/></td>
                        <td>${quiz.authorName}</td>
                        <td>
                            <button type="submit" value="${quiz.quizId}" class="success-button">
                                <i class="fa fa-close"></i> Close
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Closed quizzes</h3>
    <c:choose>
        <c:when test="${empty closedQuizzes}">
            <div id="noClosedQuizzesInfo" class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have closed quizzes
            </div>
        </c:when>
        <c:otherwise>
            <table id="closedQuizzes" class="table">
                <thead>
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 7.5%">Score</th>
                    <th style="width: 22.5%">Submit date</th>
                    <th style="width: 35%">Author</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${closedQuizzes}" var="quiz">
                    <tr>
                        <td><a href="/student/quizzes/${quiz.quizId}">${quiz.quizName}</a></td>
                        <td>${quiz.questionsNumber}</td>
                        <td>${quiz.score}</td>
                        <td><localDateTime:format value="${quiz.submitDate}"/></td>
                        <td>${quiz.authorName}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
