<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group deleted</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <c:choose>
        <c:when test="${groupAlreadyDeleted eq true}">
            <h2>This group already deleted.</h2>
        </c:when>
        <c:otherwise>
            <h2>Success</h2>
            <div>Deleted group '${group.name}'</div>
            <c:if test="${not empty students}">
                <h3>Students which were in this group:</h3>
                <ul>
                    <c:forEach items="${students}" var="student">
                        <li>${student.lastName} ${student.firstName}</li>
                    </c:forEach>
                </ul>
            </c:if>
        </c:otherwise>
    </c:choose>
    <a href="/teacher/groups" class="btn btn-primary" style="width: 140px">Back to groups</a>
</div>
</body>
</html>
