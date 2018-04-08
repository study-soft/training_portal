<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        var oldHeader;
        var oldAnswers;
        <%--// question one answer--%>
        $(document).ready(function () {
            var rowOneAnswer = '<div id="new-row" class="row margin-row">\n' +
                '                <div class="col-auto">\n' +
                '                    <div class="custom-control custom-radio shifted-down-10px">\n' +
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
                '                    <div class="custom-control custom-checkbox shifted-down-10px">\n' +
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
                    points.after('<div class="error">Cannot be empty</div>');
                    validationSuccess = false;
                } else if (!points.val().match(/[0-9]+/)) {
                    points.after('<div class="error">Only digits allowed</div>')
                    validationSuccess = false;
                } else if (points.val().length > 9) {
                    points.after('<div class="error">Length must be less than 10 characters</div>')
                    validationSuccess = false;
                }

                var question = $("#question");
                if (!question.val()) {
                    question.after('<div class="error">Cannot be empty</div>');
                    validationSuccess = false;
                } else if (question.val().match(/[<>]+/)) {
                    question.after('<div class="error">Cannot contain "<" or ">"</div>');
                    validationSuccess = false;
                }

                var explanation = $("#explanation");
                if (explanation.val().match(/[<>]+/)) {
                    explanation.after('<div class="error">Cannot contain "<" or ">"</div>');
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
                            alert("select correct answer");
                            validationSuccess = false;
                        }
                        break;
                    case "FEW_ANSWERS":
                        $("input[name*='answer']").each(function () {
                            validateAnswer($(this));
                        });
                        var countOfCorrect = $("input[type='checkbox']:checked").length;
                        if (countOfCorrect === 0) {
                            alert("select correct answer");
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
                            number.after('<div class="error">Cannot be empty</div>');
                            validationSuccess = false;
                        } else if (!number.val().match(/[0-9]+/)) {
                            number.after('<div class="error">Only digits allowed</div>');
                            validationSuccess = false;
                        } else if (number.val().length > 9) {
                            number.after('<div class="error">Length must be less than 10 characters</div>')
                            validationSuccess = false;
                        }
                        break;
                }

                function validateAnswer(answer) {
                    if (!answer.val()) {
                        answer.after('<div class="error">Cannot be empty</div>');
                        validationSuccess = false;
                    } else if (answer.val().match(/[<>]+/)) {
                        answer.after('<div class="error">Cannot contain "<" or ">"</div>');
                        validationSuccess = false;
                    }
                }

                if (!validationSuccess) {
                    return;
                }

                var baseQuestion = '<div class="question-header">\n' +
                    '                <div class="row">\n' +
                    '                    <div class="col-7">\n' +
                    '                        <h5>' + $("#question").val() + '</h5>\n' +
                    '                    </div>\n' +
                    '                    <div class="col-2">\n' +
                    '                        <h6>' + $("#points").val() + ' points</h6>\n' +
                    '                    </div>\n' +
                    '                    <div class="col-auto">\n' +
                    '                        <div class="shifted-down-10px">\n' +
                    '                            <a href="" type=""><i class="fa fa-edit"></i> Edit</a>\n' +
                    '                        </div>\n' +
                    '                    </div>\n' +
                    '                    <div class="col-auto">\n' +
                    '                        <div class="shifted-down-10px">\n' +
                    '                            <a href=""><i class="fa fa-trash-o"></i> Delete</a>\n' +
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
                alert(data);
                $.ajax({
                    type: form.attr("method"),
                    url: form.attr("action"),
                    data: data,
                    error: function(xhr, status, error) {
                        console.log("status:" + status + "\nresponse message: " +
                            xhr.responseText + "\nerror: " + error);
                        alert("Some error. See in console");
                    },
                    success: function () {
                        alert("success");
                        switch (questionType) {
                            case "ONE_ANSWER":
                                form.after(baseQuestion);
                                $("a[href=''][type='']:contains(Edit)")
                                    .attr("href", questionId)
                                    .attr("type", "ONE_ANSWER");
                                var correct = $("input[type=radio][name='correct']:checked").val();
                                var container = $("#addedAnswersContainer");
                                container.removeAttr("id");
                                $("input[name*='answer']").each(function () {
                                    if ($(this).attr("name") === correct) {
                                        container.append('<div class="col-6">\n' +
                                            '                 <div class="correct">' + $(this).val() + '</div>\n' +
                                            '             </div>');
                                    } else {
                                        container.append('<div class="col-6">\n' +
                                            '                 <div class="incorrect">' + $(this).val() + '</div>\n' +
                                            '             </div>');
                                    }
                                });
                                var explanation = $("#explanation").val();
                                if (explanation) {
                                    container.append('<div><strong> Explanation: </strong>' +
                                        explanation + '</div>');
                                }
                                form.remove();
                                break;
                            case "FEW_ANSWERS":
                                form.after(baseQuestion);
                                $("a[href=''][type='']:contains(Edit)")
                                    .attr("href", questionId)
                                    .attr("type", "FEW_ANSWERS");
                                var container = $("#addedAnswersContainer");
                                container.removeAttr("id");
                                var corrects = [];
                                $("input[type='checkbox']:checked").each(function () {
                                    corrects.push($(this).val());
                                });
                                $("input[name*='answer']").each(function () {
                                    if ($.inArray($(this).attr("name"), corrects) !== -1) {
                                        container.append('<div class="col-6">\n' +
                                            '                 <div class="correct">' + $(this).val() + '</div>\n' +
                                            '             </div>');
                                    } else {
                                        container.append('<div class="col-6">\n' +
                                            '                 <div class="incorrect">' + $(this).val() + '</div>\n' +
                                            '             </div>');
                                    }
                                });
                                var explanation = $("#explanation").val();
                                if (explanation) {
                                    container.append('<div><strong> Explanation: </strong>' +
                                        explanation + '</div>');
                                }
                                form.remove();
                                break;
                            case "ACCORDANCE":
                                form.after(baseQuestion);
                                $("a[href=''][type='']:contains(Edit)")
                                    .attr("href", questionId)
                                    .attr("type", "ACCORDANCE");
                                $("a[href='']:contains(Delete)").attr("href", questionId);
                                var container = $("#addedAnswersContainer");
                                container.removeAttr("id");
                                var table = container
                                    .removeAttr("id")
                                    .prepend('<table class="col-6 table-info"></table>')
                                    .children(":first");
                                $("input[name*='left']").each(function () {
                                    var counter = $(this).attr("name").replace("left", "");
                                    table.append('<tr>\n' +
                                        '                <td>' + $(this).val() + '</td>' +
                                        '                <td>' + $("input[name='right" + counter + "']").val() + '</td>' +
                                        '             </tr>');
                                });
                                var explanation = $("#explanation").val();
                                if (explanation) {
                                    container.append('<div><strong> Explanation: </strong>' +
                                        explanation + '</div>');
                                }
                                form.remove();
                                break;
                            case "SEQUENCE":
                                form.after(baseQuestion);
                                $("a[href=''][type='']:contains(Edit)")
                                    .attr("href", questionId)
                                    .attr("type", "SEQUENCE");
                                $("a[href='']:contains(Delete)").attr("href", questionId);
                                var container = $("#addedAnswersContainer");
                                container.removeAttr("id");
                                var table = container
                                    .removeAttr("id")
                                    .prepend('<table class="col-6 table-info"></table>')
                                    .children(":first");
                                var counter = 1;
                                $("input[name*='sequence']").each(function () {
                                    table.append('<tr>\n' +
                                        '                <td>' + counter + '</td>' +
                                        '                <td>' + $(this).val() + '</td>' +
                                        '             </tr>');
                                    counter++;
                                });
                                var explanation = $("#explanation").val();
                                if (explanation) {
                                    container.append('<div><strong>Explanation: </strong>' +
                                        explanation + '</div>');
                                }
                                form.remove();
                                break;
                            case "NUMBER":
                                form.after(baseQuestion);
                                $("a[href=''][type='']:contains(Edit)")
                                    .attr("href", questionId)
                                    .attr("type", "NUMBER");
                                $("a[href='']:contains(Delete)").attr("href", questionId);
                                var container = $("#addedAnswersContainer");
                                container.removeAttr("id")
                                    .prepend(
                                        '                <table class="col-6 table-info">\n' +
                                        '                    <tr>\n' +
                                        '                        <td>Answer</td>\n' +
                                        '                        <td>' + $("#number").val() + '</td>\n' +
                                        '                    </tr>\n' +
                                        '                </table>');
                                var explanation = $("#explanation").val();
                                if (explanation) {
                                    container.append('<div><strong>Explanation: </strong>' + explanation + '</div>');
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
                '            <div class="row">\n' +
                '                <div class="col-8">\n' +
                '                    <div class="form-group form-inline">\n' +
                '                        <label for="type" class="col-xl-3 col-lg-4 col-md-6 col-form-label">\n' +
                '                            <strong>Type</strong>\n' +
                '                        </label>\n' +
                '                        <select id="type" name="type" class="col-4 form-control" disabled>\n' +
                '                            <option value="ONE_ANSWER">One answer</option>\n' +
                '                            <option value="FEW_ANSWERS">Few answers</option>\n' +
                '                            <option value="ACCORDANCE">Accordance</option>\n' +
                '                            <option value="SEQUENCE">Sequence</option>\n' +
                '                            <option value="NUMBER">Numerical</option>\n' +
                '                        </select>\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '                <div class="col-4">\n' +
                '                    <div class="form-group form-inline">\n' +
                '                        <label for="points" class="col-3 col-form-label">\n' +
                '                            <strong>Points</strong>\n' +
                '                        </label>\n' +
                '                        <input type="text" id="points" name="points" class="col-6 form-control" placeholder="Points">\n' +
                '                    </div>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="form-group">\n' +
                '                <label for="question" class="col-form-label">\n' +
                '                    <strong>Question</strong>\n' +
                '                </label>\n' +
                '                <textarea name="question" id="question" rows="2" class="col-11 form-control"\n' +
                '                          placeholder="Question"></textarea>\n' +
                '            </div>\n' +
                '        </div>' +
                '        <div class="question-answers">\n' +
                '            <h5 id="answersHeader">Answers</h5>\n' +
                '            <span id="answersContainer">' +
                '            </span>\n' +
                '        <div class="row">\n' +
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
                '                    <button id="addAnswer" type="button" class="btn btn-success btn-wide" value="oneAnswer">\n' +
                '                        <i class="fa fa-plus"></i> Add answer\n' +
                '                    </button>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '            <div class="text-center">\n' +
                '                <button id="cancel" type="button" class="btn btn-primary">Cancel</button>\n' +
                '                <button id="save" type="submit" class="btn btn-success" value="">Save</button>\n' +
                '            </div>\n' +
                '        </div>\n' +
                '    </form>';

            var answerNumber = '<div class="form-group form-inline">\n' +
                '                <label for="number">\n' +
                '                    <strong>Number</strong>\n' +
                '                </label>\n' +
                '                <div class="col">\n' +
                '                    <input type="text" class="form-control" id="number" name="number">\n' +
                '                </div>\n' +
                '            </div>';

            $(document).on("click", "a:contains(Delete)", function (event) {
                event.preventDefault();

                var quizId = window.location.pathname.split("/")[3];

                $.ajax({
                    type: "POST",
                    url: "/teacher/quizzes/" + quizId + "/questions/delete",
                    data: "questionId=" + $(this).attr("href")
                });

                var header = $(this).closest(".question-header");
                var answers = header.next();
                header.remove();
                answers.remove();
            });

            $(document).on("click", "a:contains(Edit)", function (event) {
                event.preventDefault();

                var form = $("#questionForm");
                if (form.length !== 0) {
                    form.after(oldHeader);
                    oldHeader.after(oldAnswers);
                    form.remove();
                }

                var header = $(this).closest(".question-header");
                var answers = header.next();
                var questionType = $(this).attr("type");

                answers.after(baseEditQuestionForm);
                $("#cancel").val("editingQuestion");
                $("#type").val(questionType);
                $("#points").val(header.find("h6").text().replace(" points", ""));
                $("#question").val(header.find("h5").text());

                switch (questionType) {
                    case "ONE_ANSWER":
                        var container = $("#answersContainer");
                        var counter = 0;
                        answers.find("[class*=correct]").each(function () {
                            var answer =
                                '<div id="' + counter + '" class="row margin-row">\n' +
                                '    <div class="col-auto">\n' +
                                '        <div class="custom-control custom-radio shifted-down">\n' +
                                '            <input type="radio" id="status' + counter + '" name="correct" value="answer' + counter + '"\n' +
                                '                 class="custom-control-input">\n' +
                                '            <label for="status' + counter + '" class="custom-control-label"></label>\n' +
                                '        </div>\n' +
                                '    </div>\n' +
                                '    <div class="col-9">\n' +
                                '        <input type="text" id="answer' + counter + '" name="answer' + counter + '"\n' +
                                '               class="form-control is-invalid">\n' +
                                '    </div>\n';
                            if (counter > 1) {
                                answer +=
                                    '    <div class="col-1">\n' +
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
                                '<div id="' + counter + '" class="row margin-row">\n' +
                                '    <div class="col-auto">\n' +
                                '        <div class="custom-control custom-checkbox shifted-down">\n' +
                                '            <input type="checkbox" id="status' + counter + '"\n ' +
                                '                name="correct' + counter + '" value="answer' + counter + '"\n' +
                                '                class="custom-control-input">\n' +
                                '            <label for="status' + counter + '" class="custom-control-label"></label>\n' +
                                '        </div>\n' +
                                '     </div>\n' +
                                '     <div class="col-9">\n' +
                                '         <input type="text" id="answer' + counter + '" name="answer' + counter + '"\n ' +
                                '             class="form-control is-invalid">\n' +
                                '     </div>\n';
                            if (counter > 1) {
                                answer +=
                                    '    <div class="col-1">\n' +
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
                            '                    <strong>Left side</strong>\n' +
                            '                </div>\n' +
                            '                <div class="col-6">\n' +
                            '                    <strong>Right side</strong>\n' +
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
                        container.append('<div><strong>Sequence</strong></div>\n');
                        var counter = 0;
                        answers.find("td:last-child").each(function () {
                            container.append(
                                '<div class="row margin-row">\n' +
                                '    <div class="col-auto">\n' + (counter + 1) + '.' + '</div>\n' +
                                '    <div class="col-6">\n' +
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
                $("#explanation").val(answers.find("strong:contains(Explanation)")
                    .parent().text().replace("Explanation: ", ""));
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
                '                <div id="${status.index}" class="row margin-row">\n' +
                '                    <div class="col-auto">\n' +
                '                        <div class="custom-control custom-radio shifted-down">\n' +
                '                            <input type="radio" id="status${status.index}" name="correct" value="answer${status.index}"\n' +
                '                                   class="custom-control-input">\n' +
                '                            <label for="status${status.index}" class="custom-control-label"></label>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                    <div class="col-9">\n' +
                '                        <input type="text" id="answer${status.index}" name="answer${status.index}"\n' +
                '                               class="form-control is-invalid">\n' +
                '                    </div>\n' +
                '                    <c:if test="${status.index eq 2}">\n' +
                '                        <div class="col-1">\n' +
                '                            <button type="button" class="answer-delete" value="${status.index}"><i\n' +
                '                                    class="fa fa-close"></i></button>\n' +
                '                        </div>\n' +
                '                    </c:if>\n' +
                '                </div>\n' +
                '            </c:forEach>\n';

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
                '            </c:forEach>\n';

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
                '            </c:forEach>\n';

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
                '            </c:forEach>';

            var numberAnswers = '<div class="form-group form-inline">\n' +
                '                <label for="number">\n' +
                '                    <strong>Number</strong>\n' +
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
                        break;
                    case "FEW_ANSWERS":
                        answersContainer.append(fewAnswers);
                        break;
                    case "ACCORDANCE":
                        answersContainer.append(accordanceAnswers);
                        break;
                    case "SEQUENCE":
                        answersContainer.append(sequenceAnswers);
                        break;
                    case "NUMBER":
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
    <%--<form id="questionForm" action="/teacher/quizzes/${quiz.quizId}/questions/update" method="post">--%>
    <%--<div class="question-header">--%>
    <%--<div class="row">--%>
    <%--<div class="col-8">--%>
    <%--<div class="form-group form-inline">--%>
    <%--<label for="type" class="col-xl-3 col-lg-4 col-md-6 col-form-label">--%>
    <%--<strong>Select type</strong>--%>
    <%--</label>--%>
    <%--<select id="type" name="type" class="col-4 form-control">--%>
    <%--<option value="ONE_ANSWER">One answer</option>--%>
    <%--<option value="FEW_ANSWERS">Few answers</option>--%>
    <%--<option value="ACCORDANCE">Accordance</option>--%>
    <%--<option value="SEQUENCE">Sequence</option>--%>
    <%--<option value="NUMBER">Numerical</option>--%>
    <%--</select>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="col-4">--%>
    <%--<div class="form-group form-inline">--%>
    <%--<label for="points" class="col-3 col-form-label">--%>
    <%--<strong>Points</strong>--%>
    <%--</label>--%>
    <%--<input type="text" id="points" name="points" class="col-6 form-control" placeholder="Points">--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="form-group">--%>
    <%--<label for="question" class="col-form-label">--%>
    <%--<strong>Question</strong>--%>
    <%--</label>--%>
    <%--<textarea name="question" id="question" rows="2" class="col-11 form-control"--%>
    <%--placeholder="Question"></textarea>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--&lt;%&ndash;*********************     One answer     **********************&ndash;%&gt;--%>
    <%--<div class="question-answers">--%>
    <%--<h5 id="answersHeader">Answers</h5>--%>
    <%--<span id="answersContainer">--%>
    <%--<c:forEach begin="0" end="2" varStatus="status">--%>
    <%--<div id="${status.index}" class="row margin-row">--%>
    <%--<div class="col-auto">--%>
    <%--<div class="custom-control custom-radio shifted-down-10px">--%>
    <%--<input type="radio" id="status${status.index}" name="correct" value="answer${status.index}"--%>
    <%--class="custom-control-input">--%>
    <%--<label for="status${status.index}" class="custom-control-label"></label>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="col-9">--%>
    <%--<input type="text" id="answer${status.index}" name="answer${status.index}"--%>
    <%--class="form-control is-invalid">--%>
    <%--</div>--%>
    <%--<c:if test="${status.index eq 2}">--%>
    <%--<div class="col-1">--%>
    <%--<button type="button" class="answer-delete" value="${status.index}"><i--%>
    <%--class="fa fa-close"></i></button>--%>
    <%--</div>--%>
    <%--</c:if>--%>
    <%--</div>--%>
    <%--</c:forEach>--%>
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
    <%--<div class="row">--%>
    <%--<div class="col-xl-9 col-lg-8 col-md-6">--%>
    <%--<div class="form-group">--%>
    <%--<label for="explanation" class="col-form-label">--%>
    <%--<strong>Explanation</strong>--%>
    <%--</label>--%>
    <%--<textarea name="explanation" id="explanation" rows="2" class="form-control"--%>
    <%--placeholder="Explanation"></textarea>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="col-xl-3 col-lg-4 col-md-6">--%>
    <%--<button id="addAnswer" type="button" class="btn btn-success btn-wide" value="oneAnswer">--%>
    <%--<i class="fa fa-plus"></i> Add answer--%>
    <%--</button>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="text-center">--%>
    <%--<button type="button" class="btn btn-primary">Cancel</button>--%>
    <%--<button type="submit" class="btn btn-success">Save</button>--%>
    <%--</div>--%>
    <%--</span>--%>
    <%--</div>--%>
    <%--</form>--%>

    <div id="pageHeaderRow" class="row">
        <div class="col-6">
            <c:choose>
                <c:when test="${quiz.questionsNumber ne 0}">
                    <h2>Answers for quiz '${quiz.name}'</h2>
                </c:when>
                <c:otherwise>
                    <div class="row no-gutters align-items-center highlight-primary">
                        <div class="col-auto mr-3">
                            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                                 width="25" height="25">
                        </div>
                        <div class="col">
                            There is no questions in '${quiz.name}' quiz
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="col-4"></div>
        <div class="col-2 shifted-down-20px">
            <button id="addQuestion" type="button" class="btn btn-success btn-wide">
                <i class="fa fa-plus"></i>
                Add question
            </button>
        </div>
    </div>
    <c:if test="${not empty questionsOneAnswer}">
        <%--***********************     One answer questions     *****************************--%>
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
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="ONE_ANSWER"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}"><i class="fa fa-trash-o"></i> Delete</a>
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
                <div><strong>Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsFewAnswers}">
        <%--***********************     Few answers questions     *****************************--%>
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
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="FEW_ANSWERS"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}"><i class="fa fa-trash-o"></i> Delete</a>
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
                <div><strong>Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsAccordance}">
        <%--***********************     Accordance questions     *****************************--%>
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
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="ACCORDANCE"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}"><i class="fa fa-trash-o"></i> Delete</a>
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
                <div><strong>Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsSequence}">
        <%--***********************     Sequence questions     *****************************--%>
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
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="SEQUENCE"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}"><i class="fa fa-trash-o"></i> Delete</a>
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
                <div><strong>Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsNumber}">
        <%--***********************     Numerical questions     *****************************--%>
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
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}" type="NUMBER"><i class="fa fa-edit"></i> Edit</a>
                        </div>
                    </div>
                    <div class="col-auto">
                        <div class="shifted-down-10px">
                            <a href="${question.questionId}"><i class="fa fa-trash-o"></i> Delete</a>
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
                <div><strong>Explanation: </strong>${question.explanation}</div>
            </div>
        </c:forEach>
    </c:if>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
