<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Question</title>
    <link type="text/css" rel="stylesheet" href="../../resources/main.css">
</head>
<body>
<c:set var="question" value="${sessionScope.questions[currentQuestion]}" scope="page"/>
<h3 style="display: inline">${question.name}. </h3><h4 style="display: inline">${question.body}</h4>
<form action="/student/quizzes/${question.quizId}/${currentQuestion + 1}" method="post">
    <c:choose>
        <c:when test="${question.questionType eq 'ONE_ANSWER'}">
            <c:forEach items="${answers}" var="answer">
                <div>
                    <input type="radio" id="answer${answer.answerSimpleId}"
                           name="oneAnswer" value="${answer.correct}">
                    <label for="answer${answer.answerSimpleId}"> ${answer.body}</label>
                </div>
            </c:forEach>
            <div>
                <input type="submit" value="Next">
            </div>
        </c:when>
        <c:when test="${question.questionType eq 'FEW_ANSWERS'}">
            <c:forEach items="${answers}" var="answer" varStatus="status">
                <div>
                    <input type="checkbox" id="answer${answer.answerSimpleId}"
                           name="fewAnswer${status.index}" value="${answer.correct}">
                    <label for="answer${answer.answerSimpleId}"> ${answer.body}</label>
                </div>
            </c:forEach>
            <div>
                <input type="submit" value="Next">
            </div>
        </c:when>
        <c:when test="${question.questionType eq 'ACCORDANCE'}">
            <c:forEach items="${answers.leftSide}" var="left" varStatus="status">
                <div>
                        ${left} <select name="accordance${status.index}">
                    <c:forEach items="${answers.rightSide}" var="right">
                        <option value="${right}">${right}</option>
                    </c:forEach>
                </select>
                </div>
            </c:forEach>
            <div>
                <input type="submit" value="Next">
            </div>
        </c:when>
        <c:when test="${question.questionType eq 'SEQUENCE'}">
            <div style="display: inline">
                <c:forEach begin="0" end="3" varStatus="status">
                    ${status.index + 1}. <select name="sequence${status.index}">
                    <c:forEach items="${answers.correctList}" var="item">
                        <option value="${item}">${item}</option>
                    </c:forEach>
                </select>
                </c:forEach>
            </div>
            <div>
                <input type="submit" value="Next">
            </div>
        </c:when>
        <c:when test="${question.questionType eq 'NUMBER'}">
            <div>
                <input type="text" name="number" placeholder="Enter number">
            </div>
            <div>
                <input type="submit" value="Next">
            </div>
        </c:when>
        <c:otherwise>
            <strong class="error">SOME ERROR</strong>
        </c:otherwise>
    </c:choose>
</form>
<div>${question.score} points</div>
</body>
</html>
