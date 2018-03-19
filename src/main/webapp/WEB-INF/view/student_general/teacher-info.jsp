<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Teacher info</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<h2>Teacher information:</h2>
<div>Name: ${teacher.lastName} ${teacher.firstName}</div>
<div>E-mail: ${teacher.email}</div>
<div>Phone number: ${teacher.phoneNumber}</div>
<c:if test="${teacher.dateOfBirth ne null}">
    <div>Date of birth: <localDate:format value="${teacher.dateOfBirth}"/></div>
</c:if>
<h3>${teacher.firstName} gave you next quizzes:</h3>
<table>
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
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>