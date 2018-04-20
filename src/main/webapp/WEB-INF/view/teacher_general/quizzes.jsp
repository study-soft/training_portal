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

            $(document).on("click", "button:contains(Delete)", function (event) {
                event.preventDefault();
                const quizName = $(this).parent("td").siblings().first().text();
                const quizId = $(this).val();
                $("#yes-delete").data("quizId", quizId).data("quizName", quizName);

                const modal = $("#modalDelete");
                modal.find(".modal-body").text("Are you sure you want to delete quiz '" + quizName + "'?");
                modal.modal();
            });

            $("#yes-delete").click(function () {
                $("#modalDelete").modal("toggle");
                const yes = $("#yes-delete");
                const quizId = yes.data("quizId");
                const quizName = yes.data("quizName");

                $.ajax({
                    type: "POST",
                    url: "/teacher/quizzes/" + quizId + "/delete",
                    error: function (xhr) {
                        alert("Some error. See log in console");
                        console.log(xhr.responseText);
                    },
                    success: function () {
                        let unpublishedQuizzes = $("#unpublishedQuizzes");
                        unpublishedQuizzes.find("td:first-child a").each(function () {
                            if ($(this).attr("href").split("/")[3] === quizId) {
                                $(this).parents("tr").remove();
                                if (unpublishedQuizzes.find("tr").length === 1) {
                                    unpublishedQuizzes.replaceWith(
                                        '<div id="noUnpublishedQuizzesInfo" class="row no-gutters align-items-center highlight-primary">\n' +
                                        '                <div class="col-auto mr-3">\n' +
                                        '                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                        '                         width="25" height="25">\n' +
                                        '                </div>\n' +
                                        '                <div class="col">\n' +
                                        '                    You do not have unpublished quizzes\n' +
                                        '                </div>\n' +
                                        '            </div>');
                                }
                            }
                        });

                        window.scrollTo(0, 0);
                        $("#delete-success").html(
                            'Quiz \'' + quizName + '\' was successfully deleted\n' +
                            '<button id="close" class="close">&times;</button>')
                            .hide().fadeIn("slow");
                    }
                });
            });

            $(document).on("click", "#close", function () {
                $("#delete-success").fadeOut("slow");
            });

            $("a:contains(Unpublish)").click(function (event) {
                event.preventDefault();

                const unpublishUrl = $(this).attr("href");
                const quizId = unpublishUrl.split("/")[3];
                const quizName = $(this).parents("tr").find("a").first().text();
                $("#yes-unpublish").data("quizId", quizId).data("quizName", quizName);

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
                        const modal = $("#modalUnpublish");
                        const modalBody = modal.find(".modal-body");
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
                        modal.modal();
                    }
                });
            });

            $("#yes-unpublish").click(function () {
                const password = "${password}";
                const inputPassword = $("#password").val();
                if (inputPassword !== password) {
                    const modalBody = $("#modalUnpublish").find(".modal-body");
                    modalBody.find(".error").remove();
                    modalBody.append('<div class="error">Incorrect password</div>');
                    return false;
                }

                $("#modalUnpublish").modal("toggle");
                const quizId = $(this).data("quizId");
                const quizName = $(this).data("quizName");

                $.ajax({
                    type: "POST",
                    url: "/teacher/quizzes/" + quizId + "/unpublish-from-quizzes",
                    success: function () {
                        if ($("#unpublishedQuizzes").length === 0) {
                            $("#noUnpublishedQuizzesInfo").replaceWith(
                                '<table id="unpublishedQuizzes" class="table">\n' +
                                '    <thead>\n' +
                                '    <tr>\n' +
                                '        <th style="width: 30%">Name</th>\n' +
                                '        <th style="width: 10%">Questions</th>\n' +
                                '        <th style="width: 8%">Score</th>\n' +
                                '        <th style="width: 15%;">Creation date</th>\n' +
                                '        <th style="width: 17%"></th>\n' +
                                '        <th style="width: 8%"></th>\n' +
                                '        <th style="width: 12%"></th>\n' +
                                '    </tr>\n' +
                                '    </thead>\n' +
                                '    <tbody>\n' +
                                '    </tbody>\n' +
                                '</table>');
                        }

                        const unpulblishedQuizzes = $("#unpublishedQuizzes");
                        const publishedQuizzes = $("#publishedQuizzes");

                        const publishedQuizRow = publishedQuizzes
                            .find("a:contains(" + quizName + ")").parents("tr");
                        const rowToInsert = publishedQuizRow.clone();
                        rowToInsert.find("td:gt(3)").remove();
                        rowToInsert.append(
                            '<td>\n' +
                            '   <a href="/teacher/quizzes/' + quizId + '/publication" class="success">\n' +
                            '       <i class="fa fa-share-square-o"></i> Publish\n' +
                            '    </a>' +
                            '</td>\n' +
                            '<td>\n' +
                            '   <a href="/teacher/quizzes/' + quizId + '/edit">\n' +
                            '       <i class="fa fa-edit"></i> Edit\n' +
                            '   </a>\n' +
                            '</td>\n' +
                            '<td>\n' +
                            '   <button type="button" value="' + quizId + '" class="danger-button">\n' +
                            '       <i class="fa fa-trash-o"></i> Delete\n' +
                            '   </button>\n' +
                            '</td>');

                        unpulblishedQuizzes.find("tbody").append(rowToInsert);
                        publishedQuizRow.remove();
                        if (publishedQuizzes.find("tr").length === 1) {
                            publishedQuizzes.replaceWith(
                                '<div class="row no-gutters align-items-center highlight-primary">\n' +
                                '   <div class="col-auto mr-3">\n' +
                                '       <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                '             width="25" height="25">\n' +
                                '   </div>\n' +
                                '   <div class="col">\n' +
                                '       You do not have published quizzes\n' +
                                '   </div>\n' +
                                '</div>');
                        }
                        window.scrollTo(0, 0);
                        $("#delete-success").html(
                            'Quiz \'' + quizName + '\' was successfully unpublished\n' +
                            '<button id="close" class="close">&times;</button>')
                            .hide().fadeIn("slow");
                    }
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="delete-success" class="col-lg-5 mx-auto text-center correct update-success">
        <button id="close" class="close">&times;</button>
    </div>
    <br>
    <div class="input-group">
        <input type="search" class="col-lg-4 form-control" placeholder="Search...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/teacher/quizzes/create" class="btn btn-success btn-wide float-right">
        <i class="fa fa-book"></i> New quiz
    </a>
    <h3>Unpublished quizzes</h3>
    <c:choose>
        <c:when test="${empty unpublishedQuizzes}">
            <div id="noUnpublishedQuizzesInfo" class="row no-gutters align-items-center highlight-primary">
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
            <table id="unpublishedQuizzes" class="table">
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
                        <td>
                            <a href="/teacher/quizzes/${unpublishedQuiz.quizId}">
                                <c:out value="${unpublishedQuiz.name}"/>
                            </a>
                        </td>
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
                            <button type="button" value="${unpublishedQuiz.quizId}" class="danger-button">
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
            <table id="publishedQuizzes" class="table">
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
                        <td>
                            <a href="/teacher/quizzes/${publishedQuiz.quizId}">
                                <c:out value="${publishedQuiz.name}"/>
                            </a>
                        </td>
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

    <div class="modal fade" id="modalDelete" tabindex="-1" role="dialog"
         aria-labelledby="modalLabelDelete" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabelDelete">Attention</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <button id="yes-delete" type="button" name="deletedQuiz" value="" class="btn btn-primary">Yes
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalUnpublish" tabindex="-1" role="dialog"
         aria-labelledby="modalLabelUnpublish" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title red" id="modalLabelUnpublish">Danger</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <button id="yes-unpublish" type="button" name="deletedQuiz" value="" class="btn btn-primary">Yes
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
