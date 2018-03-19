<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <%--<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">--%>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <!-- Popper JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="script" href="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js">
</head>
<body>
<%--<div class="container-fluid">--%>
<%--<ul class="nav">--%>
<%--<li><a href="/teacher">Home</a></li>--%>
<%--<li><a href="/teacher/quizzes">Quizzes</a></li>--%>
<%--<li><a href="/teacher/groups">Groups</a></li>--%>
<%--<li><a href="/teacher/students">Students</a></li>--%>
<%--<li><a href="/student/results">Results</a></li>--%>
<%--<c:if test="${teacherId ne null}">--%>
<%--<li class="right">--%>
<%--<form action="/logout" method="post">--%>
<%--<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">--%>
<%--<input type="submit" value="Logout">--%>
<%--</form>--%>
<%--&lt;%&ndash;<form action="/logout" method="post" id="logout">&ndash;%&gt;--%>
<%--&lt;%&ndash;<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">&ndash;%&gt;--%>
<%--&lt;%&ndash;<a onclick="document.getElementById('logout').submit();">Logout</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;</form>&ndash;%&gt;--%>
<%--</li>--%>
<%--</c:if>--%>
<%--</ul>--%>
<%--</div>--%>

<%--<div class="container-fluid">--%>
<%--<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">--%>
<%--<li class="nav-item">--%>
<%--<a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home"--%>
<%--role="tab" aria-controls="pills-home" aria-selected="true">Home</a>--%>
<%--</li>--%>
<%--<li class="nav-item">--%>
<%--<a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile"--%>
<%--role="tab" aria-controls="pills-profile" aria-selected="false">Profile</a>--%>
<%--</li>--%>
<%--<li class="nav-item">--%>
<%--<a class="nav-link" id="pills-contact-tab" data-toggle="pill" href="#pills-contact"--%>
<%--role="tab" aria-controls="pills-contact" aria-selected="false">Contact</a>--%>
<%--</li>--%>
<%--</ul>--%>
<%--<div class="tab-content" id="pills-tabContent">--%>
<%--<div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">...</div>--%>
<%--<div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">...</div>--%>
<%--<div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab">...</div>--%>
<%--</div>--%>
<%--</div>--%>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-top">
    <a class="navbar-brand" href="#">Training portal</a>
    <ul class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" href="#">Link</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">Link</a>
        </li>
    </ul>
</nav>

<%--<nav class="navbar navbar-inverse">--%>
<%--<div class="container-fluid">--%>
<%--<div class="navbar-header">--%>
<%--<a class="navbar-brand" href="/teacher">Training portal</a>--%>
<%--</div>--%>
<%--<ul class="nav navbar-nav">--%>
<%--<li class="active"><a href="/teacher">Home</a></li>--%>
<%--<li><a href="/teacher/quizzes">Quizzes</a></li>--%>
<%--<li><a href="/teacher/groups">Groups</a></li>--%>
<%--<li><a href="/teacher/students">Students</a></li>--%>
<%--<li><a href="/student/results">Results</a></li>--%>
<%--</ul>--%>
<%--<ul class="nav navbar-nav navbar-right">--%>
<%--<c:choose>--%>
<%--<c:when test="${teacherId eq null}">--%>
<%--<li><a href="/register"><span class="glyphicon glyphicon-user"></span> Register</a></li>--%>
<%--<li><a href="/login"><span class="glyphicon glyphicon-log-in"></span> Log in</a></li>--%>
<%--</c:when>--%>
<%--<c:otherwise>--%>
<%--<li><a href="/logout"><span class="glyphicon glyphicon-log-out"></span> Log out</a></li>--%>
<%--</c:otherwise>--%>
<%--</c:choose>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</nav>--%>
<script>
    $('ul > li > a[href="' + window.location.pathname + '"]').parent().addClass('active');
</script>
</body>
</html>
