<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit profile success</title>
    <c:import url="fragment/head.jsp"/>
</head>
<body>
<c:import url="fragment/navbar.jsp"/>
<div class="container">
    <div class="text-center">
        <h2>Profile information successfully changed</h2>
        <table class="col-6 table-home center">
            <tr>
                <td class="table-home">Password</td>
                <td class="table-home">${user.password}</td>
            </tr>
            <tr>
                <td class="table-home">E-mail</td>
                <td class="table-home">${user.email}</td>
            </tr>
            <tr>
                <td class="table-home">Phone number</td>
                <td class="table-home">${user.phoneNumber}</td>
            </tr>
            <tr>
                <td class="table-home">First name</td>
                <td class="table-home">${user.firstName}</td>
            </tr>
            <tr>
                <td class="table-home">Last name</td>
                <td class="table-home">${user.lastName}</td>
            </tr>
            <c:if test="${user.dateOfBirth ne null}">
                <tr>
                    <td class="table-home">Date of birth</td>
                    <td class="table-home"><localDate:format value="${user.dateOfBirth}"/></td>
                </tr>
            </c:if>
        </table>
        <div>
            <c:choose>
                <c:when test="${sessionScope.studentId ne null}">
                    <a href="/student" class="btn btn-primary">Home</a>
                </c:when>
                <c:when test="${sessionScope.teacherId ne null}">
                    <a href="/teacher" class="btn btn-primary">Home</a>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
