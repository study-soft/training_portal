<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Published quiz</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${publishedQuiz.name}</h2>
    <div class="row">
        <div class="col-auto">
            <div class="highlight-success">
                <img src="${pageContext.request.contextPath}/resources/icon-success.png"
                     width="25" height="25" class="icon-one-row">
                This quiz is published
            </div>
        </div>
        <div class="col-auto">
            <a href="#" class="btn btn-success">Republish</a>
        </div>
        <div class="col-auto">
            <a href="#" class="btn btn-danger">Unpublish</a>
        </div>
        <div class="col-4"></div>
    </div>
    <c:if test="${publishedQuiz.description ne null}">
        <div><strong>Description: </strong>${publishedQuiz.description}</div>
    </c:if>
    <table class="table-info col-6">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${publishedQuiz.creationDate}"/></td>
        </tr>
        <c:if test="${publishedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${publishedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Score</td>
            <td>${publishedQuiz.score}</td>
        </tr>
        <tr>
            <td>Total questions</td>
            <td>${publishedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Questions by types:</td>
            <td></td>
        </tr>
        <c:if test="${questions['ONE_ANSWER'] ne null}">
            <tr>
                <td style="font-weight: normal">One answer</td>
                <td>${questions['ONE_ANSWER']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['FEW_ANSWERS'] ne null}">
            <tr>
                <td style="font-weight: normal;">Few answers</td>
                <td>${questions['FEW_ANSWERS']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['ACCORDANCE'] ne null}">
            <tr>
                <td style="font-weight: normal">Accordance</td>
                <td>${questions['ACCORDANCE']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['SEQUENCE'] ne null}">
            <tr>
                <td style="font-weight: normal">Sequence</td>
                <td>${questions['SEQUENCE']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['NUMBER'] ne null}">
            <tr>
                <td style="font-weight: normal">Numerical</td>
                <td>${questions['NUMBER']}</td>
            </tr>
        </c:if>
    </table>
    <c:if test="${publishedQuiz.explanation ne null}">
        <div><strong>Explanation: </strong>${publishedQuiz.explanation}</div>
    </c:if>
    <div class="highlight-primary">
        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
             width="25" height="25" class="icon-one-row">
        Students will see explanation after all group close this quiz
    </div>
    <div class="highlight-primary">
        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
             width="25" height="25" class="icon-one-row">
        You can see groups and students where quiz was published <a href="#">here <i
            class="fa fa-external-link"></i></a>
    </div>
    <button onclick="window.history.go(-1);" class="btn btn-primary">Back</button>
    <a href="/teacher/quizzes/${publishedQuiz.quizId}/questions" class="btn btn-primary">Questions</a>
    <a href="/teacher/quizzes/${publishedQuiz.quizId}/preview" class="btn btn-primary">Preview</a>
</div>
<br>
</body>
</html>
