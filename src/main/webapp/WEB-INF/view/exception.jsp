<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Exception</title>
    <c:import url="fragment/head.jsp"/>
</head>
<c:import url="fragment/navbar.jsp"/>
<body>
<div class="container">
    <h3>Exception Page</h3>
    <table class="table-info">
        <%--<tr>--%>
            <%--<td>Response status</td>--%>
            <%--<td>${pageContext.response.status}</td>--%>
        <%--</tr>--%>
        <tr>
            <td>Exception type</td>
            <td>${exception['class'].name}</td>
        </tr>
        <tr>
            <td>Exception Message</td>
            <td>${exception.message}</td>
        </tr>
    </table>
    <strong>Stack trace</strong>
    <pre>${pageContext.out.flush()}${exception.printStackTrace(pageContext.response.writer)}</pre>
</div>
</body>
</html>
