<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quiz.unpublished"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(() => {
            const editSuccess = "${editSuccess}";
            const unpublishSuccess = "${unpublishSuccess}";
            if (editSuccess) {
                $("#update-success").fadeIn("slow");
            }
            if (unpublishSuccess) {
                $("#update-success").html(
                    '<spring:message code="quiz.unpublished"/>' +
                    '<button id="close" class="close">&times;</button>').fadeIn("slow");
            }

            const createSuccess = "${createSuccess}";
            if (createSuccess) {
                $("#update-success").html('<spring:message code="quiz.created"/>' +
                    '        <button id="close" class="close">&times;</button>')
                    .fadeIn("slow");
            }

            $("#close").click(function () {
                $("#update-success").fadeOut("slow");
            });

            if ("${unpublishedQuiz.questionsNumber}" === "0") {
                $("#preview").remove();

                const warning = $("#warning");
                warning.text('<spring:message code="quiz.no.questions"/>');

                const publish = $("#publish");
                const message = '<spring:message code="quiz.add.questions.msg"/>';
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
                    '                    <i class="fa fa-plus"></i> <spring:message code="quiz.add.questions"/>\n' +
                    '                </a>\n' +
                    '           </div>');
            }

            $("#back").click(function () {
                const previousUri = document.referrer;
                const createQuizUri = "http://${header["host"]}${pageContext.request.contextPath}/teacher/quizzes/create";
                const editQuizUri = "http://${header["host"]}${pageContext.request.contextPath}/teacher/quizzes/" + ${unpublishedQuiz.quizId} +"/edit";
                if (previousUri === createQuizUri || previousUri === editQuizUri) {
                    window.history.go(-2);
                } else if (previousUri.includes('/time-up') || previousUri.includes('/congratulations')) {
                    window.location = '/teacher/quizzes';
                } else {
                    window.history.go(-1);
                }
            });

            $("#delete").click(function () {
                window.scrollTo(0, 0);
                const quizName = $(this).siblings("h2").text();
                const quizId = $(this).prev().attr("href").split("/")[3];
                $("#yes").data("quizId", quizId).data("quizName", quizName);
                $(".modal-body").text('<spring:message code="quiz.sure.delete"/> \'' + quizName + '\?');
                $("#modal").modal();
            });

            $("#yes").click(function () {
                const quizId = $(this).data("quizId");
                const quizName = $(this).data("quizName");

                $.ajax({
                    type: "POST",
                    url: "/teacher/quizzes/" + quizId + "/delete",
                    success: function () {
                        sessionStorage.setItem("quizName", quizName);
                        window.location.href =
                            "http://${pageContext.request.contextPath}${header['host']}/teacher/quizzes";
                    },
                    error: function (resp) {
                        alert("Some error. See log in console");
                        console.log(resp.responseText);
                    }
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="update-success" class="col-lg-5 mx-auto text-center correct update-success">
        <spring:message code="quiz.changed"/>
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
                    <spring:message code="quiz.not.published"/>
                </div>
            </div>
        </div>
        <div class="col-auto">
            <span id="publish">
                <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/publication" class="btn btn-success btn-wide">
                    <i class="fa fa-share-square-o"></i> <spring:message code="quiz.publish.publish"/>
                </a>
            </span>
        </div>
    </div>
    <c:if test="${unpublishedQuiz.description ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="quiz.description"/>: </strong><c:out value="${unpublishedQuiz.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="quiz.creation.date"/></td>
            <td><localDate:format value="${unpublishedQuiz.creationDate}"/></td>
        </tr>
        <c:if test="${unpublishedQuiz.passingTime ne null}">
            <tr>
                <td><spring:message code="quiz.passing.time"/></td>
                <td><duration:format value="${unpublishedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td><spring:message code="quiz.score"/></td>
            <td>${unpublishedQuiz.score}</td>
        </tr>
        <tr>
            <td><spring:message code="quiz.total.questions"/></td>
            <td>${unpublishedQuiz.questionsNumber}</td>
        </tr>
        <c:if test="${not empty questions}">
            <tr>
                <td><spring:message code="quiz.questions.by.types"/>:</td>
                <td></td>
            </tr>
        </c:if>
        <c:if test="${questions['ONE_ANSWER'] ne null}">
            <tr>
                <td style="font-weight: normal"><spring:message code="question.type.one_answer"/></td>
                <td>${questions['ONE_ANSWER']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['FEW_ANSWERS'] ne null}">
            <tr>
                <td style="font-weight: normal;"><spring:message code="question.type.few_answers"/></td>
                <td>${questions['FEW_ANSWERS']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['ACCORDANCE'] ne null}">
            <tr>
                <td style="font-weight: normal"><spring:message code="question.type.accordance"/></td>
                <td>${questions['ACCORDANCE']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['SEQUENCE'] ne null}">
            <tr>
                <td style="font-weight: normal"><spring:message code="question.type.sequence"/></td>
                <td>${questions['SEQUENCE']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['NUMBER'] ne null}">
            <tr>
                <td style="font-weight: normal"><spring:message code="question.type.number"/></td>
                <td>${questions['NUMBER']}</td>
            </tr>
        </c:if>
    </table>
    <c:if test="${unpublishedQuiz.explanation ne null}">
        <div class="col-lg-6">
            <strong><spring:message code="quiz.explanation"/>: </strong><c:out value="${unpublishedQuiz.explanation}"/>
        </div>
        <div class="row no-gutters align-items-center highlight-primary">
            <div class="col-auto mr-3">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25">
            </div>
            <div class="col">
                <spring:message code="quiz.explanation.create"/>
            </div>
        </div>
    </c:if>
    <button type="button" id="back" class="btn btn-primary"><spring:message code="back"/></button>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/questions" class="btn btn-primary btn-wide">
        <spring:message code="quiz.questions"/>
    </a>
    <a id="preview" href="/quizzes/${unpublishedQuiz.quizId}/initialize" class="btn btn-primary btn-wide">
        <spring:message code="quiz.preview"/>
    </a>
    <a href="/teacher/quizzes/${unpublishedQuiz.quizId}/edit" class="btn btn-primary btn-wide">
        <i class="fa fa-edit"></i> <spring:message code="edit"/>
    </a>
    <button id="delete" class="btn btn-danger btn-wide">
        <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
    </button>

    <div class="modal fade" id="modal" tabindex="-1" role="dialog"
         aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title red" id="modalLabel"><spring:message code="danger"/></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <spring:message code="no"/>
                    </button>
                    <button id="yes" type="button" value="" class="btn btn-primary">
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
