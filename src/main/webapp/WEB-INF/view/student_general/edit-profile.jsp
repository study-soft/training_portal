<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit profile</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<div class="container">
    <br>
    <form:form action="/student/edit-profile" method="post" modelAttribute="student" cssClass="col-6 center">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <div class="form-group row">
            <form:label path="login" for="login" cssClass="col-4 col-form-label">
                <strong>Login<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="login" cssClass="form-control" id="login" placeholder="Login"/>
                <form:errors path="login" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="password" for="password" cssClass="col-4 col-form-label">
                <strong>Password<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="password" cssClass="form-control" id="password" placeholder="Password"/>
                <form:errors path="password" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="email" for="email" cssClass="col-4 col-form-label">
                <strong>Email<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="email" cssClass="form-control" id="email" placeholder="Email"/>
                <form:errors path="email" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="phoneNumber" for="phoneNumber" cssClass="col-4 col-form-label">
                <strong>Phone number<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="phoneNumber" cssClass="form-control" id="phoneNumber" placeholder="Phone number"/>
                <form:errors path="phoneNumber" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="userRole" for="userRole" cssClass="col-4 col-form-label">
                <strong>User role<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:select path="userRole" id="userRole" cssClass="form-control">
                    <form:option value="CHOOSE" label="Choose"/>
                    <form:option value="STUDENT" label="Student"/>
                    <form:option value="TEACHER" label="Teacher"/>
                </form:select>
                <form:errors path="userRole" cssClass="error"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="firstName" for="firstName" cssClass="col-4 col-form-label">
                <strong>First name<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="firstName" cssClass="form-control" id="firstName" placeholder="First name"/>
                <form:errors path="firstName" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <form:label path="lastName" for="lastName" cssClass="col-4 col-form-label">
                <strong>Last name<span class="error">*</span></strong>
            </form:label>
            <div class="col-8">
                <form:input path="lastName" cssClass="form-control" id="lastName" placeholder="Last name"/>
                <form:errors path="lastName" cssClass="error center"/>
            </div>
        </div>
        <div class="form-group row">
            <label for="dateOfBirth" class="col-4 col-form-label"><strong>Date of birth</strong></label>
            <div class="col-8">
                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control">
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