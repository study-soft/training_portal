<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Congratulations</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Congratulations!</h2>
    <div class="highlight-success">
        <img src="${pageContext.request.contextPath}/resources/icon-success.png"
             width="25" height="25" class="icon-one-row">
        You have passed <strong>${quiz.quizName}</strong> quiz with ${quiz.attempt} attempt
    </div>
    <table class="col-6 table-info">
        <tr>
            <td>Result</td>
            <td>${quiz.result} / ${quiz.score}</td>
        </tr>
        <tr>
            <td>Time spent</td>
            <td><duration:format value="${quiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td>Finished</td>
            <td><localDateTime:format value="${quiz.finishDate}"/></td>
        </tr>
    </table>
    <c:if test="${quiz.explanation ne null}">
        <div class="col-6"><strong>Explanation: </strong> ${quiz.explanation}</div>
    </c:if>
    <sec:authorize access="hasRole('ROLE_TEACHER')">
        <a href="/teacher/quizzes/${quiz.quizId}" class="btn btn-primary btn-wide">Back to quiz</a>
    </sec:authorize>
    <sec:authorize access="hasRole('ROLE_STUDENT')">
        <a href="/student/quizzes/${quiz.quizId}" class="btn btn-primary btn-wide">Back to quiz</a>
        <form class="inline" action="/student/quizzes/${quiz.quizId}" method="post">
            <input type="submit" value="Close" class="btn btn-success">
        </form>
    </sec:authorize>
</div>
<br>
</body>
</html>