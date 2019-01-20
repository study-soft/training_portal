<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.group.deleted"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <c:choose>
        <c:when test="${groupAlreadyDeleted eq true}">
            <h2><spring:message code="group.deleted"/></h2>
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-success">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-success.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="group.group"/> '<c:out value="${group.name}"/>'
                    <spring:message code="group.deleted.successfully"/>
                </div>
            </div>
            <c:if test="${not empty students}">
                <h3><spring:message code="group.deleted.students"/>:</h3>
                <ul>
                    <c:forEach items="${students}" var="student">
                        <li>${student.lastName} ${student.firstName}</li>
                    </c:forEach>
                </ul>
            </c:if>
        </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/teacher/groups"
       class="btn btn-primary btn-wide"><spring:message code="group.groups.back"/></a>
</div>
</body>
</html>
