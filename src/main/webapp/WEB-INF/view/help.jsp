<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.help"/></title>
    <c:import url="fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("#teacher").click(function (event) {
                event.preventDefault();
                $(this).next().toggleClass("hidden");
            });

            $("#student").click(function (event) {
                event.preventDefault();
                $(this).next().toggleClass("hidden");
            });
        });
    </script>
</head>
<body>
<div class="container">
    <br>
    <div class="text-center">
        <a id="en" href="javascript:void(0);">
            <img src="${pageContext.request.contextPath}/resources/icons/united-states.png"
                 width="20" height="20" alt="English">
            <spring:message code="navbar.language.english"/>
        </a>&nbsp;&nbsp;&nbsp;
        <a id="ru" href="#">
            <img src="${pageContext.request.contextPath}/resources/icons/russia.png"
                 width="20" height="20" alt="Russian">
            <spring:message code="navbar.language.russian"/>
        </a>&nbsp;&nbsp;&nbsp;
        <a id="uk" href="javascript:void(0);">
            <img src="${pageContext.request.contextPath}/resources/icons/ukraine.png"
                 width="20" height="20" alt="Ukrainian">
            <spring:message code="navbar.language.ukrainian"/>
        </a>
    </div>
    <h1 class="text-center"><spring:message code="help.training.portal"/></h1>
    <a href="" id="teacher" class="text-center"><h2><spring:message code="help.teacher"/></h2></a>
    <div class="hidden">
        <h4><spring:message code="help.quizzes"/></h4>
        <p><spring:message code="help.questions"/></p>
        <ul>
            <li><spring:message code="help.one.answer"/></li>
            <li><spring:message code="help.few.answers"/></li>
            <li><spring:message code="help.accordance"/></li>
            <li><spring:message code="help.sequence"/></li>
            <li><spring:message code="help.numerical"/></li>
        </ul>
        <p><spring:message code="help.teacher.first"/></p>
        <p><spring:message code="help.teacher.second"/></p>
        <ul>
            <li><spring:message code="help.quiz.opened"/></li>
            <li><spring:message code="help.quiz.passed"/></li>
            <li><spring:message code="help.quiz.closed"/></li>
        </ul>
        <p><spring:message code="help.teacher.third"/></p>
        <p><spring:message code="help.teacher.fourth"/></p>
        <h4><spring:message code="help.groups"/></h4>
        <p><spring:message code="help.teacher.fifth"/></p>
    </div>
    <a href="" id="student" class="text-center"><h2><spring:message code="help.student"/></h2></a>
    <div class="hidden">
        <p><spring:message code="help.student.first"/></p>
        <ul>
            <li><spring:message code="help.quiz.opened"/></li>
            <li><spring:message code="help.quiz.passed"/></li>
            <li><spring:message code="help.quiz.closed"/></li>
        </ul>
        <p><spring:message code="help.student.second"/></p>
        <p><spring:message code="help.student.third"/></p>
    </div>
    <div class="row justify-content-center">
        <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
    </div>
</div>
<br>
</body>
</html>
