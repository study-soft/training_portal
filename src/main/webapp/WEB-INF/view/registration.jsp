<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=utf-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.registration"/></title>
    <c:import url="fragment/head.jsp"/>
</head>
<body>
<br>
<div class="container">
    <div class="right">
        <a id="en" href="#">EN</a> <a id="ru" href="#">RU</a> <a id="uk" href="#">UK</a>
    </div>
    <br>
    <div class="text-center">
        <img src="${pageContext.request.contextPath}/resources/icons/training-portal-favicon.png"
             width="30" height="35" style="margin-bottom: 15px">
        <h2 style="display: inline"><spring:message code="registration.training.portal"/></h2>
    </div>
    <br>
    <form:form action="/register" method="post" modelAttribute="user" cssClass="col-md-6 center">
        <div class="form-group row">
            <spring:message code="user.login" var="loginMsg"/>
            <form:label path="login" for="login" cssClass="col-4 col-form-label">
                <strong>${loginMsg}<span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="login" cssClass="form-control" id="login" placeholder="${loginMsg}"/>
                <small class="form-text text-muted"><spring:message code="registration.hint.login"/></small>
                <form:errors path="login" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <spring:message code="user.password" var="passwordMsg"/>
            <form:label path="password" for="password" cssClass="col-4 col-form-label">
                <strong>${passwordMsg}<span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="password" cssClass="form-control" id="password" placeholder="${passwordMsg}"/>
                <small class="form-text text-muted"><spring:message code="registration.hint.password"/></small>
                <form:errors path="password" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <spring:message code="user.mail" var="emailMsg"/>
            <form:label path="email" for="email" cssClass="col-4 col-form-label">
                <strong>${emailMsg}<span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="email" cssClass="form-control" id="email" placeholder="${emailMsg}"/>
                <small class="form-text text-muted"><spring:message code="registration.hint.email"/></small>
                <form:errors path="email" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <spring:message code="user.phone" var="phoneMsg"/>
            <form:label path="phoneNumber" for="phoneNumber" cssClass="col-4 col-form-label">
                <strong>${phoneMsg}<span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="phoneNumber" cssClass="form-control" id="phoneNumber" placeholder="${phoneMsg}"/>
                <small class="form-text text-muted">
                    <spring:message code="registration.hint.phone"/> (xxx)-xxx-xx-xx, (xxx)xxxxxxx,
                    (xxx) xxx xx xx, xxx-xxx-xx-xx, xxx xxx xx xx, xxxxxxxxxx
                </small>
                <form:errors path="phoneNumber" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="userRole" for="userRole" cssClass="col-4 col-form-label">
                <strong><spring:message code="user.role"/><span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <spring:message code="registration.role.choose" var="choose"/>
                <spring:message code="registration.role.teacher" var="teacher"/>
                <spring:message code="registration.role.student" var="student"/>
                <form:select path="userRole" id="userRole" cssClass="form-control">
                    <form:option value="CHOOSE" label="${choose}"/>
                    <form:option value="STUDENT" label="${student}"/>
                    <form:option value="TEACHER" label="${teacher}"/>
                </form:select>
                <small class="form-text text-muted"><spring:message code="registration.hint.role"/></small>
                <form:errors path="userRole" cssClass="error"/>
            </div>
        </div>
        <div class="form-group row">
            <spring:message code="user.first.name" var="firstNameMsg"/>
            <form:label path="firstName" for="firstName" cssClass="col-4 col-form-label">
                <strong>${firstNameMsg}<span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="firstName" cssClass="form-control" id="firstName" placeholder="${firstNameMsg}"/>
                <small class="form-text text-muted"><spring:message code="registration.hint.first.name"/></small>
                <form:errors path="firstName" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <spring:message code="user.last.name" var="lastNameMsg"/>
            <form:label path="lastName" for="lastName" cssClass="col-4 col-form-label">
                <strong>${lastNameMsg}<span class="red">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="lastName" cssClass="form-control" id="lastName" placeholder="${lastNameMsg}"/>
                <small class="form-text text-muted"><spring:message code="registration.hint.last.name"/></small>
                <form:errors path="lastName" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <label for="dateOfBirth" class="col-4 col-form-label">
                <strong><spring:message code="user.birthday"/></strong>
            </label>
            <div class="col-8">
                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control">
                <small class="form-text text-muted"><spring:message code="registration.hint.birthday"/></small>
                <form:errors path="dateOfBirth" cssClass="error"/>
            </div>
        </div>
        <div class="right">
            <input type="reset" value="<spring:message code="registration.reset"/>" class="btn btn-danger btn-wide">
            <input type="submit" value="<spring:message code="registration.register"/>" class="btn btn-success btn-wide">
        </div>
    </form:form>
    <br>
    <br>
    <div class="right">
        <a href="${pageContext.request.contextPath}/login"><spring:message code="registration.login.page"/></a>
    </div>
    <br>
    <br>
</div>
<br>
</body>
</html>