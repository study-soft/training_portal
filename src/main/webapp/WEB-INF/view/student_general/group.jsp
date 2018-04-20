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
    <h3><c:out value="${group.name}"/></h3>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Name</td>
            <td><c:out value="${group.name}"/></td>
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
    <c:if test="${group.description ne null}">
        <div class="col-lg-6">
            <strong>Description: </strong><c:out value="${group.description}"/>
        </div>
    </c:if>
    <h4>List of students</h4>
    <div class="col-lg-6">
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
        <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
