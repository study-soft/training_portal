<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.question"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const currentQuestion = +"${sessionScope.currentQuestionSerial}";
            const questionsNumber = +"${sessionScope.questionsNumber}";
            const finish = $("#finish");
            if (currentQuestion === (questionsNumber - 1)) {
                const submit = $("#submit");
                submit.val("Finish");
                submit.removeClass("btn btn-success").addClass("btn btn-primary");
                finish.remove();
            }

            finish.click(function (event) {
                window.scrollTo(0, 0);
                event.preventDefault();
                $(".modal-body").html('<spring:message code="quiz.passing.sure.finish"/>?' +
                    '<br><spring:message code="quiz.passing.answered.only"/> ' + currentQuestion + ' / ' +
                    questionsNumber + ' <spring:message code="quiz.passing.answered.questions"/>');
                $("#modal").modal();
            });

            $("#questionForm").submit(function () {
                $("option").each(function () {
                    const answer = $(this).text().replace('"', '\"');
                    $(this).val(answer);
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <c:set var="question" value="${sessionScope.questions[sessionScope.currentQuestionSerial]}" scope="page"/>
    <h2><c:out value="${sessionScope.currentQuiz.name}"/></h2>
    <form id="questionForm" action="/quizzes/${question.quizId}/passing" method="post">
        <div class="row mb-2">
            <div class="col-sm-8">
                <spring:message code="quiz.passing.question"/>&nbsp;
                ${sessionScope.currentQuestionSerial + 1}&nbsp;
                <spring:message code="quiz.passing.of"/>&nbsp;${sessionScope.questionsNumber}
            </div>
            <div class="col-sm-4">
                <c:if test="${sessionScope.timeLeft ne null}">
                    <spring:message code="quiz.passing.time.left"/>:&nbsp;
                    <duration:format value="${sessionScope.timeLeft}"/>
                </c:if>
            </div>
        </div>
        <div class="question-header">
            <div class="row">
                <div class="col-sm-8">
                    <h5><c:out value="${question.body}"/></h5>
                </div>
                <div class="col-sm-4">
                    <h6>${question.score} <spring:message code="quiz.passing.points"/></h6>
                </div>
            </div>
        </div>
        <c:choose>
            <%--***************************   ONE ANSWER   *********************************--%>
            <c:when test="${question.questionType eq 'ONE_ANSWER'}">
                <div class="question-answers">
                    <c:forEach items="${answers}" var="answer">
                        <div class="custom-control custom-radio">
                            <input type="radio" id="answer${answer.answerSimpleId}"
                                   name="oneAnswer" value="${answer.correct}" class="custom-control-input">
                            <label for="answer${answer.answerSimpleId}" class="custom-control-label">
                                <c:out value="${answer.body}"/>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <%--****************************   FEW ANSWERS   *********************************--%>
            <c:when test="${question.questionType eq 'FEW_ANSWERS'}">
                <div class="question-answers">
                    <c:forEach items="${answers}" var="answer" varStatus="status">
                        <div class="custom-control custom-checkbox">
                            <input type="checkbox" id="answer${answer.answerSimpleId}" class="custom-control-input"
                                   name="fewAnswer${status.index}" value="${answer.correct}">
                            <label for="answer${answer.answerSimpleId}" class="custom-control-label">
                                <c:out value="${answer.body}"/>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <%--*****************************   ACCORDANCE   ***********************************--%>
            <c:when test="${question.questionType eq 'ACCORDANCE'}">
                <div class="question-answers">
                    <c:forEach items="${answers.leftSide}" var="left" varStatus="status">
                        <div class="row">
                            <div class="col-md-4"><c:out value="${left}"/></div>
                            <div class="col-md-4">
                                <select name="accordance${status.index}" class="form-control">
                                    <option selected><spring:message code="quiz.passing.select"/>...</option>
                                    <c:forEach items="${answers.rightSide}" var="right">
                                        <option value=""><c:out value="${right}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <%--**********************************   SEQUENCE   *****************************--%>
            <c:when test="${question.questionType eq 'SEQUENCE'}">
                <div class="question-answers">
                    <c:forEach begin="0" end="3" varStatus="status">
                        <div class="row">
                            <div class="col-auto">${status.index + 1}.</div>
                            <div class="col-md-4">
                                <select name="sequence${status.index}" id="sequence${status.index}"
                                        class="form-control">
                                    <option selected><spring:message code="quiz.passing.select"/>...</option>
                                    <c:forEach items="${answers.correctList}" var="item">
                                        <option value=""><c:out value="${item}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <%--************************************   NUMBER   *************************************--%>
            <c:when test="${question.questionType eq 'NUMBER'}">
                <div class="question-answers">
                    <div class="col-sm-4">
                        <input type="text" name="number" class="form-control" style="margin-left: -10px"
                               placeholder="<spring:message code="quiz.passing.enter.number"/>">
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <strong class="error">OOPS, UNEXPECTED ERROR</strong>
            </c:otherwise>
        </c:choose>
        <div class="row">
            <div class="col-sm-8">
                <input id="submit" type="submit" value="<spring:message code="quiz.passing.next"/>"
                       class="btn btn-success">
            </div>
            <div class="col-sm-4">
                <input type="submit" id="finish" value="<spring:message code="quiz.passing.finish"/>"
                       class="btn btn-danger btn-wide" formaction="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations"/>
            </div>
        </div>
    </form>
</div>
<br>
<div class="modal fade" id="modal" tabindex="-1" role="dialog"
     aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalLabel"><spring:message code="attention"/></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <form id="congratulationsForm" method="post"
                      action="/quizzes/${sessionScope.currentQuiz.quizId}/congratulations">
                    <button type="button" class="btn btn-secondary"  data-dismiss="modal">
                        <spring:message code="no"/>
                    </button>
                    <input type="submit" id="yes" class="btn btn-primary" value="<spring:message code="yes"/>">
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
