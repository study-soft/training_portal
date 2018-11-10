<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.group"/></title>
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
            <td><spring:message code="group.name"/></td>
            <td><c:out value="${group.name}"/></td>
        </tr>
        <tr>
            <td><spring:message code="group.creation.date"/></td>
            <td><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td><spring:message code="group.students.number"/></td>
            <td>${studentsNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="group.author"/></td>
            <td>${authorName}</td>
        </tr>
    </table>
    <c:if test="${group.description ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="group.description"/>: </strong><c:out value="${group.description}"/>
        </div>
    </c:if>
    <h4><spring:message code="group.students"/></h4>
    <div class="col-lg-6">
        <table class="table">
            <tr>
                <th><spring:message code="user.name"/></th>
            </tr>
            <c:forEach items="${students}" var="student">
                <tr id="${student.userId}">
                    <td><a href="/student/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                </tr>
            </c:forEach>
        </table>
    </div>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);">
            <spring:message code="back"/>
        </button>
    </div>
</div>
<br>
</body>
</html>
