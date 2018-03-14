<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Questions</title>
</head>
<body>
<h2>Questions</h2>
<h3>Questions with one correct answer</h3>
<c:forEach items="${questionsOneAnswer}" var="question">
    <div><h4>${question.name}. ${question.body}</h4> ${question.score} points</div>
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
<h3>Questions with few correct answers</h3>
<c:forEach items="${questionsFewAnswers}" var="question">
    <div><h4>${question.name}. ${question.body}</h4> ${question.score} points</div>
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
<h3>Accordance questions</h3>
<c:forEach items="${questionsAccordance}" var="question">
    <div><h4>${question.name}. ${question.body}</h4> ${question.score} points</div>
    <c:set var="correctMap" value="${quizAnswersAccordance[question.questionId].correctMap}" scope="page"/>
    <c:forEach items="${correctMap}" var="entry">
        <div>${entry.key} -> ${entry.value}</div>
    </c:forEach>
    <div>${question.explanation}</div>
</c:forEach>
<h3>Sequence questions</h3>
<c:forEach items="${questionsSequence}" var="question">
    <div><h4>${question.name}. ${question.body}</h4> ${question.score} points</div>
    <c:set var="correctList" value="${quizAnswersSequence[question.questionId].correctList}" scope="page"/>
    <c:set var="index" value="1" scope="page"/>
    <c:forEach items="${correctList}" var="item">
        <div>${index}. ${item}</div>
        <c:set var="index" value="${index + 1}"/>
    </c:forEach>
    <div>${question.explanation}</div>
</c:forEach>
<h3>Questions with numerical answers</h3>
<c:forEach items="${questionsNumber}" var="question">
    <div><h4>${question.name}. ${question.body}</h4> ${question.score} points</div>
    <div>Answer: ${quizAnswersNumber[question.questionId].correct}</div>
</c:forEach>
</body>
</html>
