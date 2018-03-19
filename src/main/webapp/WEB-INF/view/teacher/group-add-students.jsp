<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add students</title>
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="../fragment/teacher-navbar.jsp"/>
<h2>${group.name}</h2>
<h3>Students to add:</h3>
<c:choose>
    <c:when test="${empty students}">
        <div>There is no students without group.</div>
        <div><input type="button" value="Back" onclick="window.history.go(-1);"></div>
    </c:when>
    <c:otherwise>
        <span class="error">${noStudents}</span>
        <form action="/teacher/groups/${group.groupId}/add-students" method="post">
            <table>
                <tr>
                    <th>Name</th>
                    <th>E-mail</th>
                    <th></th>
                </tr>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <tr>
                        <td>
                            <label for="student${status.index}">${student.lastName} ${student.firstName}</label>
                        </td>
                        <td>${student.email}</td>
                        <td><input type="checkbox" name="student${status.index}"
                                   value="${student.userId}" id="student${status.index}"></td>
                    </tr>
                </c:forEach>
            </table>
            <div>
                <input type="button" value="Back" onclick="window.history.go(-1);">
                <input type="submit" value="Create">
            </div>
        </form>
    </c:otherwise>
</c:choose>
</body>
</html>