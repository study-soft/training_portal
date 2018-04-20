<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit profile</title>
    <c:import url="fragment/head.jsp"/>
</head>
<body>
<c:import url="fragment/navbar.jsp"/>
<div class="container">
    <br>
    <form:form id="editForm" action="${requestScope['javax.servlet.forward.request_uri']}"
               method="post" modelAttribute="user" cssClass="col-md-6 center">
        <div class="form-group row">
            <form:label path="password" for="password" cssClass="col-4 col-form-label">
                <strong>Old password<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:password path="password" cssClass="form-control" id="password" placeholder="Password"/>
                <small class="form-text text-muted">Enter old password</small>
                <form:errors path="password" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4 col-form-label" for="newPassword">
                <strong>New password</strong>
            </label>
            <div class="col-8">
                <input type="password" class="form-control" id="newPassword"
                       name="newPassword" value="${newPassword}" placeholder="New password">
                <small class="form-text text-muted">
                    Should contains at least one letter and digit
                    and be greater than 6 characters
                </small>
                <span class="error">${newPasswordIncorrect}</span>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="email" for="email" cssClass="col-4 col-form-label">
                <strong>Email<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="email" cssClass="form-control" id="email" placeholder="Email"/>
                <small class="form-text text-muted">Example: email@example.com</small>
                <form:errors path="email" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="phoneNumber" for="phoneNumber" cssClass="col-4 col-form-label">
                <strong>Phone number<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="phoneNumber" cssClass="form-control" id="phoneNumber" placeholder="Phone number"/>
                <small class="form-text text-muted">
                    Example: (xxx)-xxx-xx-xx, (xxx)xxxxxxx, (xxx) xxx xx xx,
                    xxx-xxx-xx-xx, xxx xxx xx xx, xxxxxxxxxx
                </small>
                <form:errors path="phoneNumber" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="firstName" for="firstName" cssClass="col-4 col-form-label">
                <strong>First name<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="firstName" cssClass="form-control" id="firstName" placeholder="First name"/>
                <small class="form-text text-muted">Example: Silvester</small>
                <form:errors path="firstName" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="lastName" for="lastName" cssClass="col-4 col-form-label">
                <strong>Last name<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="lastName" cssClass="form-control" id="lastName" placeholder="Last name"/>
                <small class="form-text text-muted">Example: Stallone</small>
                <form:errors path="lastName" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <label for="dateOfBirth" class="col-4 col-form-label"><strong>Date of birth</strong></label>
            <div class="col-8">
                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control"
                       value="${user.dateOfBirth}">
                <small class="form-text text-muted">Example: 05/10/1970</small>
                <form:errors path="dateOfBirth" cssClass="error"/>
            </div>
        </div>
        <div class="text-center">
            <div class="left inline">
                <input onclick="window.history.go(-1);" type="button" value="Back" class="btn btn-primary">
            </div>
            <div class="inline">
                <input type="reset" value="Reset" class="btn btn-danger">
            </div>
            <div class="right inline">
                <input type="submit" value="Save" class="btn btn-success">
            </div>
        </div>
    </form:form>
</div>
<br>
</body>
</html>