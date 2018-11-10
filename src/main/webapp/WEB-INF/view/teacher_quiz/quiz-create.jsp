<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.create"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            let passingTime;
            $("#passingTimeEnabled").change(function () {
                if ($(this).prop("checked") === false) {
                    passingTime = $("#passingTime").detach();
                } else {
                    $("#after").after(passingTime);
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="quiz.new"/></h2>
    <form:form action="/teacher/quizzes/create" method="post" modelAttribute="quiz">
        <div class="form-group">
            <spring:message code="quiz.name" var="nameMsg"/>
            <form:label path="name" for="name">
                <strong>${nameMsg}<span class="red">*</span></strong>
            </form:label>
            <form:input path="name" cssClass="col col-md-6 form-control" id="name" placeholder="${nameMsg}"/>
            <form:errors path="name" cssClass="error"/>
        </div>
        <div class="form-group">
            <div class="custom-control custom-checkbox mb-2">
                <input type="checkbox" id="passingTimeEnabled" name="enabled"
                       value="enabled" class="custom-control-input" checked>
                <label for="passingTimeEnabled" class="custom-control-label">
                    <strong><spring:message code="quiz.passing.time"/></strong>
                </label>
            </div>
            <form:errors path="passingTime" cssClass="error"/>
            <span id="after"></span>
            <div id="passingTime" class="row">
                <div class="col col-md-2">
                    <label for="hours"><spring:message code="quiz.hours"/></label>
                    <input type="text" class="form-control" id="hours" name="hours" value="${hours}">
                </div>
                <div class="col col-md-2">
                    <label for="minutes"><spring:message code="quiz.minutes"/></label>
                    <input type="text" class="form-control" id="minutes" name="minutes" value="${minutes}">
                </div>
                <div class="col col-md-2">
                    <label for="seconds"><spring:message code="quiz.seconds"/></label>
                    <input type="text" class="form-control" id="seconds" name="seconds" value="${seconds}">
                </div>
            </div>
        </div>
        <div class="form-group">
            <spring:message code="quiz.description" var="descriptionMsg"/>
            <form:label path="description" for="description">
                <strong>${descriptionMsg}</strong>
            </form:label>
            <form:textarea path="description" cssClass="col col-md-6 form-control"
                           rows="6" id="description" placeholder="${descriptionMsg}"/>
            <form:errors path="description" cssClass="error"/>
        </div>
        <div class="form-group">
            <spring:message code="quiz.explanation" var="explanationMsg"/>
            <form:label path="explanation" for="explanation">
                <strong>${explanationMsg}</strong>
            </form:label>
            <form:textarea path="explanation" cssClass="col col-md-6 form-control"
                           rows="6" id="explanation" placeholder="${explanationMsg}"/>
            <form:errors path="explanation" cssClass="error"/>
        </div>
        <div class="row no-gutters align-items-center highlight-primary">
            <div class="col-auto mr-3">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25">
            </div>
            <div class="col">
                <spring:message code="quiz.explanation.create"/>
            </div>
        </div>
        <div class="row">
            <div class="col-2">
                <button type="button" class="btn btn-primary" onclick="window.history.go(-1);">
                    <spring:message code="back"/>
                </button>
            </div>
            <div class="col-1 offset-3">
                <input type="submit" class="btn btn-success btn-wide" value="<spring:message code="quiz.create"/>">
            </div>
        </div>
    </form:form>
</div>
</body>
</html>
