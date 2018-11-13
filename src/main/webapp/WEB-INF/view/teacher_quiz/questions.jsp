<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.questions"/></title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <div id="pageHeaderRow" class="row">
        <div class="col-sm-9">
            <c:choose>
                <c:when test="${quiz.questionsNumber ne 0}">
                    <h2 id="pageHeader"><spring:message code="questions.header"/> '<c:out value="${quiz.name}"/>'</h2>
                </c:when>
                <c:otherwise>
                    <div id="noQuestionsInfo" class="row no-gutters align-items-center highlight-primary">
                        <div class="col-auto mr-3">
                            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                                 width="25" height="25">
                        </div>
                        <div class="col">
                            <spring:message code="questions.not.exist"/> '<c:out value="${quiz.name}"/>'
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="col-sm-2 offset-sm-1 shifted-down-20px">
            <button id="addQuestion" type="button" class="btn btn-success btn-wide">
                <i class="fa fa-plus"></i> <spring:message code="questions.add"/>
            </button>
        </div>
    </div>
    <c:if test="${not empty questionsOneAnswer}">
        <%--***********************     One answer questions     *****************************--%>
        <h4 class="shifted-left"><spring:message code="quiz.questions.one.answer"/></h4>
        <c:forEach items="${questionsOneAnswer}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-sm-7">
                        <h5><c:out value="${question.body}"/></h5>
                    </div>
                    <div class="col-auto col-sm-auto">
                        <h6>${question.score} <spring:message code="quiz.passing.points"/></h6>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="ONE_ANSWER">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </div>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
                    <c:choose>
                        <c:when test="${answer.correct eq true}">
                            <div class="col-lg-8">
                                <div class="correct"><c:out value="${answer.body}"/></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="col-lg-8">
                                <div class="incorrect"><c:out value="${answer.body}"/></div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${question.explanation ne null}">
                    <div>
                        <strong><spring:message code="quiz.explanation"/>: </strong>
                        <c:out value="${question.explanation}"/>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsFewAnswers}">
        <%--***********************     Few answers questions     *****************************--%>
        <h4 class="shifted-left"><spring:message code="quiz.questions.few.answers"/></h4>
        <c:forEach items="${questionsFewAnswers}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-sm-7">
                        <h5><c:out value="${question.body}"/></h5>
                    </div>
                    <div class="col-auto col-sm-auto">
                        <h6>${question.score} <spring:message code="quiz.passing.points"/></h6>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="FEW_ANSWERS">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </div>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
                    <c:choose>
                        <c:when test="${answer.correct eq true}">
                            <div class="col-lg-8">
                                <div class="correct"><c:out value="${answer.body}"/></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="col-lg-8">
                                <div class="incorrect"><c:out value="${answer.body}"/></div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${question.explanation ne null}">
                    <div>
                        <strong><spring:message code="quiz.explanation"/>: </strong>
                        <c:out value="${question.explanation}"/>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsAccordance}">
        <%--***********************     Accordance questions     *****************************--%>
        <h4 class="shifted-left"><spring:message code="quiz.questions.accordance"/></h4>
        <c:forEach items="${questionsAccordance}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-sm-7">
                        <h5><c:out value="${question.body}"/></h5>
                    </div>
                    <div class="col-auto col-sm-auto">
                        <h6>${question.score} <spring:message code="quiz.passing.points"/></h6>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="ACCORDANCE">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:set var="leftSide" value="${quizAnswersAccordance[question.questionId].leftSide}" scope="page"/>
                <c:set var="rightSide" value="${quizAnswersAccordance[question.questionId].rightSide}" scope="page"/>
                <table class="col-lg-8 table-info">
                    <c:forEach items="${leftSide}" var="item" varStatus="status">
                        <tr>
                            <td style="width: 50%"><c:out value="${item}"/></td>
                            <td style="width: 50%"><c:out value="${rightSide[status.index]}"/></td>
                        </tr>
                    </c:forEach>
                </table>
                <c:if test="${question.explanation ne null}">
                    <div>
                        <strong><spring:message code="quiz.explanation"/>: </strong>
                        <c:out value="${question.explanation}"/>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsSequence}">
        <%--***********************     Sequence questions     *****************************--%>
        <h4 class="shifted-left"><spring:message code="quiz.questions.sequence"/></h4>
        <c:forEach items="${questionsSequence}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-sm-7">
                        <h5><c:out value="${question.body}"/></h5>
                    </div>
                    <div class="col-auto col-sm-auto">
                        <h6>${question.score} <spring:message code="quiz.passing.points"/></h6>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="SEQUENCE">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </div>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:set var="correctList" value="${quizAnswersSequence[question.questionId].correctList}" scope="page"/>
                <table class="col-lg-8 table-info">
                    <c:forEach items="${correctList}" var="item" varStatus="status">
                        <tr>
                            <td style="width: 10%;">${status.index + 1}</td>
                            <td style="width: 90%;"><c:out value="${item}"/></td>
                        </tr>
                    </c:forEach>
                </table>
                <c:if test="${question.explanation ne null}">
                    <div>
                        <strong><spring:message code="quiz.explanation"/>: </strong>
                        <c:out value="${question.explanation}"/>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsNumber}">
        <%--***********************     Numerical questions     *****************************--%>
        <h4 class="shifted-left"><spring:message code="quiz.questions.numerical"/></h4>
        <c:forEach items="${questionsNumber}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-sm-7">
                        <h5><c:out value="${question.body}"/></h5>
                    </div>
                    <div class="col-auto col-sm-auto">
                        <h6>${question.score} <spring:message code="quiz.passing.points"/></h6>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="NUMBER">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </div>
                    </div>
                    <div class="col-sm-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <table class="col-lg-8 table-info">
                    <tr>
                        <td style="width: 50%;"><spring:message code="quiz.answer"/></td>
                        <td style="width: 50%;">${quizAnswersNumber[question.questionId].correct}</td>
                    </tr>
                </table>
                <c:if test="${question.explanation ne null}">
                    <div>
                        <strong><spring:message code="quiz.explanation"/>: </strong>
                        <c:out value="${question.explanation}"/>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </c:if>
    <button class="btn btn-primary" onclick="window.history.go(-1)">
        <spring:message code="back"/>
    </button>
</div>
<br>
<script>
    var oldHeader;
    var oldAnswers;
    <%--// question one answer--%>
    $(document).ready(function () {
        var rowOneAnswer = '<div id="new-row" class="row no-gutters margin-row">\n' +
            '                <div class="col-auto mx-sm-3">\n' +
            '                    <div class="custom-control custom-radio shifted-down-10px">\n' +
            '                        <input type="radio" id="" name="correct" value="" class="custom-control-input">\n' +
            '                        <label for="correct2" class="custom-control-label"></label>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '                <div class="col col-sm-8 mr-sm-4">\n' +
            '                    <input type="text" class="form-control" name="">\n' +
            '                </div>\n' +
            '                <div class="col-auto">\n' +
            '                    <button type="button" class="answer-delete"><i class="fa fa-close"></i></button>\n' +
            '                </div>\n' +
            '            </div>';

        var rowFewAnswers = '<div id="new-row" class="row no-gutters margin-row">\n' +
            '                <div class="col-auto mx-sm-3">\n' +
            '                    <div class="custom-control custom-checkbox shifted-down-10px">\n' +
            '                        <input type="checkbox" id="" name="" value="correct" class="custom-control-input">\n' +
            '                        <label for="" class="custom-control-label"></label>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '                <div class="col col-sm-8 mr-sm-4">\n' +
            '                    <input type="text" class="form-control">\n' +
            '                </div>\n' +
            '                <div class="col-auto">\n' +
            '                    <button type="button" class="answer-delete"><i class="fa fa-close"></i></button>\n' +
            '                </div>\n' +
            '            </div>';

        $(document).on("click", "#addAnswer", function () {
            var questionType = $(this).val();
            var lastRow;
            var newRow;
            var counter;
            if (questionType === "oneAnswer") {
                lastRow = $(".margin-row:last");
                counter = Number(lastRow.attr("id")) + 1;
                lastRow.after(rowOneAnswer);
                newRow = $("#new-row");
                newRow.find("input[type='radio']")
                    .attr("id", "status" + counter)
                    .val("answer" + counter)
                    .next().attr("for", "status" + counter);
                newRow.find("input[type='text']")
                    .attr("id", "answer" + counter)
                    .attr("name", "answer" + counter)
                    .addClass("is-invalid");
                newRow.find(".answer-delete").val(counter);
                newRow.attr("id", counter);
            } else if (questionType === "fewAnswers") {
                lastRow = $(".margin-row:last");
                counter = Number(lastRow.attr("id")) + 1;
                lastRow.after(rowFewAnswers);
                newRow = $("#new-row");
                newRow.find("input[type='checkbox']")
                    .attr("id", "status" + counter)
                    .attr("name", "correct" + counter)
                    .val("answer" + counter)
                    .next().attr("for", "status" + counter);
                newRow.find("input[type='text']")
                    .attr("id", "answer" + counter)
                    .attr("name", "answer" + counter)
                    .addClass("is-invalid");
                newRow.find(".answer-delete").val(counter);
                newRow.attr("id", counter);
            }
        });

        $(document).on("click", ".answer-delete", function () {
            $(this).parents(".margin-row").remove();
        });

        $(document).on("change", "input[type=radio][name=correct]", function () {
            $("input[type='text'].is-valid").removeClass("is-valid").addClass("is-invalid");
            var rowNumber = $(this).attr("id").replace("status", "");
            $("#answer" + rowNumber).removeClass("is-invalid").addClass("is-valid");
        });

        $(document).on("change", ":checkbox", function () {
            var rowNumber = $(this).attr("id").replace("status", "");
            var answer = $("#answer" + rowNumber);
            if (this.checked) {
                answer.removeClass("is-invalid").addClass("is-valid");
            } else {
                answer.removeClass("is-valid").addClass("is-invalid");
            }
        });

        $(document).on("submit", "#questionForm", function (event) {
            event.preventDefault();

            var validationSuccess = true;
            $(".error").remove();
            var points = $("#points");
            if (!points.val()) {
                points.after('<div class="error"><spring:message code="questions.validation.points.not.empty"/></div>');
                validationSuccess = false;
            } else if (!points.val().match(/[0-9]+/)) {
                points.after('<div class="error"><spring:message code="questions.validation.points.digits"/></div>');
                validationSuccess = false;
            } else if (points.val().length > 9) {
                points.after('<div class="error"><spring:message code="questions.validation.points.length"/></div>');
                validationSuccess = false;
            }

            var question = $("#question");
            if (!question.val()) {
                question.after('<div class="error"><spring:message code="questions.validation.question.not.empty"/></div>');
                validationSuccess = false;
            } else if (question.val().length > 65535) {
                question.after('<div class="error"><spring:message code="questions.validation.question.length"/></div>');
                validationSuccess = false;
            }

            var explanation = $("#explanation");
            if (explanation.val().length > 65535) {
                explanation.after('<div class="error"><spring:message code="questions.validation.explanation.length"/></div>');
                validationSuccess = false;
            }

            var questionType = $("#type").val();
            switch (questionType) {
                case "ONE_ANSWER":
                    $("input[name*='answer']").each(function () {
                        validateAnswer($(this));
                    });
                    var countOfCorrect = $("input[type='radio'][name='correct']:checked").length;
                    if (countOfCorrect === 0) {
                        alert('<spring:message code="questions.validation.one.answer.select.one"/>');
                        validationSuccess = false;
                    }
                    break;
                case "FEW_ANSWERS":
                    $("input[name*='answer']").each(function () {
                        validateAnswer($(this));
                    });
                    var countOfCorrect = $("input[type='checkbox']:checked").length;
                    if (countOfCorrect === 0) {
                        alert('<spring:message code="questions.validation.few.answer.select.one"/>');
                        validationSuccess = false;
                    }
                    break;
                case "ACCORDANCE":
                case "SEQUENCE":
                    $("input[name*='left'], input[name*='right'], input[name*='sequence']").each(function () {
                        validateAnswer($(this));
                    });
                    break;
                case "NUMBER":
                    var number = $("#number");
                    if (!number.val()) {
                        number.after('<div class="error"><spring:message code="questions.validation.number.not.empty"/></div>');
                        validationSuccess = false;
                    } else if (!number.val().match(/[0-9]+/)) {
                        number.after('<div class="error"><spring:message code="questions.validation.number.digits"/></div>');
                        validationSuccess = false;
                    } else if (number.val().length > 9) {
                        number.after('<div class="error"><spring:message code="questions.validation.number.length"/></div>');
                        validationSuccess = false;
                    }
                    break;
            }

            function validateAnswer(answer) {
                if (!answer.val()) {
                    answer.after('<div class="error"><spring:message code="questions.validation.answer.not.empty"/></div>');
                    validationSuccess = false;
                } else if (answer.val().length > 65535) {
                    answer.after('<div class="error"><spring:message code="questions.validation.answer.length"/></div>');
                    validationSuccess = false;
                }
            }

            if (!validationSuccess) {
                return;
            }

            var baseQuestion = '<div class="question-header">\n' +
                '                <div class="row">\n' +
                '                    <div class="col-sm-7">\n' +
                '                        <h5></h5>\n' +
                '                    </div>\n' +
                '                    <div class="col-auto col-sm-auto">\n' +
                '                        <h6>' + $("#points").val() + ' <spring:message code="questions.points"/></h6>\n' +
                '                    </div>\n' +
                '                    <div class="col-sm-auto">\n' +
                '                        <div class="shifted-down-10px">\n' +
                '                            <a href="" type=""><i class="fa fa-edit"></i> <spring:message code="edit"/></a>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                    <div class="col-sm-auto">\n' +
                '                        <div class="shifted-down-10px">\n' +
                '                            <a href=""><i class="fa fa-trash-o"></i> <spring:message code="delete"/></a>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div id="addedAnswersContainer" class="question-answers">\n' +
                '            </div>';

            var form = $("#questionForm");
            var data = form.serialize();
            var questionId = $("#save").val();
            if (questionId) {
                data += "&questionId=" + questionId;
            }
            if ($("#type").prop("disabled")) {
                data += "&type=" + questionType;
            }
            // alert(data);
            $.ajax({
                type: form.attr("method"),
                url: form.attr("action"),
                data: data,
                error: function (xhr, status, error) {
                    console.log("status:" + status + "\nresponse message: " +
                        xhr.responseText + "\nerror: " + error);
                    alert('<spring:message code="ajax.error"/>');
                },
                success: function (savedQuestionId) {
                    // alert("success");
                    // alert("saved questionId: " + savedQuestionId);
                    const noQuestions = $("#noQuestionsInfo");
                    if (noQuestions.length !== 0) {
                        noQuestions.replaceWith('<h2 id="pageHeader"><spring:message code="questions.header"/> ' +
                            '\'<c:out value="${quiz.name}"/>\'</h2>');
                    }

                    switch (questionType) {
                        case "ONE_ANSWER":
                            form.after(baseQuestion);
                            var questionHeader = form.next();
                            questionHeader.find('a:contains(<spring:message code="delete"/>)').attr("href", savedQuestionId);
                            questionHeader.find("h5").text($("#question").val());
                            $('a[href=""][type=""]:contains(<spring:message code="edit"/>)')
                                .attr("href", savedQuestionId)
                                .attr("type", "ONE_ANSWER");
                            var correct = $("input[type=radio][name='correct']:checked").val();
                            var container = $("#addedAnswersContainer");
                            container.removeAttr("id");
                            $("input[name*='answer']").each(function () {
                                if ($(this).attr("name") === correct) {
                                    container.append('<div class="col-lg-8">\n' +
                                        '                 <div class="correct"></div>\n' +
                                        '             </div>');
                                    container.find(".correct").last().text($(this).val());
                                } else {
                                    container.append('<div class="col-lg-8">\n' +
                                        '                 <div class="incorrect"></div>\n' +
                                        '             </div>');
                                    container.find(".incorrect").last().text($(this).val());
                                }
                            });
                            var explanation = $("#explanation").val();
                            if (explanation) {
                                container.append('<div><strong><spring:message code="questions.explanation"/>: </strong></div>');
                                container.find("div").last().append(document.createTextNode(explanation));
                            }
                            form.remove();
                            break;
                        case "FEW_ANSWERS":
                            form.after(baseQuestion);
                            var questionHeader = form.next();
                            questionHeader.find('a:contains(<spring:message code="delete"/>)').attr("href", savedQuestionId);
                            questionHeader.find("h5").text($("#question").val());
                            $('a[href=""][type=""]:contains(<spring:message code="edit"/>)')
                                .attr("href", savedQuestionId)
                                .attr("type", "FEW_ANSWERS");
                            var container = $("#addedAnswersContainer");
                            container.removeAttr("id");
                            var corrects = [];
                            $("input[type='checkbox']:checked").each(function () {
                                corrects.push($(this).val());
                            });
                            $("input[name*='answer']").each(function () {
                                if ($.inArray($(this).attr("name"), corrects) !== -1) {
                                    container.append('<div class="col-lg-8">\n' +
                                        '                 <div class="correct"></div>\n' +
                                        '             </div>');
                                    container.find(".correct").last().text($(this).val());
                                } else {
                                    container.append('<div class="col-lg-8">\n' +
                                        '                 <div class="incorrect"></div>\n' +
                                        '             </div>');
                                    container.find(".incorrect").last().text($(this).val());
                                }
                            });
                            var explanation = $("#explanation").val();
                            if (explanation) {
                                container.append('<div><strong><spring:message code="questions.explanation"/>: </strong></div>');
                                container.find("div").last().append(document.createTextNode(explanation));
                            }
                            form.remove();
                            break;
                        case "ACCORDANCE":
                            form.after(baseQuestion);
                            var questionHeader = form.next();
                            questionHeader.find('a:contains(<spring:message code="delete"/>)').attr("href", savedQuestionId);
                            questionHeader.find("h5").text($("#question").val());
                            $('a[href=""][type=""]:contains(<spring:message code="edit"/>)')
                                .attr("href", savedQuestionId)
                                .attr("type", "ACCORDANCE");
                            $('a[href=""]:contains(<spring:message code="delete"/>)').attr("href", questionId);
                            var container = $("#addedAnswersContainer");
                            container.removeAttr("id");
                            var table = container
                                .removeAttr("id")
                                .prepend('<table class="col-lg-8 table-info"></table>')
                                .children(":first");
                            $("input[name*='left']").each(function () {
                                var counter = $(this).attr("name").replace("left", "");
                                table.append('<tr>\n' +
                                    '                <td style="width: 50%"></td>' +
                                    '                <td style="width: 50%"></td>' +
                                    '             </tr>');
                                table.find("td").last().text($("input[name='right" + counter + "']").val())
                                    .prev().text($(this).val());
                                // table.find("tr").last().children().first().text($(this).val())
                                //     .next().text();
                            });
                            var explanation = $("#explanation").val();
                            if (explanation) {
                                container.append('<div><strong><spring:message code="questions.explanation"/>: </strong></div>');
                                container.find("div").last().append(document.createTextNode(explanation));
                            }
                            form.remove();
                            break;
                        case "SEQUENCE":
                            form.after(baseQuestion);
                            var questionHeader = form.next();
                            questionHeader.find('a:contains(<spring:message code="delete"/>)').attr("href", savedQuestionId);
                            questionHeader.find("h5").text($("#question").val());
                            $('a[href=""][type=""]:contains(<spring:message code="edit"/>)')
                                .attr("href", savedQuestionId)
                                .attr("type", "SEQUENCE");
                            $('a[href=""]:contains(<spring:message code="delete"/>)').attr("href", questionId);
                            var container = $("#addedAnswersContainer");
                            container.removeAttr("id");
                            var table = container
                                .removeAttr("id")
                                .prepend('<table class="col-lg-8 table-info"></table>')
                                .children(":first");
                            var counter = 1;
                            $("input[name*='sequence']").each(function () {
                                table.append('<tr>\n' +
                                    '                <td style="width: 10%">' + counter + '</td>' +
                                    '                <td style="width: 90%"></td>' +
                                    '             </tr>');
                                table.find("td").last().text($(this).val());
                                counter++;
                            });
                            var explanation = $("#explanation").val();
                            if (explanation) {
                                container.append('<div><strong><spring:message code="questions.explanation"/>: </strong></div>');
                                container.find("div").last().append(document.createTextNode(explanation));
                            }
                            form.remove();
                            break;
                        case "NUMBER":
                            form.after(baseQuestion);
                            var questionHeader = form.next();
                            questionHeader.find('a:contains(<spring:message code="delete"/>)').attr("href", savedQuestionId);
                            questionHeader.find("h5").text($("#question").val());
                            $('a[href=""][type=""]:contains(<spring:message code="edit"/>)')
                                .attr("href", savedQuestionId)
                                .attr("type", "NUMBER");
                            $('a[href=""]:contains(<spring:message code="delete"/>)').attr("href", questionId);
                            var container = $("#addedAnswersContainer");
                            container.removeAttr("id")
                                .prepend(
                                    '                <table class="col-lg-8 table-info">\n' +
                                    '                    <tr>\n' +
                                    '                        <td style="width: 50%"><spring:message code="questions.number.answer"/></td>\n' +
                                    '                        <td style="width: 50%">' + $("#number").val() + '</td>\n' +
                                    '                    </tr>\n' +
                                    '                </table>');
                            var explanation = $("#explanation").val();
                            if (explanation) {
                                container.append('<div><strong><spring:message code="questions.explanation"/>: </strong></div>');
                                container.find("div").last().append(document.createTextNode(explanation));
                            }
                            form.remove();
                            break;
                    }
                }
            });
        });

        var baseEditQuestionForm =
            '   <form id="questionForm" action="/teacher/quizzes/' + window.location.pathname.split("/")[3] + '/questions/update" method="post">\n' +
            '        <div class="question-header">\n' +
            '            <div class="row no gutters">\n' +
            '                <div class="col-lg-8">\n' +
            '                    <div class="form-group form-inline">\n' +
            '                        <label for="type" class="col-sm-4">\n' +
            '                            <strong><spring:message code="questions.type"/></strong>\n' +
            '                        </label>\n' +
            '                        <select id="type" name="type" class="col-sm-4 form-control" disabled>\n' +
            '                            <option value="ONE_ANSWER"><spring:message code="questions.one.answer"/></option>\n' +
            '                            <option value="FEW_ANSWERS"><spring:message code="questions.few.answer"/></option>\n' +
            '                            <option value="ACCORDANCE"><spring:message code="questions.accordance"/></option>\n' +
            '                            <option value="SEQUENCE"><spring:message code="questions.sequence"/></option>\n' +
            '                            <option value="NUMBER"><spring:message code="questions.numerical"/></option>\n' +
            '                        </select>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '                <div class="col-lg-4">\n' +
            '                    <div class="form-group form-inline">\n' +
            '                        <label for="points" class="col-sm-4 col-form-label">\n' +
            '                            <strong><spring:message code="questions.question.points"/></strong>\n' +
            '                        </label>\n' +
            '                        <input type="text" id="points" name="points" class="col-sm-5 form-control" placeholder="<spring:message code="questions.question.points"/>">\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </div>\n' +
            '            <div class="form-group">\n' +
            '                <label for="question" class="col-form-label">\n' +
            '                    <strong><spring:message code="questions.question"/></strong>\n' +
            '                </label>\n' +
            '                <textarea name="question" id="question" rows="2" class="col-lg-11 form-control"\n' +
            '                          placeholder="<spring:message code="questions.question"/>"></textarea>\n' +
            '            </div>\n' +
            '        </div>' +
            '        <div class="question-answers">\n' +
            '            <h5 id="answersHeader"><spring:message code="questions.answers"/></h5>\n' +
            '            <span id="answersContainer">' +
            '            </span>\n' +
            '        <div class="row">\n' +
            '                <div class="col-lg-9">\n' +
            '                    <div class="form-group">\n' +
            '                        <label for="explanation" class="col-form-label">\n' +
            '                            <strong><spring:message code="questions.explanation"/></strong>\n' +
            '                        </label>\n' +
            '                        <textarea name="explanation" id="explanation" rows="2" class="form-control"\n' +
            '                                  placeholder="<spring:message code="questions.explanation"/>"></textarea>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '                <div class="col-lg-3">\n' +
            '                    <span id="buttonMarker"></span>' +
            '                    <button id="addAnswer" type="button" class="btn btn-success btn-wide" value="oneAnswer">\n' +
            '                        <i class="fa fa-plus"></i> <spring:message code="questions.answer.add"/>\n' +
            '                    </button>\n' +
            '                </div>\n' +
            '            </div>\n' +
            '            <div class="text-center">\n' +
            '                <button id="cancel" type="button" class="btn btn-primary btn-wide"><spring:message code="cancel"/></button>\n' +
            '                <button id="save" type="submit" class="btn btn-success" value=""><spring:message code="save"/></button>\n' +
            '            </div>\n' +
            '        </div>\n' +
            '    </form>';

        var answerNumber = '<div class="form-group form-inline">\n' +
            '                <label for="number">\n' +
            '                    <strong><spring:message code="questions.number"/></strong>\n' +
            '                </label>\n' +
            '                <div class="col">\n' +
            '                    <input type="text" class="form-control" id="number" name="number">\n' +
            '                </div>\n' +
            '            </div>';

        $(document).on("click", 'a:contains(<spring:message code="delete"/>)', function (event) {
            event.preventDefault();

            var quizId = window.location.pathname.split("/")[3];
            var deleteButton = $(this);

            $.ajax({
                type: "POST",
                url: "/teacher/quizzes/" + quizId + "/questions/delete",
                data: "questionId=" + deleteButton.attr("href"),
                error: () => {
                    console.log("status:" + status + "\nresponse message: " +
                        xhr.responseText + "\nerror: " + error);
                    alert('<spring:message code="ajax.error"/>');
                },
                success: function () {
                    var header = deleteButton.closest(".question-header");
                    var answers = header.next();
                    header.remove();
                    answers.remove();

                    if ($('a:contains(<spring:message code="delete"/>)').length === 0) {
                        $("#pageHeader").replaceWith(
                            '<div id="noQuestionsInfo" class="row no-gutters align-items-center highlight-primary">\n' +
                            '    <div class="col-auto mr-3">\n' +
                            '        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                            '             width="25" height="25">\n' +
                            '    </div>\n' +
                            '    <div class="col">\n' +
                            '         <spring:message code="questions.not.exist"/> \'<c:out value="${quiz.name}"/>\'\n' +
                            '    </div>\n' +
                            '</div>');

                        $("h4.shifted-left").remove();
                    }
                }
            });
        });

        $(document).on("click", 'a:contains(<spring:message code="edit"/>)', function (event) {
            event.preventDefault();

            var form = $("#questionForm");
            if (form.length !== 0) {
                if (oldHeader && oldAnswers) {
                    form.after(oldHeader);
                    oldHeader.after(oldAnswers);
                }
                form.remove();
            }

            var header = $(this).closest(".question-header");
            var answers = header.next();
            var questionType = $(this).attr("type");

            answers.after(baseEditQuestionForm);
            $("#cancel").val("editingQuestion");
            $("#type").val(questionType);
            $("#points").val(header.find("h6").text().replace(' <spring:message code="questions.points"/>', ''));
            $("#question").val(header.find("h5").text());

            switch (questionType) {
                case "ONE_ANSWER":
                    var container = $("#answersContainer");
                    var counter = 0;
                    answers.find("[class*=correct]").each(function () {
                        var answer =
                            '<div id="' + counter + '" class="row no-gutters margin-row">\n' +
                            '    <div class="col-auto mx-sm-3">\n' +
                            '        <div class="custom-control custom-radio shifted-down">\n' +
                            '            <input type="radio" id="status' + counter + '" name="correct" value="answer' + counter + '"\n' +
                            '                 class="custom-control-input">\n' +
                            '            <label for="status' + counter + '" class="custom-control-label"></label>\n' +
                            '        </div>\n' +
                            '    </div>\n' +
                            '    <div class="col col-sm-8 mr-sm-4">\n' +
                            '        <input type="text" id="answer' + counter + '" name="answer' + counter + '"\n' +
                            '               class="form-control is-invalid">\n' +
                            '    </div>\n';
                        if (counter > 1) {
                            answer +=
                                '    <div class="col-auto">\n' +
                                '        <button type="button" class="answer-delete" value="' + counter + '"><i\n' +
                                '              class="fa fa-close"></i></button>\n' +
                                '    </div>\n';
                        }
                        answer += '</div>\n';
                        container.append(answer);
                        var currentAnswer = container.find(":text").last();
                        if ($(this).attr("class") === "correct") {
                            container.find(":radio").last().prop("checked", true);
                            currentAnswer.removeClass("is-invalid").addClass("is-valid");
                        }
                        currentAnswer.val($(this).text());
                        counter++;
                    });
                    break;
                case "FEW_ANSWERS":
                    $("#addAnswer").val("fewAnswers");
                    var container = $("#answersContainer");
                    var counter = 0;
                    answers.find("[class*=correct]").each(function () {
                        var answer =
                            '<div id="' + counter + '" class="row no-gutters margin-row">\n' +
                            '    <div class="col-auto mx-sm-3">\n' +
                            '        <div class="custom-control custom-checkbox shifted-down">\n' +
                            '            <input type="checkbox" id="status' + counter + '"\n ' +
                            '                name="correct' + counter + '" value="answer' + counter + '"\n' +
                            '                class="custom-control-input">\n' +
                            '            <label for="status' + counter + '" class="custom-control-label"></label>\n' +
                            '        </div>\n' +
                            '     </div>\n' +
                            '     <div class="col col-sm-8 mr-sm-4">\n' +
                            '         <input type="text" id="answer' + counter + '" name="answer' + counter + '"\n ' +
                            '             class="form-control is-invalid">\n' +
                            '     </div>\n';
                        if (counter > 1) {
                            answer +=
                                '    <div class="col-auto">\n' +
                                '        <button type="button" class="answer-delete" value="' + counter + '"><i\n' +
                                '              class="fa fa-close"></i></button>\n' +
                                '    </div>\n';
                        }
                        answer += '</div>\n';
                        container.append(answer);
                        var currentAnswer = container.find(":text").last();
                        if ($(this).attr("class") === "correct") {
                            container.find(":checkbox").last().prop("checked", true);
                            currentAnswer.removeClass("is-invalid").addClass("is-valid");
                        }
                        currentAnswer.val($(this).text());
                        counter++;
                    });
                    break;
                case "ACCORDANCE":
                    $("#addAnswer").remove();
                    var container = $("#answersContainer");
                    container.append('<div class="row">\n' +
                        '                <div class="col-6">\n' +
                        '                    <strong><spring:message code="questions.accordance.left.side"/></strong>\n' +
                        '                </div>\n' +
                        '                <div class="col-6">\n' +
                        '                    <strong><spring:message code="questions.accordance.right.side"/></strong>\n' +
                        '                </div>\n' +
                        '            </div>\n');
                    var counter = 0;
                    answers.find("td:first-child").each(function () {
                        container.append(
                            '<div class="row margin-row">\n' +
                            '    <div class="col-6">\n' +
                            '        <input type="text" class="form-control" name="left' + counter + '">\n' +
                            '    </div>\n' +
                            '    <div class="col-6">\n' +
                            '        <input type="text" class="form-control" name="right' + counter + '">\n' +
                            '    </div>\n' +
                            '</div>\n');
                        container.find("input[name='left" + counter + "']").val($(this).text());
                        counter++;
                    });
                    counter = 0;
                    answers.find("td:last-child").each(function () {
                        container.find("input[name='right" + counter + "']").val($(this).text());
                        counter++;
                    });
                    break;
                case "SEQUENCE":
                    $("#addAnswer").remove();
                    var container = $("#answersContainer");
                    container.append('<div><strong><spring:message code="questions.sequence"/></strong></div>\n');
                    var counter = 0;
                    answers.find("td:last-child").each(function () {
                        container.append(
                            '<div class="row margin-row">\n' +
                            '    <div class="col-auto">\n' + (counter + 1) + '.' + '</div>\n' +
                            '    <div class="col-lg-8">\n' +
                            '         <input type="text" class="form-control"\n' +
                            '                name="sequence' + counter + '">\n' +
                            '     </div>\n' +
                            '</div>\n');
                        container.find("input[type='text']").last().val($(this).text());
                        counter++;
                    });
                    break;
                case "NUMBER":
                    $("#addAnswer").remove();
                    $("#answersContainer").append(answerNumber);
                    $("#number").val(answers.find("td").last().text());
                    break;
            }
            $("#explanation").val(answers.find('strong:contains(<spring:message code="questions.explanation"/>)')
                .parent().text().replace('<spring:message code="questions.explanation"/>: ', '').trim());
            $("#save").val($(this).attr("href"));
            oldHeader = header.detach();
            oldAnswers = answers.detach();
        });

        $(document).on("click", "#cancel", function () {
            var form = $("#questionForm");
            if ($(this).val() === "editingQuestion") {
                form.after(oldHeader);
                oldHeader.after(oldAnswers);
            }
            form.remove();
        });

        var oneAnswers = '<c:forEach begin="0" end="2" varStatus="status">\n' +
            '                <div id="${status.index}" class="row no-gutters margin-row">\n' +
            '                    <div class="col-auto mx-sm-3">\n' +
            '                        <div class="custom-control custom-radio shifted-down">\n' +
            '                            <input type="radio" id="status${status.index}" name="correct" value="answer${status.index}"\n' +
            '                                   class="custom-control-input">\n' +
            '                            <label for="status${status.index}" class="custom-control-label"></label>\n' +
            '                        </div>\n' +
            '                    </div>\n' +
            '                    <div class="col col-sm-8 mr-sm-4">\n' +
            '                        <input type="text" id="answer${status.index}" name="answer${status.index}"\n' +
            '                               class="form-control is-invalid">\n' +
            '                    </div>\n' +
            '                    <c:if test="${status.index eq 2}">\n' +
            '                        <div class="col-auto">\n' +
            '                            <button type="button" class="answer-delete" value="${status.index}"><i\n' +
            '                                    class="fa fa-close"></i></button>\n' +
            '                        </div>\n' +
            '                    </c:if>\n' +
            '                </div>\n' +
            '            </c:forEach>\n';

        var fewAnswers = '<c:forEach begin="0" end="2" varStatus="status">\n' +
            '                <div id="${status.index}" class="row no-gutters margin-row">\n' +
            '                    <div class="col-auto mx-sm-3">\n' +
            '                        <div class="custom-control custom-checkbox shifted-down">\n' +
            '                            <input type="checkbox" id="status${status.index}"\n ' +
            '                                   name="correct${status.index}" value="answer${status.index}"\n' +
            '                                   class="custom-control-input">\n' +
            '                            <label for="status${status.index}" class="custom-control-label"></label>\n' +
            '                        </div>\n' +
            '                    </div>\n' +
            '                    <div class="col col-sm-8 mr-sm-4">\n' +
            '                        <input type="text" id="answer${status.index}" name="answer${status.index}"\n ' +
            '                               class="form-control is-invalid">\n' +
            '                    </div>\n' +
            '                    <c:if test="${status.index eq 2}">\n' +
            '                        <div class="col-auto">\n' +
            '                            <button type="button" class="answer-delete"><i class="fa fa-close"></i></button>\n' +
            '                        </div>\n' +
            '                    </c:if>\n' +
            '                </div>\n' +
            '            </c:forEach>\n';

        var accordanceAnswers = '<div class="row">\n' +
            '                <div class="col-6">\n' +
            '                    <strong><spring:message code="questions.accordance.left.side"/></strong>\n' +
            '                </div>\n' +
            '                <div class="col-6">\n' +
            '                    <strong><spring:message code="questions.accordance.right.side"/></strong>\n' +
            '                </div>\n' +
            '            </div>\n' +
            '            <c:forEach begin="0" end="3" varStatus="status">\n' +
            '                <div class="row margin-row">\n' +
            '                    <div class="col-6">\n' +
            '                        <input type="text" class="form-control" name="left${status.index}">\n' +
            '                    </div>\n' +
            '                    <div class="col-6">\n' +
            '                        <input type="text" class="form-control" name="right${status.index}">\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </c:forEach>\n';

        var sequenceAnswers = '<div><strong><spring:message code="questions.sequence"/></strong></div>\n' +
            '            <c:forEach begin="0" end="3" varStatus="status">\n' +
            '                <div class="row margin-row">\n' +
            '                    <div class="col-auto">\n' +
            '                            ${status.index + 1}.\n' +
            '                    </div>\n' +
            '                    <div class="col-lg-8">\n' +
            '                        <input type="text" class="form-control" name="sequence${status.index}">\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </c:forEach>';

        var numberAnswers = '<div class="form-group form-inline">\n' +
            '                <label for="number">\n' +
            '                    <strong><spring:message code="questions.number"/></strong>\n' +
            '                </label>\n' +
            '                <div class="col">\n' +
            '                    <input type="text" class="form-control" id="number" name="number">\n' +
            '                </div>\n' +
            '            </div>\n';

        $("#addQuestion").click(function () {

            var form = $("#questionForm");
            if (form.length !== 0) {
                form.after(oldHeader);
                oldHeader.after(oldAnswers);
                form.remove();
            }
            var url = "/teacher/quizzes/" + window.location.pathname.split("/")[3] + "/questions/update";
            $("#pageHeaderRow").after(baseEditQuestionForm);
            $("#questionForm").attr("action", url);
            $("#type").prop("disabled", false);
            $("#answersContainer").append(oneAnswers);
        });

        $(document).on("change", "#type", function () {
            var answersContainer = $("#answersContainer");
            answersContainer.empty();
            var questionType = $(this).val();
            switch (questionType) {
                case "ONE_ANSWER":
                    answersContainer.append(oneAnswers);
                    var addAnswerButton = $("#addAnswer");
                    if (addAnswerButton.length === 0) {
                        $("#buttonMarker").after(
                            '<button id="addAnswer" type="button" class="btn btn-success btn-wide" value="oneAnswer">\n' +
                            '    <i class="fa fa-plus"></i> <spring:message code="questions.answer.add"/>\n' +
                            '</button>\n');
                    }
                    $("#addAnswer").val("oneAnswer");
                    break;
                case "FEW_ANSWERS":
                    answersContainer.append(fewAnswers);
                    var addAnswerButton = $("#addAnswer");
                    if (addAnswerButton.length === 0) {
                        $("#buttonMarker").after(
                            '<button id="addAnswer" type="button" class="btn btn-success btn-wide" value="oneAnswer">\n' +
                            '    <i class="fa fa-plus"></i> <spring:message code="questions.answer.add"/>\n' +
                            '</button>\n');
                    }
                    $("#addAnswer").val("fewAnswers");
                    break;
                case "ACCORDANCE":
                    answersContainer.append(accordanceAnswers);
                    $("#addAnswer").remove();
                    break;
                case "SEQUENCE":
                    answersContainer.append(sequenceAnswers);
                    $("#addAnswer").remove();
                    break;
                case "NUMBER":
                    answersContainer.append(numberAnswers);
                    $("#addAnswer").remove();
                    break;
            }
        });
    });
</script>
</body>
</html>
