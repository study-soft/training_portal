<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group results</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("td:first-child a").each(function () {
                if ($(this).attr("href").split("/")[2] === "${studentId}") {
                    $(this).parents("tr").css("background-color", "#a7f9aa");
                    $(this).attr("href", "/student");
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Group results</h2>
    <h3><a href="/student/quizzes/${quiz.quizId}"><c:out value="${quiz.name}"/></a></h3>
    <c:choose>
        <c:when test="${not empty openedStudents or not empty passedStudents}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    Here are students who pass this quiz with different quiz status
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    All students in this group closed this quiz
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <c:if test="${not empty openedStudents}">
        <h4>Opened</h4>
        <table id="openedQuizzes" class="table">
            <tr>
                <th style="width: 18%">Name</th>
                <th style="width: 21%">Submitted</th>
                <th colspan="4" style="width: 51%"></th>
            </tr>
            <c:forEach items="${openedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${openedQuizzes[i].submitDate}"/></td>
                    <td colspan="4"></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty passedStudents}">
        <h4>Passed</h4>
        <table id="passedQuizzes" class="table">
            <tr>
                <th style="width: 26%">Name</th>
                <th style="width: 21%">Submitted</th>
                <th style="width: 21%;">Passed</th>
                <th style="width: 10%">Result</th>
                <th style="width: 10%">Attempt</th>
                <th style="width: 12%">Time spent</th>
            </tr>
            <c:forEach items="${passedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${passedQuizzes[i].submitDate}"/></td>
                    <td><localDateTime:format value="${passedQuizzes[i].finishDate}"/></td>
                    <td>${passedQuizzes[i].result} / ${passedQuizzes[i].score}</td>
                    <td>${passedQuizzes[i].attempt}</td>
                    <td><duration:format value="${passedQuizzes[i].timeSpent}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <c:if test="${not empty closedStudents}">
        <h4>Closed</h4>
        <table id="closedQuizzes" class="table">
            <tr>
                <th style="width: 26%">Name</th>
                <th style="width: 21%">Submitted</th>
                <th style="width: 21%;">Passed</th>
                <th style="width: 10%">Result</th>
                <th style="width: 10%">Attempt</th>
                <th style="width: 12%">Time spent</th>
            </tr>
            <c:forEach items="${closedStudents}" var="student" varStatus="status">
                <c:set var="i" value="${status.index}"/>
                <tr>
                    <td>
                        <a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a>
                    </td>
                    <td><localDateTime:format value="${closedQuizzes[i].submitDate}"/></td>
                    <td><localDateTime:format value="${closedQuizzes[i].finishDate}"/></td>
                    <td>${closedQuizzes[i].result} / ${closedQuizzes[i].score}</td>
                    <td>${closedQuizzes[i].attempt}</td>
                    <td><duration:format value="${closedQuizzes[i].timeSpent}"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
