<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("tr").each(function () {
                if ($(this).attr("id") === "${studentId}") {
                    $(this).css("background-color", "#a7f9aa");
                    $(this).find("a").attr("href", "/student");
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h3>${group.name}</h3>
    <table class="col-6 table-info">
        <tr>
            <td>Name</td>
            <td>${group.name}</td>
        </tr>
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td>Number of students</td>
            <td>${studentsNumber}</td>
        </tr>
        <tr>
            <td>Author</td>
            <td>${authorName}</td>
        </tr>
    </table>
    <h3>List of students</h3>
    <div class="col-6">
        <table class="table">
            <tr>
                <th>Name</th>
            </tr>
            <c:forEach items="${students}" var="student">
                <tr id="${student.userId}">
                    <td><a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                </tr>
            </c:forEach>
        </table>
    </div>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
