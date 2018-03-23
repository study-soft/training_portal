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
<div class="container">
    <h2>${unpublishedQuiz.name}</h2>
    <div class="row">
        <div class="col-4">
            <div class="highlight-danger">
                <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
                     width="25" height="25" class="icon-one-row">
                This quiz is not published
            </div>
        </div>
        <div class="col-4">
            <a href="#" class="btn btn-success">Publish</a>
        </div>
    </div>
    <div><strong>Description: </strong>${unpublishedQuiz.description}</div>
    <table class="table-info col-6">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${unpublishedQuiz.creationDate}"/></td>
        </tr>
        <tr>
            <td>Passing time</td>
            <td><duration:format value="${unpublishedQuiz.passingTime}"/></td>
        </tr>
        <tr>
            <td>Score</td>
            <td>${unpublishedQuiz.score}</td>
        </tr>
        <tr>
            <td>Total questions</td>
            <td>${unpublishedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Questions by types:</td>
            <td></td>
        </tr>
        <c:forEach items="${questions}" var="entry">
            <c:choose>
                <c:when test="${entry.key eq 'ONE_ANSWER'}">
                    <tr>
                        <td style="font-weight: normal">One answer</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:when>
                <c:when test="${entry.key eq 'FEW_ANSWERS'}">
                    <tr>
                        <td style="font-weight: normal">Few answers</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:when>
                <c:when test="${entry.key eq 'ACCORDANCE'}">
                    <tr>
                        <td style="font-weight: normal">Compliance</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:when>
                <c:when test="${entry.key eq 'SEQUENCE'}">
                    <tr>
                        <td style="font-weight: normal">Consistency</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:when>
                <c:when test="${entry.key eq 'NUMBER'}">
                    <tr>
                        <td style="font-weight: normal">With numerical answer</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <div>SOME ERROR</div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </table>
    <div><strong>Explanation: </strong>${unpublishedQuiz.explanation}</div>
    <div class="highlight-primary">
        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
             width="25" height="25" class="icon-one-row">
        Students will see explanation after all group close this quiz
    </div>
    <button onclick="window.history.go(-1);" class="btn btn-primary">Back</button>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions" class="btn btn-primary">Questions</a>
    <a href="#" class="btn btn-primary">Preview</a>
    <a href="#" class="btn btn-primary">Edit</a>
    <a href="#" class="btn btn-danger">Delete</a>
</div>
<br>
</body>
</html>
