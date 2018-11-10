<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quizzes"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const quizName = sessionStorage.getItem("quizName");
            if (quizName) {
                sessionStorage.removeItem("quizName");
                $("#delete-success").html(
                    '<spring:message code="quiz.quiz"/> \'' +
                    quizName.trim() + '\' <spring:message code="quiz.successfully.deleted"/>\n' +
                    '<button id="close" class="close">&times;</button>')
                    .hide().fadeIn("slow");
            }

            $("input[type=search]").on("keyup", function () {
                const value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });

            $(document).on("click", "button:has(i[class='fa fa-trash-o'])", function (event) {
                window.scrollTo(0, 0);
                event.preventDefault();
                const quizName = $(this).parent("td").siblings().first().text();
                const quizId = $(this).val();
                $("#yes-delete").data("quizId", quizId).data("quizName", quizName);

                const modal = $("#modalDelete");
                modal.find(".modal-body").text('<spring:message code="quiz.sure.delete"/> \'' + quizName.trim() + '\'?');
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
                                        '                    <spring:message code="quiz.quizzes.unpublished.not"/>\n' +
                                        '                </div>\n' +
                                        '            </div>');
                                }
                            }
                        });

                        window.scrollTo(0, 0);
                        $("#delete-success").html(
                            '<spring:message code="quiz.quiz"/> \'' + quizName.trim() +
                            '\' <spring:message code="quiz.successfully.deleted"/>\n' +
                            '<button id="close" class="close">&times;</button>')
                            .hide().fadeIn("slow");
                    }
                });
            });

            $(document).on("click", "#close", function () {
                $("#delete-success").fadeOut("slow");
            });

            $("a:has(i[class='fa fa-close'])").click(function (event) {
                event.preventDefault();
                window.scrollTo(0, 0);

                const unpublishUrl = $(this).attr("href");
                const quizId = unpublishUrl.split("/")[3];
                const quizName = $(this).parents("tr").find("a").first().text().trim();
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
                            modalBody.text('<spring:message code="quiz.published.all.students.closed"/>. \n' +
                                '<spring:message code="quiz.published.results.lost"/>?');
                        } else {
                            modalBody.text('<spring:message code="quiz.published.only"/> ' + closedStudents +
                                '/' + totalStudents + ' <spring:message code="quiz.published.students"/> ' +
                                '<spring:message code="quiz.published.results.lost"/>?');
                        }
                        modalBody.append(
                            '<br>\n' +
                            '<br>\n' +
                            '<div class="col-9 form-group">\n' +
                            '    <label class="col-form-label" for="password"><spring:message code="quiz.published.password.enter"/></label>\n' +
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
                    modalBody.append('<div class="error"><spring:message code="quiz.published.password.incorrect"/></div>');
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
                                '        <th style="width: 26%"><spring:message code="quiz.name"/></th>\n' +
                                '        <th style="width: 9%"><spring:message code="quiz.questions"/></th>\n' +
                                '        <th style="width: 6%"><spring:message code="quiz.score"/></th>\n' +
                                '        <th style="width: 12%;"><spring:message code="quiz.created.created"/></th>\n' +
                                '        <th style="width: 16%"></th>\n' +
                                '        <th style="width: 17%"></th>\n' +
                                '        <th style="width: 14%"></th>\n' +
                                '    </tr>\n' +
                                '    </thead>\n' +
                                '    <tbody>\n' +
                                '    </tbody>\n' +
                                '</table>');
                        }

                        const unpulblishedQuizzes = $("#unpublishedQuizzes");
                        const publishedQuizzes = $("#publishedQuizzes");

                        const publishedQuizRow = publishedQuizzes
                            .find("a:contains(" + quizName.trim() + ")").parents("tr");
                        const rowToInsert = publishedQuizRow.clone();
                        rowToInsert.find("td:gt(3)").remove();
                        rowToInsert.append(
                            '<td>\n' +
                            '   <a href="/teacher/quizzes/' + quizId + '/publication" class="success">\n' +
                            '       <i class="fa fa-share-square-o"></i> <spring:message code="quiz.publish.publish"/>\n' +
                            '    </a>' +
                            '</td>\n' +
                            '<td>\n' +
                            '   <a href="/teacher/quizzes/' + quizId + '/edit">\n' +
                            '       <i class="fa fa-edit"></i> <spring:message code="edit"/>\n' +
                            '   </a>\n' +
                            '</td>\n' +
                            '<td>\n' +
                            '   <button type="button" value="' + quizId + '" class="danger-button">\n' +
                            '       <i class="fa fa-trash-o"></i> <spring:message code="delete"/>\n' +
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
                                '       <spring:message code="quiz.quizzes.published.not"/>\n' +
                                '   </div>\n' +
                                '</div>');
                        }
                        window.scrollTo(0, 0);
                        $("#delete-success").html(
                            '<spring:message code="quiz.quiz"/> \'' + quizName + '\' <spring:message code="quiz.successfully.unpublished"/>\n' +
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
    <div id="delete-success" class="col-lg-7 mx-auto text-center correct update-success">
        <button id="close" class="close">&times;</button>
    </div>
    <h2><spring:message code="quiz.quizzes"/></h2>
    <div class="input-group">
        <input type="search" class="col-lg-4 form-control" placeholder="<spring:message code="search"/>...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/teacher/quizzes/create" class="btn btn-success btn-wide float-right">
        <i class="fa fa-book"></i> <spring:message code="quiz.new"/>
    </a>
    <h4><spring:message code="quiz.quizzes.unpublished"/></h4>
    <c:choose>
        <c:when test="${empty unpublishedQuizzes}">
            <div id="noUnpublishedQuizzesInfo" class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.quizzes.unpublished.not"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table id="unpublishedQuizzes" class="table">
                <thead>
                <tr>
                    <th style="width: 26%"><spring:message code="quiz.name"/></th>
                    <th style="width: 9%"><spring:message code="quiz.questions"/></th>
                    <th style="width: 6%"><spring:message code="quiz.score"/></th>
                    <th style="width: 12%;"><spring:message code="quiz.created.created"/></th>
                    <th style="width: 16%"></th>
                    <th style="width: 17%"></th>
                    <th style="width: 14%"></th>
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
                                        <i class="fa fa-plus"></i> <spring:message code="quiz.add.questions"/>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/publication" class="success">
                                        <i class="fa fa-share-square-o"></i> <spring:message code="quiz.publish.publish"/>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/edit">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </td>
                        <td>
                            <button type="button" value="${unpublishedQuiz.quizId}" class="danger-button">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <h4><spring:message code="quiz.quizzes.published"/></h4>
    <c:choose>
        <c:when test="${empty publishedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.quizzes.published.not"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table id="publishedQuizzes" class="table">
                <thead>
                <tr>
                    <th style="width: 26%"><spring:message code="quiz.name"/></th>
                    <th style="width: 9%"><spring:message code="quiz.questions"/></th>
                    <th style="width: 6%"><spring:message code="quiz.score"/></th>
                    <th style="width: 12%;"><spring:message code="quiz.created.created"/></th>
                    <th style="width: 20%"></th>
                    <th style="width: 27%"></th>
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
                                <i class="fa fa-share-square-o"></i> <spring:message code="quiz.published.publish.again"/>
                            </a>
                        </td>
                        <td>
                            <a href="/teacher/quizzes/${publishedQuiz.quizId}/students-number" class="danger">
                                <i class="fa fa-close"></i> <spring:message code="quiz.published.unpublish"/>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <div>
        <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
    </div>

    <div class="modal fade" id="modalDelete" tabindex="-1" role="dialog"
         aria-labelledby="modalLabelDelete" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title red" id="modalLabelDelete"><spring:message code="danger"/></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <spring:message code="no"/>
                    </button>
                    <button id="yes-delete" type="button" name="deletedQuiz" value="" class="btn btn-primary">
                        <spring:message code="yes"/>
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
                    <h5 class="modal-title red" id="modalLabelUnpublish"><spring:message code="danger"/></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <spring:message code="no"/>
                    </button>
                    <button id="yes-unpublish" type="button" name="deletedQuiz" value="" class="btn btn-primary">
                        <spring:message code="yes"/>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
