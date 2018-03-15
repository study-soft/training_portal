<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:import url="navbar.jsp"/>
<h2>Questions</h2>
<c:if test="${not empty questionsOneAnswer}">
    <h3>Questions with one correct answer</h3>
    <c:forEach items="${questionsOneAnswer}" var="question">
        <div><h4 style="display: inline">${question.body}</h4> ${question.score} points</div>
        <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
            <form>
                <c:choose>
                    <c:when test="${answer.correct eq true}">
                        <input type="checkbox" checked disabled>${answer.body}
                    </c:when>
                    <c:otherwise>
                        <input type="checkbox" disabled>${answer.body}
                    </c:otherwise>
                </c:choose>
            </form>
        </c:forEach>
        <div>${question.explanation}</div>
    </c:forEach>
</c:if>
<c:if test="${not empty questionsFewAnswers}">
    <h3>Questions with few correct answers</h3>
    <c:forEach items="${questionsFewAnswers}" var="question">
        <div><h4 style="display: inline">${question.body}</h4> ${question.score} points</div>
        <c:forEach items="${quizAnswersSimple[question.questionId]}" var="answer">
            <form>
                <c:choose>
                    <c:when test="${answer.correct eq true}">
                        <input type="checkbox" checked disabled>${answer.body}
                    </c:when>
                    <c:otherwise>
                        <input type="checkbox" disabled>${answer.body}
                    </c:otherwise>
                </c:choose>
            </form>
        </c:forEach>
        <div>${question.explanation}</div>
    </c:forEach>
</c:if>
<c:if test="${not empty questionsAccordance}">
    <h3>Accordance questions</h3>
    <c:forEach items="${questionsAccordance}" var="question">
        <div><h4 style="display: inline">${question.body}</h4> ${question.score} points</div>
        <c:set var="leftSide" value="${quizAnswersAccordance[question.questionId].leftSide}" scope="page"/>
        <c:set var="rightSide" value="${quizAnswersAccordance[question.questionId].rightSide}" scope="page"/>
        <c:forEach items="${leftSide}" var="item" varStatus="status">
            <div>${item} -> ${rightSide[status.index]}</div>
        </c:forEach>
        <div>${question.explanation}</div>
    </c:forEach>
</c:if>
<c:if test="${not empty questionsSequence}">
    <h3>Sequence questions</h3>
    <c:forEach items="${questionsSequence}" var="question">
        <div><h4 style="display: inline">${question.body}</h4> ${question.score} points</div>
        <c:set var="correctList" value="${quizAnswersSequence[question.questionId].correctList}" scope="page"/>
        <c:forEach items="${correctList}" var="item" varStatus="status">
            <div>${status.index}. ${item}</div>
        </c:forEach>
        <div>${question.explanation}</div>
    </c:forEach>
</c:if>
<c:if test="${not empty questionsNumber}">
    <h3>Questions with numerical answers</h3>
    <c:forEach items="${questionsNumber}" var="question">
        <div><h4 style="display: inline">${question.body}</h4> ${question.score} points</div>
        <div>Answer: ${quizAnswersNumber[question.questionId].correct}</div>
    </c:forEach>
</c:if>
<a href="/student/quizzes/${questionsNumber[0].quizId}">Back</a>
</body>
</html>
