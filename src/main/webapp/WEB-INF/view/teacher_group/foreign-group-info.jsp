<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.group"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${group.name}"/></h2>
    <c:if test="${group.description ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="group.description"/>: </strong><c:out value="${group.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="group.creation.date"/></td>
            <td><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td><spring:message code="group.students.number"/></td>
            <td>${studentsNumber}</td>
        </tr>
    </table>
    <h4><spring:message code="group.quizzes"/></h4>
    <c:choose>
        <c:when test="${empty publishedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="group.no.quizzes"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="col-lg-6 table-info">
                <c:forEach items="${publishedQuizzes}" var="quiz" varStatus="status">
                    <tr>
                        <td>
                            <a href="/teacher/quizzes/${quiz.quizId}">
                                <c:out value="${quiz.name}"/>
                            </a>
                        </td>
                        <td>${statuses[status.index]}</td>
                        <td>${studentsProgress[quiz.quizId][0]}/${studentsProgress[quiz.quizId][1]}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <h4><spring:message code="group.students"/></h4>
    <c:choose>
        <c:when test="${empty studentsList}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="group.no.students"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="col-lg-6 table-info">
                <c:forEach items="${studentsList}" var="student" varStatus="status">
                    <tr id="${student.userId}">
                        <td>
                            <a href="/teacher/students/${student.userId}">
                                    ${student.lastName} ${student.firstName}
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1)">
        <spring:message code="back"/>
    </button>
</div>
<br>
</body>
</html>
