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
            const editSuccess = "${editSuccess}";
            const unpublishSuccess = "${unpublishSuccess}";
            if (editSuccess) {
                $("#update-success").fadeIn("slow");
            }
            if (unpublishSuccess) {
                $("#update-success").html(
                    'Quiz successfully unpublished\n' +
                    '<button id="close" class="close">&times;</button>').fadeIn("slow");
            }

            const createSuccess = "${createSuccess}";
            if (createSuccess) {
                $("#update-success").html('Quiz successfully created\n' +
                    '        <button id="close" class="close">&times;</button>')
                    .fadeIn("slow");
            }

            $("#close").click(function () {
                $("#update-success").fadeOut("slow");
            });

            if ("${unpublishedQuiz.questionsNumber}" === "0") {
                $("#preview").remove();

                const warning = $("#warning");
                warning.text("You have no questions in this quiz");

                const publish = $("#publish");
                const message = "Add questions to this quiz then you can publish it";
                publish.find("a").addClass("disabled");
                publish.find("i").removeClass("fa fa-share-square-o");
                publish.find("i").addClass("fa fa-ban red");
                publish.attr("tabindex", "0");
                publish.attr("data-toggle", "tooltip");
                publish.attr("data-placement", "bottom");
                publish.attr("title", message);
                publish.tooltip();

                publish.parent().after('<div class="col-auto">\n' +
                    '                <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions" class="btn btn-success btn-wide">\n' +
                    '                    <i class="fa fa-plus"></i> Add questions\n' +
                    '                </a>\n' +
                    '           </div>');
            }

            $("#back").click(function () {
                const previousUri = document.referrer;
                const createQuizUri = "http://${header["host"]}${pageContext.request.contextPath}/teacher/quizzes/create";
                const editQuizUri = "http://${header["host"]}${pageContext.request.contextPath}/teacher/quizzes/" + ${unpublishedQuiz.quizId} +"/edit";
                if (previousUri === createQuizUri || previousUri === editQuizUri) {
                    window.history.go(-2);
                } else {
                    window.history.go(-1);
                }
            });

            $("#delete").click(function () {
                const quizName = $(this).siblings("h2").text();
                $("#yes").val(quizName);
                $("#deleteForm").attr("action", "/teacher/quizzes/${unpublishedQuiz.quizId}/delete");
                $(".modal-body").text("Are you sure you want to delete quiz '" + quizName + "'?");
                $("#modal").modal();
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="update-success" class="col-lg-5 mx-auto text-center correct update-success">
        Quiz information successfully changed
        <button id="close" class="close">&times;</button>
    </div>
    <h2><c:out value="${unpublishedQuiz.name}"/></h2>
    <div class="row">
        <div class="col-auto">
            <div class="row no-gutters align-items-center highlight-danger">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
                         width="25" height="25">
                </div>
                <div id="warning" class="col">
                    This quiz is not published
                </div>
            </div>
        </div>
        <div class="col-auto">
            <span id="publish">
                <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/publication" class="btn btn-success">
                    <i class="fa fa-share-square-o"></i> Publish
                </a>
            </span>
        </div>
    </div>
    <c:if test="${unpublishedQuiz.description ne null}">
        <div class="col-lg-6">
            <strong>Description: </strong><c:out value="${unpublishedQuiz.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
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
        <div class="col-lg-6">
            <strong>Explanation: </strong><c:out value="${unpublishedQuiz.explanation}"/>
        </div>
        <div class="row no-gutters align-items-center highlight-primary">
            <div class="col-auto mr-3">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25">
            </div>
            <div class="col">
                Students will see explanation after all group close this quiz
            </div>
        </div>
    </c:if>
    <button id="back" class="btn btn-primary">Back</button>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions" class="btn btn-primary">Questions</a>
    <a id="preview" href="/quizzes/${unpublishedQuiz.quizId}/initialize" class="btn btn-primary">Preview</a>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/edit" class="btn btn-primary">
        <i class="fa fa-edit"></i> Edit
    </a>
    <button id="delete" class="btn btn-danger">
        <i class="fa fa-trash-o"></i> Delete
    </button>

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
                        <button id="yes" type="submit" name="deletedQuiz" value="" class="btn btn-primary">Yes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
