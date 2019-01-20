<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.results"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="quiz.result.results"/></h2>
    <c:choose>
        <c:when test="${empty groups && empty students}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.result.no.quizzes.published"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-primary mb-4">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.result.results.all"/>
                </div>
            </div>
            <div class="row">
                <c:if test="${not empty groups}">
                    <div class="col-sm-6">
                        <table class="table">
                            <tr>
                                <th><spring:message code="group.groups"/></th>
                            </tr>
                            <c:forEach items="${groups}" var="group">
                                <tr>
                                    <td>
                                        <a href="/teacher/results/group/${group.groupId}">
                                            <c:out value="${group.name}"/>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </c:if>
                <c:if test="${not empty students}">
                    <div class="col-sm-6">
                        <table class="table">
                            <tr>
                                <th><spring:message code="quiz.students.without.group"/></th>
                            </tr>
                            <c:forEach items="${students}" var="student" varStatus="status">
                                <tr>
                                    <td>
                                        <a href="/teacher/students/${student.userId}">
                                                ${student.lastName} ${student.firstName}
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
</div>
<br>
</body>
</html>
