<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Results</h2>
    <table class="table">
        <tr>
            <th style="width: 50%">Groups</th>
            <th style="width: 50%">Students without group</th>
        </tr>
        <c:choose>
            <c:when test="${fn:length(groups) gt fn:length(students)}">
                <c:forEach items="${groups}" var="group" varStatus="status">
                    <tr>
                        <td><a href="#">${group.name}</a></td>
                        <td>
                            <a href="#">${students[status.index].lastName} ${students[status.index].firstName}</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <tr>
                        <td><a href="#">${groups[status.index].name}</a></td>
                        <td><a href="#">${student.lastName} ${student.firstName}</a></td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
</body>
</html>
