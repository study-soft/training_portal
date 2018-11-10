<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.no.data.found"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<c:import url="../fragment/navbar.jsp"/>
<body>
<div class="container">
    <h2><spring:message code="no.data.found"/></h2>
    <div class="row no-gutters align-items-center highlight-danger mb-3">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="no.data.found.message"/>
        </div>
    </div>
    <button class="btn btn-primary" onclick="window.history.go(-1);">
        <spring:message code="back"/>
    </button>
</div>
</body>
</html>
