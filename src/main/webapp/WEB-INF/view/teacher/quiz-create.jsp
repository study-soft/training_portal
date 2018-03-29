<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz create</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Create quiz</h2>
    <form:form action="/teacher/quizzes/create" method="post" modelAttribute="quiz">
        <div class="form-group">
            <form:label path="name" for="name"><strong>Name</strong><span class="error">*</span></form:label>
            <form:input path="name" cssClass="col col-md-6 form-control" id="name" placeholder="Name"/>
            <form:errors path="name" cssClass="error"/>
        </div>
        <div class="form-group">
            <div><strong>Passing time</strong></div>
            <form:errors path="passingTime" cssClass="error"/>
            <div class="row">
                <div class="col col-md-2">
                    <label for="hours">Hours </label>
                    <input type="text" class="form-control" id="hours" name="hours" value="${hours}">
                </div>
                <div class="col col-md-2">
                    <label for="minutes">Minutes </label>
                    <input type="text" class="form-control" id="minutes" name="minutes" value="${minutes}">
                </div>
                <div class="col col-md-2">
                    <label for="seconds">Seconds </label>
                    <input type="text" class="form-control" id="seconds" name="seconds" value="${seconds}">
                </div>
            </div>
        </div>
        <div class="form-group">
            <form:label path="description" for="description"><strong>Description</strong></form:label>
            <form:textarea path="description" cssClass="col col-md-6 form-control"
                           rows="6" id="description" placeholder="Description"/>
            <form:errors path="description" cssClass="error"/>
        </div>
        <div class="form-group">
            <form:label path="explanation" for="explanation"><strong>Explanation</strong></form:label>
            <form:textarea path="explanation" cssClass="col col-md-6 form-control"
                           rows="6" id="explanation" placeholder="Explanation"/>
            <form:errors path="explanation" cssClass="error"/>
        </div>
        <div class="row">
            <div class="col-2">
                <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
            </div>
            <div class="col-3"></div>
            <div class="col-1">
                <input type="submit" class="btn btn-success" value="Create">
            </div>
        </div>
    </form:form>
</div>
</body>
</html>
