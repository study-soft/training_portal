<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Students</title>
</head>
<c:import url="../fragment/head.jsp"/>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Students</h2>
    <form>
        <div class="row">
            <div class="col-4">
                <input class="form-control" type="search" placeholder="Search..." aria-label="Search">
            </div>
        </div>
    </form>
    <table class="table">
        <tr>
            <th>Name</th>
            <th>E-mail</th>
            <th>Phone number</th>
            <th>Group</th>
        </tr>
        <c:forEach items="${students}" var="student" varStatus="status">
            <tr>
                <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                <td>${student.email}</td>
                <td>${student.phoneNumber}</td>
                <td><a href="/teacher/groups/${groups[status.index].groupId}">${groups[status.index].name}</a></td>
            </tr>
        </c:forEach>
    </table>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
</body>
</html>
