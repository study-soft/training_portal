<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Teachers</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Teachers</h2>
    <div class="input-group">
        <input type="search" class="col-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <c:choose>
        <c:when test="${empty teachers}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have teachers
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th>Name</th>
                    <th>E-mail</th>
                    <th>Phone number</th>
                </tr>
                <c:forEach items="${teachers}" var="teacher">
                    <tr>
                        <td><a href="/student/teachers/${teacher.userId}">${teacher.lastName} ${teacher.firstName}</a>
                        </td>
                        <td>${teacher.email}</td>
                        <td>${teacher.phoneNumber}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
