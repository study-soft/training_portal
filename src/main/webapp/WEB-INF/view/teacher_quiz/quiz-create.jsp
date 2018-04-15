<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quiz create</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var passingTimeRemoved;
            $("#enabled").change(function () {
                if (passingTimeRemoved) {
                    $("#after").after(passingTimeRemoved);
                    passingTimeRemoved = null;
                } else {
                    passingTimeRemoved = $("#passingTime").detach();
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Create quiz</h2>
    <form:form action="/teacher/quizzes/create" method="post" modelAttribute="quiz">
        <div class="form-group">
            <form:label path="name" for="name">
                <strong>Name<span class="red">*</span></strong>
            </form:label>
            <form:input path="name" cssClass="col col-md-6 form-control" id="name" placeholder="Name"/>
            <form:errors path="name" cssClass="error"/>
        </div>
        <div class="form-group">
            <div class="custom-control custom-checkbox">
                <input type="checkbox" id="enabled" name="enabled"
                       value="enabled" class="custom-control-input" checked>
                <label for="enabled" class="custom-control-label">
                    <strong>Passing time</strong>
                </label>
            </div>
            <form:errors path="passingTime" cssClass="error"/>
            <span id="after"></span>
            <div id="passingTime" class="row">
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
            <form:label path="description" for="description">
                <strong>Description</strong>
            </form:label>
            <form:textarea path="description" cssClass="col col-md-6 form-control"
                           rows="6" id="description" placeholder="Description"/>
            <form:errors path="description" cssClass="error"/>
        </div>
        <div class="form-group">
            <form:label path="explanation" for="explanation">
                <strong>Explanation</strong>
            </form:label>
            <form:textarea path="explanation" cssClass="col col-md-6 form-control"
                           rows="6" id="explanation" placeholder="Explanation"/>
            <form:errors path="explanation" cssClass="error"/>
        </div>
        <div class="row no-gutters align-items-center highlight-primary">
            <div class="col-auto mr-3">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25">
            </div>
            <div class="col">
                Students will see explanation after all group close this quiz
            </div>
        </div>
        <div class="row">
            <div class="col-2">
                <button type="button" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
            </div>
            <div class="col-1 offset-3">
                <input type="submit" class="btn btn-success" value="Create">
            </div>
        </div>
    </form:form>
</div>
</body>
</html>
