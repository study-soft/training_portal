<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Answers</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Answers for quiz '${quiz.name}'</h2>
    <c:if test="${not empty questionsOneAnswer}">
        <h4>Questions with one correct answer</h4>
        <c:forEach items="${questionsOneAnswer}" var="question">
            <div class="row">
                <div class="col-8">
                    <h5>${question.body}</h5>
                </div>
                <div class="col-4">
                    <h6>${question.score} points</h6>
                </div>
            </div>
            <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
                <form>
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
                </form>
            </c:forEach>
            <div><strong> Explanation: </strong>${question.explanation}</div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsFewAnswers}">
        <h4>Questions with few correct answers</h4>
        <c:forEach items="${questionsFewAnswers}" var="question">
            <div class="row">
                <div class="col-8">
                    <h5>${question.body}</h5>
                </div>
                <div class="col-4">
                    <h6>${question.score} points</h6>
                </div>
            </div>
            <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
                <form>
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
                </form>
            </c:forEach>
            <div><strong> Explanation: </strong>${question.explanation}</div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsAccordance}">
        <h4>Compliance questions</h4>
        <c:forEach items="${questionsAccordance}" var="question">
            <div class="row">
                <div class="col-8">
                    <h5>${question.body}</h5>
                </div>
                <div class="col-4">
                    <h6>${question.score} points</h6>
                </div>
            </div>
            <c:set var="leftSide" value="${quizAnswersAccordance[question.questionId].leftSide}" scope="page"/>
            <c:set var="rightSide" value="${quizAnswersAccordance[question.questionId].rightSide}" scope="page"/>
            <table class="table-home col-6">
                <c:forEach items="${leftSide}" var="item" varStatus="status">
                    <tr>
                        <td class="table-home">${item}</td>
                        <td class="table-home">${rightSide[status.index]}</td>
                    </tr>
                </c:forEach>
            </table>
            <div><strong> Explanation: </strong>${question.explanation}</div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsSequence}">
        <h4>Consistency questions</h4>
        <c:forEach items="${questionsSequence}" var="question">
            <div class="row">
                <div class="col-8">
                    <h5>${question.body}</h5>
                </div>
                <div class="col-4">
                    <h6>${question.score} points</h6>
                </div>
            </div>
            <c:set var="correctList" value="${quizAnswersSequence[question.questionId].correctList}" scope="page"/>
            <table class="table-home col-6">
                <c:forEach items="${correctList}" var="item" varStatus="status">
                    <tr>
                        <td class="table-home">${status.index + 1}</td>
                        <td class="table-home">${item}</td>
                    </tr>
                </c:forEach>
            </table>
            <div><strong> Explanation: </strong>${question.explanation}</div>
        </c:forEach>
    </c:if>
    <c:if test="${not empty questionsNumber}">
        <h4>Questions with numerical answers</h4>
        <c:forEach items="${questionsNumber}" var="question">
            <div class="row">
                <div class="col-8">
                    <h5>${question.body}</h5>
                </div>
                <div class="col-4">
                    <h6>${question.score} points</h6>
                </div>
            </div>
            <table class="table-home col-6">
                <tr>
                    <td class="table-home">Answer</td>
                    <td class="table-home">${quizAnswersNumber[question.questionId].correct}</td>
                </tr>
            </table>
            <div><strong> Explanation: </strong>${question.explanation}</div>
        </c:forEach>
    </c:if>
    <button value="Back" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
