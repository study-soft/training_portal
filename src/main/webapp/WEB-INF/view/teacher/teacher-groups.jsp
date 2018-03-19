<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Groups</title>
    <c:import url="../fragment/teacher-navbar.jsp"/>
</head>
<body>
<h2>Groups</h2>
<div>Search... <a href="/teacher/groups/create">+ Create</a></div>
<br>
<table>
    <tr>
        <th>Name</th>
        <th>Students</th>
        <th>Creation date</th>
        <th></th>
        <th></th>
        <th></th>
    </tr>
    <c:forEach items="${groups}" var="group" varStatus="status">
        <tr>
            <td>${group.name}</td>
            <td>${studentsNumber[status.index]}</td>
            <td><localDate:format value="${group.creationDate}"/></td>
            <td><a href="/teacher/groups/${group.groupId}">Details</a></td>
            <td><a href="#">Edit</a></td>
            <td>
                <form action="#" method="post">
                    <input type="submit" value="Dissolve">
                </form>
            </td>
        </tr>
    </c:forEach>
</table>
<div>
    <input type="button" value="Back" onclick="window.history.go(-1);">
</div>
</body>
</html>