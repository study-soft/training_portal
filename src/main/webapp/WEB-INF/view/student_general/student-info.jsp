<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student info</title>
    <c:import url="../fragment/head.jsp"/>
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
                <td><c:out value="${group.name}"/></td>
            </tr>
        </c:if>
    </table>
    <h3>${student.firstName} passes next quizzes:</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty closedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    There is no quizzes for ${student.firstName}
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:if test="${not empty openedQuizzes}">
                <h4>Opened</h4>
                <table class="table">
                    <tr>
                        <th style="width: 26%">Name</th>
                        <th style="width: 34%">Submitted</th>
                        <th colspan="4" style="width: 40%"></th>
                    </tr>
                    <c:forEach items="${openedQuizzes}" var="quiz">
                        <tr>
                            <td>
                                <a href="/student/quizzes/${quiz.quizId}">
                                    <c:out value="${quiz.quizName}"/>
                                </a>
                            </td>
                            <td><localDateTime:format value="${quiz.submitDate}"/></td>
                            <td colspan="4"></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            <c:if test="${not empty passedQuizzes}">
                <h4>Passed</h4>
                <table class="table">
                    <tr>
                        <th style="width: 26%">Name</th>
                        <th style="width: 21%">Submitted</th>
                        <th style="width: 21%">Passed</th>
                        <th style="width: 10%;">Result</th>
                        <th style="width: 10%">Attempt</th>
                        <th style="width: 12%">Time spent</th>
                    </tr>
                    <c:forEach items="${passedQuizzes}" var="quiz">
                        <tr>
                            <td id="${quiz.quizId}">
                                <a href="/student/quizzes/${quiz.quizId}">
                                    <c:out value="${quiz.quizName}"/>
                                </a>
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
            <c:if test="${not empty closedQuizzes}">
                <h4>Closed</h4>
                <table class="table">
                    <tr>
                        <th style="width: 26%">Name</th>
                        <th style="width: 21%">Submitted</th>
                        <th style="width: 21%">Passed</th>
                        <th style="width: 10%;">Result</th>
                        <th style="width: 10%">Attempt</th>
                        <th style="width: 12%">Time spent</th>
                    </tr>
                    <c:forEach items="${closedQuizzes}" var="quiz">
                        <tr>
                            <td id="${quiz.quizId}">
                                <a href="/student/quizzes/${quiz.quizId}">
                                    <c:out value="${quiz.quizName}"/>
                                </a>
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
</div>
<br>
</body>
</html>