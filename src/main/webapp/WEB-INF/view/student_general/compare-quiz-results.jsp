<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group results</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("tr").each(function () {
                if ($(this).attr("id") === "${studentId}") {
                    $(this).css("background-color", "#a7f9aa");
                }
            });

            $("td[id]").each(function () {
                if (this.id === "OPENED") {
                    $(this).text("");
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Group results</h2>
    <h3>${quiz.name}</h3>
    <c:choose>
        <c:when test="${not empty students}">
            <table class="table">
                <tr>
                    <th>Name</th>
                    <th>Result</th>
                    <th>Attempt</th>
                    <th>Time spent</th>
                    <th>Status</th>
                </tr>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <c:set var="i" value="${status.index}"/>
                    <tr id="${student.userId}">
                        <td><a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                        <td id="${statusList[i]}">${studentsQuizzes[i].result} / ${studentsQuizzes[i].score}</td>
                        <td>${studentsQuizzes[i].attempt}</td>
                        <td><duration:format value="${studentsQuizzes[i].timeSpent}"/></td>
                        <td>${statusList[i]}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <div class="col-6 highlight-danger">
                <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
                     width="25" height="25" class="icon-two-rows">
                <div class="inline">You do not belong to any group</div>
                <div class="non-first-row">Nothing to compare</div>
            </div>
        </c:otherwise>
    </c:choose>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
