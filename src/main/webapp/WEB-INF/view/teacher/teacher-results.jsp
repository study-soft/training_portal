<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Results</h2>
    <c:choose>
        <c:when test="${empty groups && empty students}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have published quizzes
            </div>
        </c:when>
        <c:when test="${empty groups}">
            <div class="col-8">
                <table class="table">
                    <tr>
                        <th style="width: 70%">Students</th>
                        <th style="width: 30%"></th>
                    </tr>
                    <c:forEach items="${students}" var="student" varStatus="status">
                        <tr>
                            <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                            <td>${singleStudentGroups[status.index].name}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:when>
        <c:when test="${empty students}">
            <div class="col-4">
                <table class="table">
                    <tr>
                        <th>Groups</th>
                    </tr>
                    <c:forEach items="${groups}" var="group">
                        <tr>
                            <td><a href="/teacher/results/group/${group.groupId}">${group.name}</a></td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <div class="col-8">
                    <table class="table">
                        <tr>
                            <th style="width: 70%">Students</th>
                            <th style="width: 30%"></th>
                        </tr>
                        <c:forEach items="${students}" var="student" varStatus="status">
                            <tr>
                                <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                                <td>${singleStudentGroups[status.index].name}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <div class="col-4">
                    <table class="table">
                        <tr>
                            <th>Groups</th>
                        </tr>
                        <c:forEach items="${groups}" var="group">
                            <tr>
                                <td><a href="/teacher/results/group/${group.groupId}">${group.name}</a></td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
