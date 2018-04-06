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
    <div class="highlight-primary">
        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
             width="25" height="25" class="icon-one-row">
        There are results of groups and students which are passing your quizzes
    </div>
    <c:choose>
        <c:when test="${empty groups && empty students}">
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                You do not have published quizzes
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:if test="${not empty groups}">
                    <div class="col-sm-6">
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
                </c:if>
                <c:if test="${not empty students}">
                    <div class="col-sm-6">
                        <table class="table">
                            <tr>
                                <th>Students without group</th>
                            </tr>
                            <c:forEach items="${students}" var="student" varStatus="status">
                                <tr>
                                    <td>
                                        <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
