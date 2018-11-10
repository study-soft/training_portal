<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.edit.profile"/></title>
    <c:import url="fragment/head.jsp"/>
</head>
<body>
<c:import url="fragment/navbar.jsp"/>
<div class="container">
    <br>
    <form:form id="editForm" action="${requestScope['javax.servlet.forward.request_uri']}"
               method="post" modelAttribute="user" cssClass="col-md-6 center">
        <div class="form-group row">
            <spring:message code="registration.old.password" var="oldPasswordMsg"/>
            <form:label path="password" for="password" cssClass="col-4 col-form-label">
                <strong>${oldPasswordMsg}</strong>
            </form:label>
            <div class="col-8">
                <form:password path="password" cssClass="form-control" id="password" placeholder="${oldPasswordMsg}"/>
                <small class="form-text text-muted"><spring:message code="registration.hint.password.old"/></small>
                <form:errors path="password" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4 col-form-label" for="newPassword">
                <strong><spring:message code="registration.new.password"/></strong>
            </label>
            <div class="col-8">
                <input type="password" class="form-control" id="newPassword" name="newPassword"
                       value="${newPassword}" placeholder="<spring:message code="registration.new.password"/>">
                <small class="form-text text-muted">
                    <spring:message code="registration.hint.password.new"/>
                </small>
                <span class="error">${newPasswordIncorrect}</span>
            </div>
        </div>
        <div class="form-group row">
            <spring:message code="user.mail" var="emailMsg"/>
            <form:label path="email" for="email" cssClass="col-4 col-form-label">
                <strong>${emailMsg}<span class="error">*</span></strong>
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
                <strong>${phoneMsg}<span class="error">*</span></strong>
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
            <spring:message code="user.first.name" var="firstNameMsg"/>
            <form:label path="firstName" for="firstName" cssClass="col-4 col-form-label">
                <strong>${firstNameMsg}<span class="error">*</span></strong>
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
                <strong>${lastNameMsg}<span class="error">*</span></strong>
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
                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control"
                       value="${user.dateOfBirth}">
                <small class="form-text text-muted"><spring:message code="registration.hint.birthday"/></small>
                <form:errors path="dateOfBirth" cssClass="error"/>
            </div>
        </div>
        <div class="text-center">
            <div class="left inline">
                <input onclick="window.history.go(-1);" type="button" value="<spring:message code="back"/>" class="btn btn-primary btn-wide">
            </div>
            <div class="inline">
                <input type="reset" value="<spring:message code="registration.reset"/>" class="btn btn-danger btn-wide">
            </div>
            <div class="right inline">
                <input type="submit" value="<spring:message code="save"/>" class="btn btn-success btn-wide">
            </div>
        </div>
    </form:form>
</div>
<br>
</body>
</html>