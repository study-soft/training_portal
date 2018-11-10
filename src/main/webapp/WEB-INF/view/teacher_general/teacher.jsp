<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.home"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const editSuccess = "${editSuccess}";
            if (editSuccess) {
                $("#update-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#update-success").fadeOut("slow");
            });

            $("#switcher").click(function (event) {
                event.preventDefault();
                if ($(this).text() === '<spring:message code="home.show"/>') {
                    $(this).text('<spring:message code="home.hide"/>');
                } else {
                    $(this).text('<spring:message code="home.show"/>');
                }
                $("#credentials").fadeToggle("slow");
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="update-success" class="col-lg-5 mx-auto text-center correct update-success">
        <spring:message code="home.info.changed"/>
        <button id="close" class="close">&times;</button>
    </div>
    <h2><spring:message code="home.hi"/>, ${teacher.firstName}! <spring:message code="home.welcome"/></h2>
    <div>
        <a href="${pageContext.request.contextPath}/teacher/groups/create" class="btn btn-success btn-wide">
            <i class="fa fa-group"></i> <spring:message code="group.new"/>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/quizzes/create" class="btn btn-success btn-wide">
            <i class="fa fa-book"></i> <spring:message code="quiz.new"/>
        </a>
    </div>
    <h4><i class="fa fa-user"></i> <spring:message code="home.teacher.info"/></h4>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="user.name"/></td>
            <td>${teacher.lastName} ${teacher.firstName}</td>
        <tr>
            <td><spring:message code="user.mail"/></td>
            <td>${teacher.email}</td>
        </tr>
        <tr>
            <td><spring:message code="user.phone"/></td>
            <td>${teacher.phoneNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="user.birthday"/></td>
            <td><localDate:format value="${teacher.dateOfBirth}"/></td>
        </tr>
    </table>
    <h4 class="inline"><i class="fa fa-lock"></i> <spring:message code="home.security.info"/></h4>
    <a href="" id="switcher" style="padding-left: 15px;"><spring:message code="home.show"/></a>
    <table id="credentials" class="col-lg-6 table-info hidden">
        <tr>
            <td><spring:message code="user.login"/></td>
            <td>${teacher.login}</td>
        </tr>
        <tr>
            <td><spring:message code="user.password"/></td>
            <td>${teacher.password}</td>
        </tr>
    </table>
    <div>
        <a href="${pageContext.request.contextPath}/teacher/edit-profile"
           class="btn btn-primary btn-wide"><spring:message code="home.edit.profile"/></a>
    </div>
</div>
<br>
</body>
</html>