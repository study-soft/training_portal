<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Students added</title>
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="../fragment/teacher-navbar.jsp"/>
<h3>Students successfully added to group '${group.name}'</h3>
<ul>
    <c:forEach items="${students}" var="student">
        <li>${student.lastName} ${student.firstName}</li>
    </c:forEach>
</ul>
<div>
    <a href="/teacher/groups/${group.groupId}">To group</a>
    <a href="/teacher">Home</a>
</div>
</body>
</html>
