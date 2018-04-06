<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Time is up</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Oops... Time is up</h2>
    <div class="highlight-danger">
        <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
             width="25" height="25" class="icon-one-row">
        You have forcibly completed <strong>${quiz.quizName}</strong> quiz with ${quiz.attempt} attempt
    </div>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Result</td>
            <td>${quiz.result} / ${quiz.score}</td>
        </tr>
        <tr>
            <td>Time spent</td>
            <td><duration:format value="${quiz.timeSpent}"/> of
                <duration:format value="${quiz.passingTime}"/></td>
        </tr>
        <tr>
            <td>Passed</td>
            <td><localDateTime:format value="${quiz.finishDate}"/></td>
        </tr>
    </table>
    <c:if test="${quiz.explanation ne null}">
        <div class="col-lg-6"><strong>Explanation: </strong> ${quiz.explanation}</div>
    </c:if>
    <sec:authorize access="hasRole('ROLE_STUDENT')">
        <div><a href="/student/quizzes/${quiz.quizId}" class="btn btn-primary btn-wide">Back to quiz</a></div>
    </sec:authorize>
    <sec:authorize access="hasRole('ROLE_TEACHER')">
        <div><a href="/teacher/quizzes/${quiz.quizId}" class="btn btn-primary btn-wide">Back to quiz</a></div>
    </sec:authorize>
</div>
<br>
</body>
</html>
