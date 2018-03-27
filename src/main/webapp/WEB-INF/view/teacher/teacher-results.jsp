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
    <div class="row">
        <div class="col-6">
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
        <div class="col-6">
            <table class="table">
                <tr>
                    <th>Students without group</th>
                </tr>
                <c:forEach items="${students}" var="student">
                    <tr>
                        <td><a href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a></td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
</body>
</html>
