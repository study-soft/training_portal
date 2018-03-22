<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Unpublished quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>Unpublished quiz</h2>
<div>
    <a href="#">Publish</a>
    <a href="#">Preview</a>
    <a href="#">Edit</a>
    <a href="#">Delete</a>
</div>
<br>
<div class="highlight-danger">This quiz is not published</div>
<h3>${unpublishedQuiz.name}</h3>
<small>Creation date: <localDate:format value="${unpublishedQuiz.creationDate}"/></small>
<div>Description: ${unpublishedQuiz.description}</div>
<div>Passing time: <duration:format value="${unpublishedQuiz.passingTime}"/></div>
<div>Total questions: ${unpublishedQuiz.questionsNumber}</div>
<div>Questions by types:
    <c:forEach items="${questions}" var="entry">
        <c:choose>
            <c:when test="${entry.key eq 'ONE_ANSWER'}">
                <div style="margin-left: 20px">One answer: ${entry.value}</div>
            </c:when>
            <c:when test="${entry.key eq 'FEW_ANSWERS'}">
                <div style="margin-left: 20px">Few answers: ${entry.value}</div>
            </c:when>
            <c:when test="${entry.key eq 'ACCORDANCE'}">
                <div style="margin-left: 20px">Accordance: ${entry.value}</div>
            </c:when>
            <c:when test="${entry.key eq 'SEQUENCE'}">
                <div style="margin-left: 20px">Sequence: ${entry.value}</div>
            </c:when>
            <c:when test="${entry.key eq 'NUMBER'}">
                <div style="margin-left: 20px">Number: ${entry.value}</div>
            </c:when>
            <c:otherwise>
                <div>SOME ERROR</div>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
<div>Score: ${unpublishedQuiz.score}</div>
<div class="highlight-success">Students will see explanation after all group finish tis quiz</div>
<div>Explanation: ${unpublishedQuiz.explanation}</div>
<div>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions">Questions</a>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>
