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
        <input type="search" class="col-sm-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty closedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    You do not have results
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:if test="${not empty openedQuizzes}">
                <h4>Opened quizzes</h4>
                <table class="table">
                    <thead>
                    <tr>
                        <th style="width: 18%">Name</th>
                        <th style="width: 32%">Submitted</th>
                        <th colspan="4" style="width: 40%"></th>
                        <th style="width: 10%"></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${openedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/student/quizzes/${quiz.quizId}">
                                    <c:out value="${quiz.quizName}"/>
                                </a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td colspan="4"></td>
                            <c:choose>
                                <c:when test="${fn:contains(notSingleOpenedQuizzes, quiz)}">
                                    <td><a href="/student/results/${quiz.quizId}">Compare</a></td>
                                </c:when>
                                <c:otherwise>
                                    <td></td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${not empty passedQuizzes}">
                <h4>Passed quizzes</h4>
                <table class="table">
                    <thead>
                    <tr>
                        <th style="width: 18%">Name</th>
                        <th style="width: 21%">Submitted</th>
                        <th style="width: 21%">Passed</th>
                        <th style="width: 9%;">Result</th>
                        <th style="width: 9%">Attempt</th>
                        <th style="width: 12%">Time spent</th>
                        <th style="width: 10%"></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${passedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/student/quizzes/${quiz.quizId}">
                                    <c:out value="${quiz.quizName}"/>
                                </a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td><localDateTime:format value="${quiz.finishDate}"/></td>
                            <td>${quiz.result}/${quiz.score}</td>
                            <td>${quiz.attempt}</td>
                            <td><duration:format value="${quiz.timeSpent}"/></td>
                            <c:choose>
                                <c:when test="${fn:contains(notSinglePassedQuizzes, quiz)}">
                                    <td><a href="/student/results/${quiz.quizId}">Compare</a></td>
                                </c:when>
                                <c:otherwise>
                                    <td></td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${not empty closedQuizzes}">
                <h4>Closed quizzes</h4>
                <table class="table">
                    <thead>
                    <tr>
                        <th style="width: 18%">Name</th>
                        <th style="width: 21%">Submitted</th>
                        <th style="width: 21%">Passed</th>
                        <th style="width: 9%;">Result</th>
                        <th style="width: 9%">Attempt</th>
                        <th style="width: 12%">Time spent</th>
                        <th style="width: 10%"></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${closedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/student/quizzes/${quiz.quizId}">
                                    <c:out value="${quiz.quizName}"/>
                                </a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td><localDateTime:format value="${quiz.finishDate}"/></td>
                            <td>${quiz.result}/${quiz.score}</td>
                            <td>${quiz.attempt}</td>
                            <td><duration:format value="${quiz.timeSpent}"/></td>
                            <c:choose>
                                <c:when test="${fn:contains(notSingleClosedQuizzes, quiz)}">
                                    <td><a href="/student/results/${quiz.quizId}">Compare</a></td>
                                </c:when>
                                <c:otherwise>
                                    <td></td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </c:otherwise>
    </c:choose>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>