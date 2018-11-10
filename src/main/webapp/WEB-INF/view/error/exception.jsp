<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.exception"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<c:import url="../fragment/navbar.jsp"/>
<body>
<div class="container">
    <h3><spring:message code="exception"/></h3>
    <table class="table-info">
        <%--<tr>--%>
            <%--<td>Response status</td>--%>
            <%--<td>${pageContext.response.status}</td>--%>
        <%--</tr>--%>
        <tr>
            <td><spring:message code="exception.type"/></td>
            <td>${exception['class'].name}</td>
        </tr>
        <tr>
            <td><spring:message code="exception.message"/></td>
            <td>${exception.message}</td>
        </tr>
    </table>
    <strong><spring:message code="stack.trace"/></strong>
    <pre>${pageContext.out.flush()}${exception.printStackTrace(pageContext.response.writer)}</pre>
    <button class="btn btn-primary" onclick="window.history.go(-1);">
        <spring:message code="back"/>
    </button>
</div>
</body>
</html>
