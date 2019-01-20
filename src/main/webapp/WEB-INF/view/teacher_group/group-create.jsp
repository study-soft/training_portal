<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.group.create"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="group.new"/></h2>
    <form action="${pageContext.request.contextPath}/teacher/groups/create" method="post">
        <div>
            <label for="name" class="col-form-label">
                <strong><spring:message code="group.name"/><span class="red">*</span></strong>
            </label>
        </div>
        <div>
            <input type="text" name="name" id="name" class="col-md-4 form-control">
            <span class="error">${emptyName}</span>
            <span class="error">${groupExists}</span>
        </div>
        <div>
            <label for="description" class="col-form-label">
                <strong><spring:message code="group.description"/></strong>
            </label>
        </div>
        <div>
            <textarea rows="6" name="description" id="description" class="col-lg-6 form-control"></textarea>
        </div>
        <h3><spring:message code="group.students.add"/>:</h3>
        <c:choose>
            <c:when test="${empty students}">
                <div class="row no-gutters align-items-center highlight-primary">
                    <div class="col-auto mr-3">
                        <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                             width="25" height="25">
                    </div>
                    <div class="col">
                        <spring:message code="group.no.students.without"/>
                        <br><spring:message code="group.empty"/>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <tr>
                        <th><spring:message code="user.name"/></th>
                        <th><spring:message code="user.mail"/></th>
                        <th><spring:message code="user.phone"/></th>
                        <th></th>
                    </tr>
                    <c:forEach items="${students}" var="student" varStatus="status">
                        <tr>
                            <td>
                                <label for="student${status.index}">${student.lastName} ${student.firstName}</label>
                            </td>
                            <td>
                                <label for="student${status.index}">${student.email}</label>
                            </td>
                            <td>
                                <label for="student${status.index}">${student.phoneNumber}</label>
                            </td>
                            <td>
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" name="student${status.index}" id="student${status.index}"
                                           value="${student.userId}" class="custom-control-input">
                                    <label for="student${status.index}" class="custom-control-label"> </label>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
        <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
        <button type="submit" class="btn btn-success btn-wide">
            <i class="fa fa-plus"></i> <spring:message code="create"/>
        </button>
    </form>
</div>
<br>
</body>
</html>
