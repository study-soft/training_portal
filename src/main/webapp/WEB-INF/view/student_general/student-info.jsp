<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student info</title>
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<h2>${student.lastName} ${student.firstName}</h2>
<div>E-mail: ${student.email}</div>
<div>Phone number: ${student.phoneNumber}</div>
<c:if test="${student.dateOfBirth ne null}">
    <div>Date of birth: <localDate:format value="${student.dateOfBirth}"/></div>
</c:if>
<div>Group: ${group.name}</div>
<h3>${student.firstName} passes next quizzes:</h3>
<c:choose>
    <c:when test="${empty openedQuizzes and empty passedQuizzes and empty finishedQuizzes}">
        There is no quizzes for ${student.firstName}.
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Name</th>
                <th>Status</th>
                <th>Result</th>
                <th>Attempt</th>
            </tr>
            <c:forEach items="${openedQuizzes}" var="openedQuiz">
                <tr>
                    <td>${openedQuiz.quizName}</td>
                    <td>OPENED</td>
                    <td></td>
                    <td></td>
                </tr>
            </c:forEach>
            <c:forEach items="${passedQuizzes}" var="passedQuiz">
                <tr>
                    <td>${passedQuiz.quizName}</td>
                    <td>PASSED</td>
                    <td>${passedQuiz.result}/${passedQuiz.score}</td>
                    <td>${passedQuiz.attempt}</td>
                </tr>
            </c:forEach>
            <c:forEach items="${finishedQuizzes}" var="finishedQuiz">
                <tr>
                    <td>${finishedQuiz.quizName}</td>
                    <td>FINISHED</td>
                    <td>${finishedQuiz.result}/${finishedQuiz.score}</td>
                    <td>${finishedQuiz.attempt}</td>
                </tr>
            </c:forEach>
        </table>

    </c:otherwise>
</c:choose>
<div>
    <input onclick="window.history.go(-1);" type="button" value="Back"/>
</div>
</body>
</html>