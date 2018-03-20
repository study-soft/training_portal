<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit profile success</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<div class="container">
    <div class="text-center">
        <h2>Profile information successfully changed</h2>
        <table class="col-6 table-home center">
            <tr>
                <td class="table-home">Password</td>
                <td class="table-home">${student.password}</td>
            </tr>
            <tr>
                <td class="table-home">E-mail</td>
                <td class="table-home">${student.email}</td>
            </tr>
            <tr>
                <td class="table-home">Phone number</td>
                <td class="table-home">${student.phoneNumber}</td>
            </tr>
            <tr>
                <td class="table-home">First name</td>
                <td class="table-home">${student.firstName}</td>
            </tr>
            <tr>
                <td class="table-home">Last name</td>
                <td class="table-home">${student.lastName}</td>
            </tr>
            <c:if test="${student.dateOfBirth ne null}">
                <tr>
                    <td class="table-home">Date of birth</td>
                    <td class="table-home"><localDate:format value="${student.dateOfBirth}"/></td>
                </tr>
            </c:if>
        </table>
        <div>
            <a href="/student" class="btn btn-primary">Home</a>
        </div>
    </div>
</div>
</body>
</html>
