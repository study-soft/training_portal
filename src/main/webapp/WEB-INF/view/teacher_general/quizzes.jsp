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
                const value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });

            $("button:contains(Delete)").click(function () {
                const quizName = $(this).parent("td").siblings().first().text();
                const quizId = $(this).val();
                $("#yes").val(quizName);
                $("#deleteForm").attr("action", "/teacher/quizzes/" + quizId + "/delete");
                $("#modalLabel").removeClass("red").text("Attention");
                $(".modal-body").text("Are you sure you want to delete quiz '" + quizName + "'?");
                $("#modal").modal();
            });

            const deletedQuiz = "${deletedQuiz}";
            const unpublishedQuiz = "${unpublishedQuiz}";
            if (deletedQuiz) {
                $("#delete-success").html(
                    'Quiz \'${deletedQuiz}\' was successfully deleted\n' +
                    '<button id="close" class="close">&times;</button>').fadeIn("slow");
            }
            if (unpublishedQuiz) {
                $("#delete-success").html(
                    'Quiz \'${unpublishedQuiz}\' was successfully unpublished\n' +
                    '<button id="close" class="close">&times;</button>').fadeIn("slow");
            }

            $("#close").click(function () {
                $("#delete-success").fadeOut("slow");
            });

            $("a:contains(Unpublish)").click(function (event) {
                event.preventDefault();
                const unpublishUrl = $(this).attr("href");
                const quizId = unpublishUrl.split("/")[3];
                $("#deleteForm").data("quizId", quizId).data("unpublication", true);

                $.ajax({
                    type: "GET",
                    url: unpublishUrl,
                    error: function (xhr) {
                        alert("Some error. See log in console");
                        console.log(xhr.responseText);
                    },
                    success: function (studentsNumber) {
                        const closedStudents = studentsNumber.closedStudents;
                        const totalStudents = studentsNumber.totalStudents;
                        const modalBody = $(".modal-body");
                        $("#modalLabel").addClass("red").text("Danger");
                        if (closedStudents === totalStudents) {
                            modalBody.text("All students have closed this quiz. \n" +
                                "If you unpublish it results of all students will be lost. Continue?");
                        } else {
                            modalBody.text("Only " + closedStudents + " / " + totalStudents + " students " +
                                "closed this quiz. If you unpublish it, the results of all students " +
                                "will be lost and the remaining students will not be able " +
                                "to pass this quiz. Continue?");
                        }
                        modalBody.append(
                            '<br>\n' +
                            '<br>\n' +
                            '<div class="col-9 form-group">\n' +
                            '    <label class="col-form-label" for="password">Enter password to confirm action</label>\n' +
                            '    <input type="password" class="form-control modal-input" id="password" name="password">\n' +
                            '</div>');
                        $("#modal").modal();
                    }
                });
            });

            $("#deleteForm").submit(function () {
                if ($(this).data("unpublication")) {
                    $(this).removeData("unpublication");
                    const password = "${password}";
                    const inputPassword = $("#password").val();
                    if (inputPassword !== password) {
                        const modalBody = $(".modal-body");
                        modalBody.find(".error").remove();
                        modalBody.append('<div class="error">Incorrect password</div>');
                        return false;
                    }
                    const quizId = $(this).data("quizId");
                    $(this).attr("action", "/teacher/quizzes/" + quizId + "/unpublish-from-quizzes");
                    return true;
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="delete-success" class="col-lg-5 mx-auto text-center correct update-success">
        Quiz '${deletedQuiz}' successfully deleted
        <button id="close" class="close">&times;</button>
    </div>
    <br>
    <div class="input-group">
        <input type="search" class="col-lg-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <a href="/teacher/quizzes/create" class="btn btn-success btn-wide float-right">
        <i class="fa fa-book"></i> New quiz
    </a>
    <h3>Unpublished quizzes</h3>
    <c:choose>
        <c:when test="${empty unpublishedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    You do not have unpublished quizzes
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 30%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 8%">Score</th>
                    <th style="width: 15%;">Creation date</th>
                    <th style="width: 17%"></th>
                    <th style="width: 8%"></th>
                    <th style="width: 12%"></th>
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
                            <c:choose>
                                <c:when test="${unpublishedQuiz.questionsNumber eq 0}">
                                    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions" class="success">
                                        <i class="fa fa-plus"></i> Add questions
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/publication" class="success">
                                        <i class="fa fa-share-square-o"></i> Publish
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/edit">
                                <i class="fa fa-edit"></i> Edit
                            </a>
                        </td>
                        <td>
                            <button value="${unpublishedQuiz.quizId}" class="danger-button">
                                <i class="fa fa-trash-o"></i> Delete
                            </button>
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
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    You do not have published quizzes
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 30%">Name</th>
                    <th style="width: 10%">Questions</th>
                    <th style="width: 8%">Score</th>
                    <th style="width: 15%;">Creation date</th>
                    <th style="width: 20%"></th>
                    <th style="width: 17%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${publishedQuizzes}" var="publishedQuiz">
                    <tr>
                        <td><a href="/teacher/quizzes/${publishedQuiz.quizId}">${publishedQuiz.name}</a></td>
                        <td>${publishedQuiz.questionsNumber}</td>
                        <td>${publishedQuiz.score}</td>
                        <td><localDate:format value="${publishedQuiz.creationDate}"/></td>
                        <td>
                            <a href="/teacher/quizzes/${publishedQuiz.quizId}/publication" class="success">
                                <i class="fa fa-share-square-o"></i> Publish again
                            </a>
                        </td>
                        <td>
                            <a href="/teacher/quizzes/${publishedQuiz.quizId}/students-number" class="danger">
                                <i class="fa fa-close"></i> Unpublish
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <div>
        <button class="btn btn-primary" value="Back" onclick="window.history.go(-1);">Back</button>
    </div>

    <div class="modal fade" id="modal" tabindex="-1" role="dialog"
         aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">Attention</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <form id="deleteForm" action="" method="post">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                        <button type="submit" name="deletedQuiz" value="" id="yes" class="btn btn-primary">Yes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
