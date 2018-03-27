<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <form action="#" method="post">
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
            <h5>Answers</h5>
            <c:forEach begin="0" end="2" varStatus="status">
                <div id="${status.index}" class="row margin-row">
                    <div class="col-auto">
                        <div class="custom-control custom-radio shifted-down">
                            <input type="radio" id="correct${status.index}" name="answer" value="correct" class="custom-control-input">
                            <label for="correct${status.index}" class="custom-control-label"></label>
                        </div>
                    </div>
                    <div class="col-9">
                        <input type="text" id="answer${status.index}" class="form-control is-invalid">
                    </div>
                    <c:if test="${status.index eq 2}">
                        <div class="col-1">
                            <button type="button" class="answer-delete" value="${status.index}"><i class="fa fa-close"></i></button>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
            <script>
                $(document).ready(function () {

                    var row = '<div id="new-row" class="row margin-row">\n' +
                        '                <div class="col-auto">\n' +
                        '                    <div class="custom-control custom-radio shifted-down">\n' +
                        '                        <input type="radio" id="correct2" name="answer" value="correct" class="custom-control-input">\n' +
                        '                        <label for="correct2" class="custom-control-label"></label>\n' +
                        '                    </div>\n' +
                        '                </div>\n' +
                        '                <div class="col-9">\n' +
                        '                    <input type="text" class="form-control">\n' +
                        '                </div>\n' +
                        '                <div class="col-1">\n' +
                        '                    <button type="button" class="answer-delete"><i class="fa fa-close"></i></button>\n' +
                        '                </div>\n' +
                        '            </div>';

                    $("#addAnswer").click(function () {
                        var lastRow = $(".margin-row:last");
                        var counter = lastRow.attr("id") + 1;
                        lastRow.after(row);
                        var newRow = $("#new-row");
                        newRow.find("input[type='radio']").attr("id", "correct" + counter)
                            .next().attr("for", "correct" + counter);
                        newRow.find("input[type='text']")
                            .attr("id", "answer" + counter)
                            .addClass("is-invalid");
                        newRow.find(".answer-delete").val(counter);
                        newRow.attr("id", counter);
                    });

                    $(document).on("click", ".answer-delete", function () {
                        var id = $(this).val();
                        $("#" + id).remove();
                    });

                    $(document).on("change", "input[type=radio][name=answer]", function () {
                        $("input[type='text'].is-valid").removeClass("is-valid").addClass("is-invalid");
                        var rowNumber = $(this).attr("id").replace("correct", "");
                        $("#answer" + rowNumber).removeClass("is-invalid").addClass("is-valid");
                    });
                });
            </script>
            <%--*********************************************--%>
            <div class="row">
                <div class="col-xl-9 col-lg-8 col-md-6">
                    <div class="form-group">
                        <label for="question" class="col-form-label">
                            <strong>Explanation</strong>
                        </label>
                        <textarea name="explanation" id="explanation" rows="2" class="form-control"
                                  placeholder="Explanation"></textarea>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <button id="addAnswer" type="button" class="btn btn-success" style="width: 140px">
                        <i class="fa fa-plus"></i> Add answer</button>
                </div>
            </div>
            <div class="text-center">
                <button class="btn btn-primary">Cancel</button>
                <button class="btn btn-success">Save</button>
            </div>
        </div>
    </form>

    <h2>Answers for quiz '${quiz.name}'</h2>
    <c:if test="${not empty questionsOneAnswer}">
        <h4 class="shifted-left">Questions with one correct answer</h4>
        <c:forEach items="${questionsOneAnswer}" var="question">
            <div class="question-header">
                <div class="row">
                    <div class="col-8">
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
                    <div class="col-8">
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
                    <div class="col-8">
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
                    <div class="col-8">
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
                    <div class="col-8">
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
