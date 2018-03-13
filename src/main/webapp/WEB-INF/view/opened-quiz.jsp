<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 3/12/2018
  Time: 3:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Opened quiz</title>
</head>
<body>
<h2>Opened quiz</h2>
<h3>${openedQuiz.quizName}</h3>
<div>Submitted: ${openedQuiz.submitDate}</div>
<div>${openedQuiz.description}</div>
<div>Passing time: ${openedQuiz.passingTime}</div>
<div>Score: ${openedQuiz.score}</div>
<div>Questions: ${openedQuiz.questionsNumber}</div>
<div>Author: ${openedQuiz.authorName}</div>
<div>
    <a href="#">Start </a><a href="#"> Back</a>
</div>
</body>
</html>
