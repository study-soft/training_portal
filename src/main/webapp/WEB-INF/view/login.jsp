<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.login"/></title>
    <c:import url="fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const registrationSuccess = "${registrationSuccess}";
            if (registrationSuccess) {
                $("#registration-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#registration-success").fadeOut("slow");
            });
        });
    </script>
</head>
<body>
<br>
<div class="container">
    <div class="right">
        <a id="en" href="#">EN</a> <a id="ru" href="#">RU</a> <a id="uk" href="#">UK</a>
    </div>
    <br>
    <div class="row justify-content-center">
        <div class="col-auto">
            <div class="media">
                <img class="mr-2" style="margin-top: 15px" src="${pageContext.request.contextPath}/resources/icons/training-portal-favicon.png"
                     width="30" height="35">
                <div class="media-body">
                    <h2><spring:message code="login.training.portal"/></h2>
                </div>
            </div>
        </div>
    </div>
    <div class="row justify-content-center">
        <a href="${pageContext.request.contextPath}/help" class="ml-5">
            <h5><spring:message code="login.help"/> <i class="fa fa-external-link"></i></h5>
        </a>
    </div>
    <br>
    <div id="registration-success" class="col mx-auto text-center correct update-success">
        ${registrationSuccess}<button id="close" class="close">&times;</button>
    </div>
    <form action="/login" method="post" class="col col-md-6 center">
        <c:if test="${param.error ne null}">
            <p class="error"><spring:message code="login.invalid.login.password"/></p>
        </c:if>
        <div class="form-group row">
            <label for="username" class="col-4 col-form-label"><strong><spring:message code="user.login"/></strong></label>
            <input type="text" class="col-8 form-control" id="username" name="username"
                   placeholder="<spring:message code="user.login"/>">
        </div>
        <div class="form-group row">
            <label for="password" class="col-4 col-form-label"><strong><spring:message code="user.password"/></strong></label>
            <input type="password" class="col-8 form-control" id="password" name="password"
                   placeholder="<spring:message code="user.password"/>">
        </div>
        <div class="right">
            <input type="submit" value="<spring:message code="login.log.in"/>" class="btn btn-primary">
        </div>
        <br>
        <br>
        <div class="right"><spring:message code="login.no.account"/>
            <a href="${pageContext.request.contextPath}/register"><spring:message code="login.register"/></a></div>
    </form>
</div>
</body>
</html>
