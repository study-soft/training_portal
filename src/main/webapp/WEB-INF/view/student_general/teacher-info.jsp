<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Teacher info</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Teacher information</h2>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">Name</td>
            <td class="table-home">${teacher.lastName} ${teacher.firstName}</td>
        </tr>
        <tr>
            <td class="table-home">E-mail</td>
            <td class="table-home">${teacher.email}</td>
        </tr>
        <tr>
            <td class="table-home">Phone number</td>
            <td class="table-home">${teacher.phoneNumber}</td>
        </tr>
        <tr>
            <td class="table-home">Date of birth</td>
            <td class="table-home"><localDate:format value="${teacher.dateOfBirth}"/></td>
        </tr>
    </table>
    <h3>${teacher.firstName} gave you next quizzes:</h3>
    <table class="table">
        <tr>
            <th>Name</th>
            <th>Status</th>
            <th></th>
        </tr>
        <c:forEach items="${quizzes}" var="quiz" varStatus="status">
            <tr>
                <td>${quiz.name}</td>
                <td>${statusList[status.index]}</td>
                <td><a href="/student/quizzes/${quiz.quizId}">Details</a></td>
            </tr>
        </c:forEach>
    </table>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
