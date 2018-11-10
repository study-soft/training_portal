<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.students"/></title>
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
    <h2><spring:message code="quiz.students"/></h2>
    <div class="input-group">
        <input type="search" class="col-lg-4 form-control" placeholder="<spring:message code="search"/>...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <br>
    <c:choose>
        <c:when test="${not empty students}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.students.quizzes"/>
                </div>
            </div>
            <table class="table">
                <thead>
                <tr>
                    <th><spring:message code="user.name"/></th>
                    <th><spring:message code="user.mail"/></th>
                    <th><spring:message code="user.phone"/></th>
                    <th><spring:message code="user.group"/></th>
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
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.students.no.quizzes"/>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
</div>
<br>
</body>
</html>
