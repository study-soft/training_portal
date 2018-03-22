<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Hello, student! Welcome to the training portal!</h2>
    <h3>Student information</h3>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Name</td>
            <td class="table-home">${student.lastName} ${student.firstName}</td>
        </tr>
        <tr>
            <td class="table-home">E-mail</td>
            <td class="table-home">${student.email}</td>
        </tr>
        <tr>
            <td class="table-home">Phone number</td>
            <td class="table-home">${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td class="table-home">Date of birth</td>
                <td class="table-home"><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
    </table>
    <h4>Login and password</h4>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Login</td>
            <td class="table-home">${student.login}</td>
        </tr>
        <tr>
            <td class="table-home">Password</td>
            <td class="table-home">${student.password}</td>
        </tr>
    </table>
    <div>
        <a href="/student/edit-profile" class="btn btn-primary">Edit profile</a>
    </div>
    <h3>Group information</h3>
    <c:choose>
        <c:when test="${group eq null}">
            <div>You do not belong to any group</div>
        </c:when>
        <c:otherwise>
            <table class="col-6 table-home">
                <tr>
                    <td class="table-home">Name</td>
                    <td class="table-home">${group.name}</td>
                </tr>
                <tr>
                    <td class="table-home">Creation date</td>
                    <td class="table-home"><localDate:format value="${group.creationDate}"/></td>
                </tr>
                <tr>
                    <td class="table-home">Number of students</td>
                    <td class="table-home">${numberOfStudents}</td>
                </tr>
                <tr>
                    <td class="table-home">Author</td>
                    <td class="table-home">${authorName}</td>
                </tr>
            </table>
            <div>
                <a href="/student/group" class="btn btn-primary">More info</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<br>
</body>
</html>
