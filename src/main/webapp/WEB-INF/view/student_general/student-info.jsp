<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student info</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            if (${sessionScope.teacherId ne null}) {
                $("td[id]").each(function () {
                    $(this).find("a").attr("href", "/teacher/quizzes/" + this.id);
                });
            }
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${student.lastName} ${student.firstName}</h2>
    <table class="col-6 table-info">
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
        <tr>
            <td>Group</td>
            <td>${group.name}</td>
        </tr>
    </table>
    <c:choose>
        <c:when test="${sessionScope.studentId ne null}">
            <h3>${student.firstName} passes next quizzes:</h3>
        </c:when>
        <c:when test="${sessionScope.teacherId ne null}">
            <h3>You gave ${student.firstName} next quizzes:</h3>
        </c:when>
        <c:otherwise>
            <div class="error">SOME ERROR</div>
        </c:otherwise>
    </c:choose>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty closedQuizzes}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                There is no quizzes for ${student.firstName}.
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th>Name</th>
                    <th>Result</th>
                    <th>Attempt</th>
                    <th>Time spent</th>
                    <th>Passed</th>
                    <th>Status</th>
                </tr>
                <c:forEach items="${openedQuizzes}" var="openedQuiz">
                    <tr>
                        <td id="${openedQuiz.quizId}">
                            <a href="/student/quizzes/${openedQuiz.quizId}">${openedQuiz.quizName}</a>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>OPENED</td>
                    </tr>
                </c:forEach>
                <c:forEach items="${passedQuizzes}" var="passedQuiz">
                    <tr>
                        <td id="${passedQuiz.quizId}">
                            <a href="/student/quizzes/${passedQuiz.quizId}">${passedQuiz.quizName}</a>
                        </td>
                        <td>${passedQuiz.result}/${passedQuiz.score}</td>
                        <td>${passedQuiz.attempt}</td>
                        <td><duration:format value="${passedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${passedQuiz.finishDate}"/></td>
                        <td>PASSED</td>
                    </tr>
                </c:forEach>
                <c:forEach items="${closedQuizzes}" var="closedQuiz">
                    <tr>
                        <td id="${closedQuiz.quizId}">
                            <a href="/student/quizzes/${closedQuiz.quizId}">${closedQuiz.quizName}</a>
                        </td>
                        <td>${closedQuiz.result}/${closedQuiz.score}</td>
                        <td>${closedQuiz.attempt}</td>
                        <td><duration:format value="${closedQuiz.timeSpent}"/></td>
                        <td><localDateTime:format value="${closedQuiz.finishDate}"/></td>
                        <td>CLOSED</td>
                    </tr>
                </c:forEach>
            </table>

        </c:otherwise>
    </c:choose>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>