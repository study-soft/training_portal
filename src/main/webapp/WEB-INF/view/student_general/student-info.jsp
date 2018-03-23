<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student info</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${student.lastName} ${student.firstName}</h2>
    <table class="col-6 table-info">
        <tr>
            <td>E-mail</td>
            <td>${student.email}</td>
        </tr>
        <tr>
            <td>Phone number</td>
            <td>${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td>Date of birth</td>
                <td><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Group</td>
            <td>${group.name}</td>
        </tr>
    </table>
    <h3>${student.firstName} passes next quizzes:</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty closedQuizzes}">
            There is no quizzes for ${student.firstName}.
        </c:when>
        <c:otherwise>
            <table class="table">
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
                <c:forEach items="${closedQuizzes}" var="closedQuiz">
                    <tr>
                        <td>${closedQuiz.quizName}</td>
                        <td>CLOSED</td>
                        <td>${closedQuiz.result}/${closedQuiz.score}</td>
                        <td>${closedQuiz.attempt}</td>
                    </tr>
                </c:forEach>
            </table>

        </c:otherwise>
    </c:choose>
    <div>
        <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>