<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz results</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("td[id]").each(function () {
                if (this.id === "/OPENED") {
                    $(this).text("");
                }
                if (this.id === "OPENED" || this.id === "PASSED") {
                    $(this).find("a").html('<i class="fa fa-close"></i> Close');
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h3><a href="/teacher/groups/${group.groupId}">${group.name}</a></h3>
    <h3><a href="/teacher/quizzes/${quiz.quizId}">${quiz.name}</a></h3>
    <table class="table">
        <tr>
            <th style="width: 25%">Name</th>
            <th style="width: 10%">Result</th>
            <th style="width: 10%">Attempt</th>
            <th style="width: 12.5%">Time spent</th>
            <th style="width: 22.5%">Passed</th>
            <th style="width: 10%">Status</th>
            <th style="width: 10%"></th>
        </tr>
        <c:forEach items="${students}" var="student" varStatus="status">
            <c:set var="i" value="${status.index}"/>
            <tr>
                <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                <td id="/${statusList[i]}">${passedResults[i].result} / ${passedResults[i].score}</td>
                <td>${passedResults[i].attempt}</td>
                <td><duration:format value="${passedResults[i].timeSpent}"/></td>
                <td><localDateTime:format value="${passedResults[i].finishDate}"/></td>
                <td>${statusList[i]}</td>
                <td id="${statusList[i]}"><a href="#" class="danger"></a></td>
            </tr>
        </c:forEach>
    </table>
    <button class="btn btn-primary" onclick="window.history.go(-1)">Back</button>
</div>
<br>
</body>
</html>
