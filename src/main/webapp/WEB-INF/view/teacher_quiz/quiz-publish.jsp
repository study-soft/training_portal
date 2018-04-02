<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Publication</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Publishing</h2>
    <form action="#" method="post">
        <c:choose>
            <c:when test="${empty groups && empty students}">
                <div class="highlight-primary">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25" class="icon-one-row">
                    There are no students and groups that you can publish quiz
                </div>
            </c:when>
            <c:when test="${empty groups}">
                <div class="col-8">
                    <table class="table">
                        <tr>
                            <th>Students without group</th>
                        </tr>
                        <c:forEach items="${students}" var="student">
                            <tr>
                                <td>
                                    <a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                                </td>
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
                    <div class="col-8">
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
                </div>
            </c:otherwise>
        </c:choose>
        <button type="button" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
        <button type="submit" class="btn btn-success">Publish</button>
    </form>
</div>
<br>
</body>
</html>
