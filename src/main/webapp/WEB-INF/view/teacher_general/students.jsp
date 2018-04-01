<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Students</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("input[type=search]").on("keyup", function () {
                var value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Students which are passing your quizzes</h2>
    <div class="input-group">
        <input type="search" class="col-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <br>
    <table class="table">
        <thead>
        <tr>
            <th>Name</th>
            <th>E-mail</th>
            <th>Phone number</th>
            <th>Group</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${students}" var="student" varStatus="status">
            <tr>
                <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                <td>${student.email}</td>
                <td>${student.phoneNumber}</td>
                <td><a href="/teacher/groups/${groups[status.index].groupId}">${groups[status.index].name}</a></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
