<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<ul class="nav">
    <li><a href="/teacher">Home</a></li>
    <li><a href="/teacher/quizzes">Quizzes</a></li>
    <li><a href="/teacher/groups">Groups</a></li>
    <li><a href="/teacher/students">Students</a></li>
    <li><a href="/student/results">Results</a></li>
    <c:if test="${teacherId ne null}">
        <li class="right">
                <%--<form action="/logout" method="post">--%>
                <%--<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">--%>
                <%--<input type="submit" value="Logout">--%>
                <%--</form>--%>
            <form action="/logout" method="post" id="logout">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <a onclick="document.getElementById('logout').submit();">Logout</a>
            </form>
        </li>
    </c:if>
</ul>
<script>
    $('ul > li > a[href="' + window.location.pathname + '"]').parent().addClass('active');
</script>
</body>
</html>
