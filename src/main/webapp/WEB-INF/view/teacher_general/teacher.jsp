<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const editSuccess = "${editSuccess}";
            if (editSuccess) {
                $("#update-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#update-success").fadeOut("slow");
            });

            $("#switcher").click(function (event) {
                event.preventDefault();
                if ($(this).text() === "show") {
                    $(this).text("hide");
                } else {
                    $(this).text("show");
                }
                $("#credentials").fadeToggle("slow");
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="update-success" class="col-5 mx-auto text-center correct update-success">
        Profile information successfully changed
        <button id="close" class="close">&times;</button>
    </div>
    <h2>Hello, teacher! Welcome to the training portal!</h2>
    <div>
        <a href="/teacher/groups/create" class="btn btn-success btn-wide">
            <i class="fa fa-group"></i> New group
        </a>
        <a href="/teacher/quizzes/create" class="btn btn-success btn-wide">
            <i class="fa fa-book"></i> New quiz
        </a>
    </div>
    <h3><i class="fa fa-user"></i> Teacher information</h3>
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
    <h4 class="inline"><i class="fa fa-lock"></i> Login and password</h4>
    <a href="" id="switcher" style="margin-left: 10px;">show</a>
    <table id="credentials" class="col-6 table-info hidden">
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
<br>
</body>
</html>