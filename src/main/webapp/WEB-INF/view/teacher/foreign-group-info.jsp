<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group info</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${group.name}</h2>
    <div class="col-6"><strong>Description: </strong>${group.description}</div>
    <table class="col-6 table-info">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td>Number of students</td>
            <td>${studentsNumber}</td>
        </tr>
    </table>
    <h3>Students</h3>
    <c:choose>
        <c:when test="${empty students}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                There is no students in group
            </div>
        </c:when>
        <c:otherwise>
            <div class="col-6">
                <table class="table">
                    <tr>
                        <th>Name</th>
                    </tr>
                    <c:forEach items="${students}" var="student" varStatus="status">
                        <tr id="${student.userId}">
                            <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>  </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1)">Back</button>
</div>
</body>
</html>
