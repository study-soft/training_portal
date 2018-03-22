<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <table class="table-home col-6">
        <tr>
            <td class="table-home">Result</td>
            <td class="table-home">${quiz.result} / ${quiz.score}</td>
        </tr>
        <tr>
            <td class="table-home">You have spent all time</td>
            <td class="table-home"><duration:format value="${quiz.timeSpent}"/></td>
        </tr>
        <tr>
            <td class="table-home">Finished</td>
            <td class="table-home"><localDateTime:format value="${quiz.finishDate}"/></td>
        </tr>
    </table>
    <c:if test="${quiz.explanation ne null}">
        <div class="col-6"><strong>Explanation: </strong> ${quiz.explanation}</div>
    </c:if>
    <div><a href="/student/quizzes/${quiz.quizId}" class="btn btn-primary">Back to quiz</a></div>
</div>
<br>
</body>
</html>
