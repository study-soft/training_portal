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
                        var closedQuizzes = $("#closedQuizzes");
                        closedQuizzes.append(copiedSelectedRow);
                        closedQuizzes.find("td").last().remove();
                    }
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
        <input type="search" class="col-4 form-control" placeholder="Search...">
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
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 7.5%">Score</th>
                    <th style="width: 22.5%">Submit date</th>
                    <th style="width: 35%">Author</th>
                </tr>
                <c:forEach items="${openedQuizzes}" var="openedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${openedQuiz.quizId}">${openedQuiz.quizName}</a></td>
                        <td>${openedQuiz.questionsNumber}</td>
                        <td>${openedQuiz.score}</td>
                        <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
                        <td>${openedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
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
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 7.5%">Score</th>
                    <th style="width: 22.5%">Submit date</th>
                    <th style="width: 25%">Author</th>
                    <th style="width: 10%"></th>
                </tr>
                <c:forEach items="${passedQuizzes}" var="passedQuiz">
                    <tr>
                        <td>
                            <a href="/student/quizzes/${passedQuiz.quizId}">${passedQuiz.quizName}</a>
                        </td>
                        <td>${passedQuiz.questionsNumber}</td>
                        <td>${passedQuiz.score}</td>
                        <td><localDateTime:format value="${passedQuiz.submitDate}"/></td>
                        <td>${passedQuiz.authorName}</td>
                        <td>
                            <button type="submit" value="${passedQuiz.quizId}" class="success-button">
                                <i class="fa fa-close"></i> Close
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Closed quizzes</h3>
    <c:choose>
        <c:when test="${empty closedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have closed quizzes
            </div>
        </c:when>
        <c:otherwise>
            <table id="closedQuizzes" class="table">
                <tr>
                    <th style="width: 25%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 7.5%">Score</th>
                    <th style="width: 22.5%">Submit date</th>
                    <th style="width: 35%">Author</th>
                </tr>
                <c:forEach items="${closedQuizzes}" var="closedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${closedQuiz.quizId}">${closedQuiz.quizName}</a></td>
                        <td>${closedQuiz.questionsNumber}</td>
                        <td>${closedQuiz.score}</td>
                        <td><localDateTime:format value="${closedQuiz.submitDate}"/></td>
                        <td>${closedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
