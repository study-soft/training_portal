<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.continue"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="attention"/></h2>
    <div>
        <spring:message code="quiz.continue.you.should"/>&nbsp;
        <a href="/quizzes/${sessionScope.currentQuiz.quizId}/passing">
            <spring:message code="quiz.continue.continue"/>
        </a>
        &nbsp;<spring:message code="quiz.continue.or"/>&nbsp;
        <a href="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">
            <spring:message code="quiz.continue.finish"/>
        </a>
        &nbsp;<strong><c:out value="${sessionScope.currentQuiz.name}"/></strong>&nbsp;
        <spring:message code="quiz.continue.quiz"/>
    </div>
    <div>
        <spring:message code="quiz.continue.answered"/>&nbsp;
        ${sessionScope.currentQuestionSerial}/${sessionScope.questionsNumber}&nbsp;
        <spring:message code="quiz.continue.questions"/>
    </div>
</div>
<br>
</body>
</html>