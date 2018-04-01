<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
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
    <h2>Results</h2>
    <div class="input-group">
        <input type="search" class="col-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
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
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 35%">Name</th>
                    <th style="width: 10%">Result</th>
                    <th style="width: 10%">Attempt</th>
                    <th style="width: 15%">Time spent</th>
                    <th style="width: 22%">Passed</th>
                    <th style="width: 8%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${passedQuizzes}" var="passedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${passedQuiz.quizId}">${passedQuiz.quizName}</a></td>
                        <td>${passedQuiz.result} / ${passedQuiz.score}</td>
                        <td>${passedQuiz.attempt}</td>
                        <td><duration:format value="${passedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${passedQuiz.finishDate}"/></td>
                        <c:choose>
                            <c:when test="${fn:contains(notSinglePassedQuizzes, passedQuiz)}">
                                <td><a href="/student/results/${passedQuiz.quizId}">Compare</a></td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
                </tbody>
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
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 35%">Name</th>
                    <th style="width: 10%">Result</th>
                    <th style="width: 10%">Attempt</th>
                    <th style="width: 15%">Time spent</th>
                    <th style="width: 22%">Passed</th>
                    <th style="width: 8%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${closedQuizzes}" var="closedQuiz">
                    <tr>
                        <td><a href="/student/quizzes/${closedQuiz.quizId}">${closedQuiz.quizName}</a></td>
                        <td>${closedQuiz.result} / ${closedQuiz.score}</td>
                        <td>${closedQuiz.attempt}</td>
                        <td><duration:format value="${closedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${closedQuiz.finishDate}"/></td>
                        <c:choose>
                            <c:when test="${fn:contains(notSingleClosedQuizzes, closedQuiz)}">
                                <td><a href="/student/results/${closedQuiz.quizId}">Compare</a></td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
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