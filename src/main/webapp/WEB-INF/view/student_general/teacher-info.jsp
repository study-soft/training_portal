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
    <table class="col-lg-6 table-info">
        <tr>
            <td>Name</td>
            <td>${teacher.lastName} ${teacher.firstName}</td>
        </tr>
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
    <h3>${teacher.firstName} gave you next quizzes:</h3>
    <div class="col-lg-6">
        <table class="table">
            <tr>
                <th>Name</th>
                <th>Status</th>
            </tr>
            <c:forEach items="${quizzes}" var="quiz" varStatus="status">
                <tr>
                    <td>
                        <a href="/student/quizzes/${quiz.quizId}">
                            <c:out value="${quiz.name}"/>
                        </a>
                    </td>
                    <td>${statusList[status.index]}</td>
                </tr>
            </c:forEach>
        </table>
    </div>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
