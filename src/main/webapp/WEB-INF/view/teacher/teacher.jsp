<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var editSuccess = "${editSuccess}";
            if (editSuccess) {
                $("#edit-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#edit-success").fadeOut("slow");
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="edit-success" class="col-4 mx-auto text-center correct edit-success">
        Profile information successfully changed
        <button id="close" class="close">&times;</button>
    </div>
    <h2>Hello, teacher! Welcome to the training portal!</h2>
    <div>
        <a href="/teacher/groups/create" class="btn btn-success">New group</a>
        <a href="#" class="btn btn-success">New quiz</a>
    </div>
    <h3>Teacher information</h3>
    <table class="col-6 table-info">
        <tr>
            <td>Name</td>
            <td>${teacher.lastName} ${teacher.firstName}</td>
        <tr>
            <td>E-mail</td>
            <td>${teacher.email}</td>
        </tr>
        <tr>
            <td>Phone number</td>
            <td>${teacher.phoneNumber}</td>
        </tr>
        <tr>
            <td>Date of birth</td>
            <td><localDate:format value="${teacher.dateOfBirth}"/></td>
        </tr>
    </table>
    <h4>Login and password</h4>
    <table class="col-6 table-info">
        <tr>
            <td>Login</td>
            <td>${teacher.login}</td>
        </tr>
        <tr>
            <td>Password</td>
            <td>${teacher.password}</td>
        </tr>
    </table>
    <div>
        <a href="/teacher/edit-profile" class="btn btn-primary">Edit profile</a>
    </div>
</div>
</body>
</html>