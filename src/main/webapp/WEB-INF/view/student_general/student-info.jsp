<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student info</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<br>
<div class="container">
    <h2>${student.lastName} ${student.firstName}</h2>
    <table class="col-6 table-home">
        <tr>
            <td class="table-home">E-mail</td>
            <td class="table-home">${student.email}</td>
        </tr>
        <tr>
            <td class="table-home">Phone number</td>
            <td class="table-home">${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td class="table-home">Date of birth</td>
                <td class="table-home"><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
        <tr>
            <td class="table-home">Group</td>
            <td class="table-home">${group.name}</td>
        </tr>
    </table>
    <h3>${student.firstName} passes next quizzes:</h3>
    <c:choose>
        <c:when test="${empty openedQuizzes and empty passedQuizzes and empty finishedQuizzes}">
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
        <input onclick="window.history.go(-1);" type="button" value="Back" class="btn btn-primary"/>
    </div>
</div>
<br>
</body>
</html>