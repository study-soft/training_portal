<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="../../../resources/main.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>
<ul>
    <li><a href="/student">Home</a></li>
    <li><a href="/student/quizzes">Quizzes</a></li>
    <li><a href="/student/teachers">Teachers</a></li>
    <li><a href="/student/results">Results</a></li>
    <c:if test="${studentId ne null}">
        <li style="float: right;">
            <form action="/logout" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <input type="submit" value="Logout">
            </form>
        </li>
    </c:if>
</ul>
<script>
    $('ul > li > a[href="' + window.location.pathname + '"]').parent().addClass('active');
</script>
</body>
</html>
