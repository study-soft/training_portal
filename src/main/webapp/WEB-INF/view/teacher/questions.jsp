<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        <%--// question one answer--%>
        $(document).ready(function () {
            var rowOneAnswer = '<div id="new-row" class="row margin-row">\n' +
                '                <div class="col-auto">\n' +
                '                    <div class="custom-control custom-radio shifted-down">\n' +
                '                        <input type="radio" id="" name="correct" value="" class="custom-control-input">\n' +
                '                        <label for="correct2" class="custom-control-label"></label>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '                <div class="col-9">\n' +
                '                    <input type="text" class="form-control" name="">\n' +
                '                </div>\n' +
                '                <div class="col-1">\n' +
                '                    <button type="button" class="answer-delete"><i class="fa fa-close"></i></button>\n' +
                '                </div>\n' +
                '            </div>';

            var rowFewAnswers = '<div id="new-row" class="row margin-row">\n' +
                '                <div class="col-auto">\n' +
                '                    <div class="custom-control custom-checkbox shifted-down">\n' +
                '                        <input type="checkbox" id="" name="" value="correct" class="custom-control-input">\n' +
                '                        <label for="" class="custom-control-label"></label>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '                <div class="col-9">\n' +
                '                    <input type="text" class="form-control">\n' +
                '                </div>\n' +
                '                <div class="col-1">\n' +
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
                    // $(this).val("correct");
                } else {
                    answer.removeClass("is-valid").addClass("is-invalid");
                    // $(this).val("incorrect");
                }
                // $(":checkbox").each(function () {
                //     alert($(this).val());
                // });
            });

            $(document).on("submit", "#questionForm", function (event) {
                event.preventDefault();
                var form = $("#questionForm");
                var data = form.serialize();
                $.ajax({
                    type: form.attr("method"),
                    url: form.attr("action"),
                    data: form.serialize(),
                    success: function(data) {
                        alert("success: " + data);
                    }
                });
                alert(form.serialize());
            });

            var oneAnswers = '<c:forEach begin="0" end="2" varStatus="status">\n' +
                '                <div id="${status.index}" class="row margin-row">\n' +
                '                    <div class="col-auto">\n' +
                '                        <div class="custom-control custom-radio shifted-down">\n' +
                '                            <input type="radio" id="status${status.index}" name="answer" value="incorrect"\n' +
                '                                   class="custom-control-input">\n' +
                '                            <label for="status${status.index}" class="custom-control-label"></label>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                    <div class="col-9">\n' +
                '                        <input type="text" id="answer${status.index}" class="form-control is-invalid">\n' +
                '                    </div>\n' +
                '                    <c:if test="${status.index eq 2}">\n' +
                '                        <div class="col-1">\n' +
                '                            <button type="button" class="answer-delete" value="${status.index}"><i\n' +
                '                                    class="fa fa-close"></i></button>\n' +
                '                        </div>\n' +
                '                    </c:if>\n' +
                '                </div>\n' +
                '            </c:forEach>\n' +
                '                <div class="row">\n' +
                '                <div class="col-xl-9 col-lg-8 col-md-6">\n' +
                '                    <div class="form-group">\n' +
                '                        <label for="explanation" class="col-form-label">\n' +
                '                            <strong>Explanation</strong>\n' +
                '                        </label>\n' +
                '                        <textarea name="explanation" id="explanation" rows="2" class="form-control"\n' +
                '                                  placeholder="Explanation"></textarea>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '                <div class="col-xl-3 col-lg-4 col-md-6">\n' +
                '                    <button id="addAnswer" type="button" class="btn btn-success" style="width: 140px"\n' +
                '                            value="oneAnswer">\n' +
                '                        <i class="fa fa-plus"></i> Add answer\n' +
                '                    </button>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="text-center">\n' +
                '                <button type="button" class="btn btn-primary">Cancel</button>\n' +
                '                <button type="submit" class="btn btn-success">Save</button>\n' +
                '            </div>';

            var fewAnswers = '<c:forEach begin="0" end="2" varStatus="status">\n' +
                '                <div id="${status.index}" class="row margin-row">\n' +
                '                    <div class="col-auto">\n' +
                '                        <div class="custom-control custom-checkbox shifted-down">\n' +
                '                            <input type="checkbox" id="status${status.index}"\n ' +
                '                                   name="correct${status.index}" value="answer${status.index}"\n' +
                '                                   class="custom-control-input">\n' +
                '                            <label for="status${status.index}" class="custom-control-label"></label>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                    <div class="col-9">\n' +
                '                        <input type="text" id="answer${status.index}" name="answer${status.index}"\n ' +
                '                               class="form-control is-invalid">\n' +
                '                    </div>\n' +
                '                    <c:if test="${status.index eq 2}">\n' +
                '                        <div class="col-1">\n' +
                '                            <button type="button" class="answer-delete"><i class="fa fa-close"></i></button>\n' +
                '                        </div>\n' +
                '                    </c:if>\n' +
                '                </div>\n' +
                '            </c:forEach>\n' +
                '                <div class="row">\n' +
                '                <div class="col-xl-9 col-lg-8 col-md-6">\n' +
                '                    <div class="form-group">\n' +
                '                        <label for="explanation" class="col-form-label">\n' +
                '                            <strong>Explanation</strong>\n' +
                '                        </label>\n' +
                '                        <textarea name="explanation" id="explanation" rows="2" class="form-control"\n' +
                '                                  placeholder="Explanation"></textarea>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '                <div class="col-xl-3 col-lg-4 col-md-6">\n' +
                '                    <button id="addAnswer" type="button" class="btn btn-success" style="width: 140px"\n' +
                '                            value="fewAnswers">\n' +
                '                        <i class="fa fa-plus"></i> Add answer\n' +
                '                    </button>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="text-center">\n' +
                '                <button type="button" class="btn btn-primary">Cancel</button>\n' +
                '                <button type="submit" class="btn btn-success">Save</button>\n' +
                '            </div>';

            var accordanceAnswers = '<div class="row">\n' +
                '                <div class="col-6">\n' +
                '                    <strong>Left side</strong>\n' +
                '                </div>\n' +
                '                <div class="col-6">\n' +
                '                    <strong>Right side</strong>\n' +
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
                '            </c:forEach>\n' +
                '                <div class="row">\n' +
                '                <div class="col-xl-9 col-lg-8 col-md-6">\n' +
                '                    <div class="form-group">\n' +
                '                        <label for="explanation" class="col-form-label">\n' +
                '                            <strong>Explanation</strong>\n' +
                '                        </label>\n' +
                '                        <textarea name="explanation" id="explanation" rows="2" class="form-control"\n' +
                '                                  placeholder="Explanation"></textarea>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="text-center">\n' +
                '                <button type="button" class="btn btn-primary">Cancel</button>\n' +
                '                <button type="submit" class="btn btn-success">Save</button>\n' +
                '            </div>';

            var sequenceAnswers = '<div><strong>Sequence</strong></div>\n' +
                '            <c:forEach begin="0" end="3" varStatus="status">\n' +
                '                <div class="row margin-row">\n' +
                '                    <div class="col-auto">\n' +
                '                            ${status.index + 1}.\n' +
                '                    </div>\n' +
                '                    <div class="col-6">\n' +
                '                        <input type="text" class="form-control" name="sequence${status.index}">\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '            </c:forEach>' +
                '                <div class="row">\n' +
                '                <div class="col-xl-9 col-lg-8 col-md-6">\n' +
                '                    <div class="form-group">\n' +
                '                        <label for="explanation" class="col-form-label">\n' +
                '                            <strong>Explanation</strong>\n' +
                '                        </label>\n' +
                '                        <textarea name="explanation" id="explanation" rows="2" class="form-control"\n' +
                '                                  placeholder="Explanation"></textarea>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="text-center">\n' +
                '                <button type="button" class="btn btn-primary">Cancel</button>\n' +
                '                <button type="submit" class="btn btn-success">Save</button>\n' +
                '            </div>';

            var numberAnswers = '<div class="form-group form-inline">\n' +
                '                <label for="number">\n' +
                '                    <strong>Number</strong>\n' +
                '                </label>\n' +
                '                <div class="col">\n' +
                '                    <input type="text" class="form-control" id="number" name="number">\n' +
                '                </div>\n' +
                '            </div>' +
                '                <div class="row">\n' +
                '                <div class="col-xl-9 col-lg-8 col-md-6">\n' +
                '                    <div class="form-group">\n' +
                '                        <label for="explanation" class="col-form-label">\n' +
                '                            <strong>Explanation</strong>\n' +
                '                        </label>\n' +
                '                        <textarea name="explanation" id="explanation" rows="2" class="form-control"\n' +
                '                                  placeholder="Explanation"></textarea>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="text-center">\n' +
                '                <button type="button" class="btn btn-primary">Cancel</button>\n' +
                '                <button type="submit" class="btn btn-success">Save</button>\n' +
                '            </div>';

            $("#type").on("change", function () {
                var answersContainer = $("#answersContainer");
                answersContainer.empty();
                var type = $(this).val();
                switch (type) {
                    case "oneAnswer":
                        answersContainer.append(oneAnswers);
                        break;
                    case "fewAnswers":
                        answersContainer.append(fewAnswers);
                        break;
                    case "accordance":
                        answersContainer.append(accordanceAnswers);
                        break;
                    case "sequence":
                        answersContainer.append(sequenceAnswers);
                        break;
                    case "number":
                        answersContainer.append(numberAnswers);
                        break;
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <form id="questionForm" action="/teacher/quizzes/${quiz.quizId}/questions/update" method="post">
        <div class="question-header">
            <div class="row">
                <div class="col-8">
                    <div class="form-group form-inline">
                        <label for="type" class="col-xl-3 col-lg-4 col-md-6 col-form-label">
                            <strong>Select type</strong>
                        </label>
                        <select id="type" name="type" class="col-4 form-control">
                            <option value="oneAnswer">One answer</option>
                            <option value="fewAnswers">Few answers</option>
                            <option value="accordance">Accordance</option>
                            <option value="sequence">Sequence</option>
                            <option value="number">Numerical</option>
                        </select>
                    </div>
                </div>
                <div class="col-4">
                    <div class="form-group form-inline">
                        <label for="points" class="col-3 col-form-label">
                            <strong>Points</strong>
                        </label>
                        <input type="text" id="points" name="points" class="col-6 form-control" placeholder="Points">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="question" class="col-form-label">
                    <strong>Question</strong>
                </label>
                <textarea name="question" id="question" rows="2" class="col-11 form-control"
                          placeholder="Question"></textarea>
            </div>
        </div>
        <%--*********************     One answer     **********************--%>
        <div class="question-answers">
            <h5 id="answersHeader">Answers</h5>
            <span id="answersContainer">
            <c:forEach begin="0" end="2" varStatus="status">
                <div id="${status.index}" class="row margin-row">
                    <div class="col-auto">
                        <div class="custom-control custom-radio shifted-down">
                            <input type="radio" id="status${status.index}" name="correct" value="answer${status.index}"
                                   class="custom-control-input">
                            <label for="status${status.index}" class="custom-control-label"></label>
                        </div>
                    </div>
                    <div class="col-9">
                        <input type="text" id="answer${status.index}" name="answer${status.index}" class="form-control is-invalid">
                    </div>
                    <c:if test="${status.index eq 2}">
                        <div class="col-1">
                            <button type="button" class="answer-delete" value="${status.index}"><i
                                    class="fa fa-close"></i></button>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
            <%--********************************************************--%>
            <%--*********************     Few answers     **************--%>
            <%--<c:forEach begin="0" end="2" varStatus="status">--%>
                <%--<div id="${status.index}" class="row margin-row">--%>
                    <%--<div class="col-auto">--%>
                        <%--<div class="custom-control custom-checkbox shifted-down">--%>
                            <%--<input type="checkbox" id="status${status.index}" value="incorrect"--%>
                                   <%--class="custom-control-input">--%>
                            <%--<label for="status${status.index}" class="custom-control-label"></label>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                    <%--<div class="col-9">--%>
                        <%--<input type="text" id="answer${status.index}" class="form-control is-invalid">--%>
                    <%--</div>--%>
                    <%--<c:if test="${status.index eq 2}">--%>
                        <%--<div class="col-1">--%>
                            <%--<button type="button" class="answer-delete"><i class="fa fa-close"></i></button>--%>
                        <%--</div>--%>
                    <%--</c:if>--%>
                <%--</div>--%>
            <%--</c:forEach>--%>
            <%--*******************************************************--%>
            <%--*********************     Accordance     **************--%>
            <%--<div class="row">--%>
                <%--<div class="col-6">--%>
                    <%--<strong>Left side</strong>--%>
                <%--</div>--%>
                <%--<div class="col-6">--%>
                    <%--<strong>Right side</strong>--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--<c:forEach begin="0" end="3" varStatus="status">--%>
                <%--<div class="row margin-row">--%>
                    <%--<div class="col-6">--%>
                        <%--<input type="text" class="form-control" name="left${status.index}">--%>
                    <%--</div>--%>
                    <%--<div class="col-6">--%>
                        <%--<input type="text" class="form-control" name="right${status.index}">--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</c:forEach>--%>
            <%--*******************************************************--%>
            <%--*********************     Sequence     ****************--%>
            <%--<div><strong>Sequence</strong></div>--%>
            <%--<c:forEach begin="0" end="3" varStatus="status">--%>
                <%--<div class="row margin-row">--%>
                    <%--<div class="col-auto">--%>
                            <%--${status.index + 1}.--%>
                    <%--</div>--%>
                    <%--<div class="col-6">--%>
                        <%--<input type="text" class="form-control" name="sequence${status.index}">--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</c:forEach>--%>
            <%--*******************************************************--%>
            <%--*********************     Number     ******************--%>
            <%--<div class="form-group form-inline">--%>
                <%--<label for="number">--%>
                    <%--<strong>Number</strong>--%>
                <%--</label>--%>
                <%--<div class="col">--%>
                    <%--<input type="text" class="form-control" id="number" name="number">--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--*******************************************************--%>
            <div class="row">
                <div class="col-xl-9 col-lg-8 col-md-6">
                    <div class="form-group">
                        <label for="explanation" class="col-form-label">
                            <strong>Explanation</strong>
                        </label>
                        <textarea name="explanation" id="explanation" rows="2" class="form-control"
                                  placeholder="Explanation"></textarea>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <button id="addAnswer" type="button" class="btn btn-success" style="width: 140px"
                            value="oneAnswer">
                        <i class="fa fa-plus"></i> Add answer
                    </button>
                </div>
            </div>
            <div class="text-center">
                <button type="button" class="btn btn-primary">Cancel</button>
                <button type="submit" class="btn btn-success">Save</button>
            </div>
            </span>
        </div>
    </form>

    <h2>Answers for quiz '${quiz.name}'</h2>
    <c:if test="${not empty questionsOneAnswer}">
        <h4 class="shifted-left">Questions with one correct answer</h4>
        <c:forEach items="${questionsOneAnswer}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-7">
                        <h5>${question.body}</h5>
                    </div>
                    <div class="col-2">
                        <h6>${question.score} points</h6>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-trash-o"></i> Delete</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
                    <c:choose>
                        <c:when test="${answer.correct eq true}">
                            <div class="col-6">
                                <div class="correct">${answer.body}</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="col-6">
                                <div class="incorrect">${answer.body}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <div><strong> Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsFewAnswers}">
        <h4 class="shifted-left">Questions with few correct answers</h4>
        <c:forEach items="${questionsFewAnswers}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-7">
                        <h5>${question.body}</h5>
                    </div>
                    <div class="col-2">
                        <h6>${question.score} points</h6>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-trash-o"></i> Delete</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
                    <c:choose>
                        <c:when test="${answer.correct eq true}">
                            <div class="col-6">
                                <div class="correct">${answer.body}</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="col-6">
                                <div class="incorrect">${answer.body}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <div><strong> Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsAccordance}">
        <h4 class="shifted-left">Accordance questions</h4>
        <c:forEach items="${questionsAccordance}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-7">
                        <h5>${question.body}</h5>
                    </div>
                    <div class="col-2">
                        <h6>${question.score} points</h6>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-trash-o"></i> Delete</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:set var="leftSide" value="${quizAnswersAccordance[question.questionId].leftSide}" scope="page"/>
                <c:set var="rightSide" value="${quizAnswersAccordance[question.questionId].rightSide}" scope="page"/>
                <table class="col-6 table-info">
                    <c:forEach items="${leftSide}" var="item" varStatus="status">
                        <tr>
                            <td>${item}</td>
                            <td>${rightSide[status.index]}</td>
                        </tr>
                    </c:forEach>
                </table>
                <div><strong> Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsSequence}">
        <h4 class="shifted-left">Sequence questions</h4>
        <c:forEach items="${questionsSequence}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-7">
                        <h5>${question.body}</h5>
                    </div>
                    <div class="col-2">
                        <h6>${question.score} points</h6>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-trash-o"></i> Delete</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <c:set var="correctList" value="${quizAnswersSequence[question.questionId].correctList}" scope="page"/>
                <table class="col-6 table-info">
                    <c:forEach items="${correctList}" var="item" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>${item}</td>
                        </tr>
                    </c:forEach>
                </table>
                <div><strong> Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsNumber}">
        <h4 class="shifted-left">Questions with numerical answers</h4>
        <c:forEach items="${questionsNumber}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-7">
                        <h5>${question.body}</h5>
                    </div>
                    <div class="col-2">
                        <h6>${question.score} points</h6>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down">
                            <a href="#"><i class="fa fa-trash-o"></i> Delete</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="question-answers">
                <table class="col-6 table-info">
                    <tr>
                        <td>Answer</td>
                        <td>${quizAnswersNumber[question.questionId].correct}</td>
                    </tr>
                </table>
                <div><strong> Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
