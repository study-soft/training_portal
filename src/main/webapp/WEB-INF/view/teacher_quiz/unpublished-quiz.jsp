<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Unpublished quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var editSuccess = "${editSuccess}";
            if (editSuccess) {
                $("#edit-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#edit-success").fadeOut("slow");
            });

            $("#back").click(function () {
                var previousUri = document.referrer;
                var createQuizUri = "http://" + "${header["host"]}" + "/teacher/quizzes/create";
                var editQuizUri = "http://" + "${header["host"]}" + "/teacher/quizzes/" + ${unpublishedQuiz.quizId} +"/edit";
                if (previousUri === createQuizUri || previousUri === editQuizUri) {
                    window.history.go(-2);
                } else {
                    window.history.go(-1);
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="edit-success" class="col-5 mx-auto text-center correct edit-success">
        Quiz information successfully changed
        <button id="close" class="close">&times;</button>
    </div>
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
            <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/publish" class="btn btn-success">
                <i class="fa fa-share-square-o"></i> Publish
            </a>
        </div>
    </div>
    <c:if test="${unpublishedQuiz.description ne null}">
        <div><strong>Description: </strong>${unpublishedQuiz.description}</div>
    </c:if>
    <table class="table-info col-6">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${unpublishedQuiz.creationDate}"/></td>
        </tr>
        <c:if test="${unpublishedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${unpublishedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Score</td>
            <td>${unpublishedQuiz.score}</td>
        </tr>
        <tr>
            <td>Total questions</td>
            <td>${unpublishedQuiz.questionsNumber}</td>
        </tr>
        <c:if test="${not empty questions}">
            <tr>
                <td>Questions by types:</td>
                <td></td>
            </tr>
        </c:if>
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
    <c:if test="${unpublishedQuiz.explanation ne null}">
        <div><strong>Explanation: </strong>${unpublishedQuiz.explanation}</div>
    </c:if>
    <div class="highlight-primary">
        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
             width="25" height="25" class="icon-one-row">
        Students will see explanation after all group close this quiz
    </div>
    <button id="back" class="btn btn-primary">Back</button>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions" class="btn btn-primary">Questions</a>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/preview" class="btn btn-primary">Preview</a>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/edit" class="btn btn-primary">
        <i class="fa fa-edit"></i> Edit
    </a>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/delete" class="btn btn-danger">
        <i class="fa fa-trash-o"></i> Delete
    </a>
</div>
<br>
</body>
</html>
