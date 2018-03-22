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
    <form>
        <input class="form-control col-4" type="search" placeholder="Search..." aria-label="Search">
    </form>
    <c:choose>
        <c:when test="${empty teachers}">
            <div>You do not have any teachers</div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th>Name</th>
                    <th>E-mail</th>
                    <th>Phone number</th>
                    <th></th>
                </tr>
                <c:forEach items="${teachers}" var="teacher">
                    <tr>
                        <td>${teacher.lastName} ${teacher.firstName}</td>
                        <td>${teacher.email}</td>
                        <td>${teacher.phoneNumber}</td>
                        <td><a href="/student/teachers/${teacher.userId}">Details</a></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
