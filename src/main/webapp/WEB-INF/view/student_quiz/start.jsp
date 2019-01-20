<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.start"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${openedQuiz.quizName}"/></h2>
    <table class="col-lg-6 table-info">
        <c:if test="${openedQuiz.passingTime ne null}">
            <tr>
                <td><spring:message code="quiz.passing.time"/></td>
                <td><duration:format value="${openedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td><spring:message code="quiz.total.questions"/></td>
            <td>${openedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.score"/></td>
            <td>${openedQuiz.score}</td>
        </tr>
    </table>
    <div class="row no-gutters align-items-center highlight-primary">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icons/icon-primary.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="quiz.press.start"/>
            <br><spring:message code="quiz.press.back"/>
        </div>
    </div>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);">
            <spring:message code="back"/>
        </button>
        <a href="/quizzes/${openedQuiz.quizId}/initialize" class="btn btn-success">
            <spring:message code="quiz.start"/>
        </a>
    </div>
</div>
<br>
</body>
</html>
