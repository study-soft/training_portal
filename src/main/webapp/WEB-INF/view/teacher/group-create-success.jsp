<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group created</title>
    <c:import url="../fragment/teacher-navbar.jsp"/></head>
<body>
<h2>Group '${group.name}' successfully created</h2>
<div>Creation date: <localDate:format value="${group.creationDate}"/></div>
<c:if test="${group.description ne null or group.description eq ''}">
    <div>Description: ${group.description}</div>
</c:if>
<h3>Student which have been added</h3>
<c:choose>
    <c:when test="${empty students}">
        <div>You have not added any student.</div>
    </c:when>
    <c:otherwise>
        <ul>
            <c:forEach items="${students}" var="student">
                <li>${student.lastName} ${student.firstName}</li>
            </c:forEach>
        </ul>
    </c:otherwise>
</c:choose>
<div>
    <a href="/teacher">Home</a>
</div>
</body>
</html>