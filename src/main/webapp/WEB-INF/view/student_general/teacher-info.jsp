<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.teacher.info"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="quiz.teacher.info"/></h2>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="user.name"/></td>
            <td>${teacher.lastName} ${teacher.firstName}</td>
        </tr>
        <tr>
            <td><spring:message code="user.mail"/></td>
            <td>${teacher.email}</td>
        </tr>
        <tr>
            <td><spring:message code="user.phone"/></td>
            <td>${teacher.phoneNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="user.birthday"/></td>
            <td><localDate:format value="${teacher.dateOfBirth}"/></td>
        </tr>
    </table>
    <h3>${teacher.firstName} <spring:message code="quiz.teacher.published"/>:</h3>
    <div class="col-lg-6">
        <table class="table">
            <tr>
                <th><spring:message code="quiz.name"/></th>
                <th><spring:message code="quiz.status"/></th>
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
    <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
</div>
<br>
</body>
</html>
