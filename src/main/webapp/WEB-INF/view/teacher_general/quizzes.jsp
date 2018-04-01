<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quizzes</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("input[type=search]").on("keyup", function () {
                var value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <div class="input-group">
        <input type="search" class="col-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <a href="/teacher/quizzes/create" class="btn btn-success float-right" style="width: 125px">
        <i class="fa fa-book"></i> New quiz
    </a>
    <h3>Unpublished quizzes</h3>
    <c:choose>
        <c:when test="${empty unpublishedQuizzes}">
            You do not have any unpublished quizzes
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 35%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 15%;">Creation date</th>
                    <th style="width: 12%"></th>
                    <th style="width: 8%"></th>
                    <th style="width: 10%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${unpublishedQuizzes}" var="unpublishedQuiz">
                    <tr>
                        <td><a href="/teacher/quizzes/${unpublishedQuiz.quizId}">${unpublishedQuiz.name}</a></td>
                        <td>${unpublishedQuiz.questionsNumber}</td>
                        <td>${unpublishedQuiz.score}</td>
                        <td><localDate:format value="${unpublishedQuiz.creationDate}"/></td>
                        <td>
                            <a href="#" class="success">
                                <i class="fa fa-share-square-o"></i> Publish
                            </a>
                        </td>
                        <td>
                            <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/edit">
                                <i class="fa fa-edit"></i> Edit
                            </a>
                        </td>
                        <td>
                            <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/delete" class="danger">
                                <i class="fa fa-trash-o"></i> Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <h3>Published quizzes</h3>
    <c:choose>
        <c:when test="${empty unpublishedQuizzes}">
            You do not have any published quizzes
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 35%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 10%">Score</th>
                    <th style="width: 15%">Creation date</th>
                    <th style="width: 30%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${publishedQuizzes}" var="publishedQuiz">
                    <tr>
                        <td><a href="/teacher/quizzes/${publishedQuiz.quizId}">${publishedQuiz.name}</a></td>
                        <td>${publishedQuiz.questionsNumber}</td>
                        <td>${publishedQuiz.score}</td>
                        <td><localDate:format value="${publishedQuiz.creationDate}"/></td>
                        <td class="text-center">
                            <a href="#" class="danger">
                                <i class="fa fa-close"></i> Unpublish
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" value="Back" onclick="window.history.go(-1);">Back</button>
    <br>
</div>
<br>
</body>
</html>
