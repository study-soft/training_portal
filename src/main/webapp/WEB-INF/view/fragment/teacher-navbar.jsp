<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
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
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/teacher">
        <img src="/resources/training-portal-favicon.png" width="30" height="30"> Training portal
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo02"
            aria-controls="navbarTogglerDemo02" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarTogglerDemo02" id="navbar">
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
            <li class="nav-item">
                <a class="nav-link" href="/teacher">Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/teacher/quizzes">Quizzes</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/teacher/groups">Groups</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/teacher/students">Students</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/student/results">Results</a>
            </li>
        </ul>
        <ul class="navbar-nav justify-content-end">
            <li class="nav-item">
                <a href="/logout" class="nav-link">Log out</a>
            </li>
        </ul>
    </div>
</nav>
<script>
    var currentPath = window.location.pathname;
    var locationPath;
    if (currentPath === "/teacher") {
        locationPath = currentPath;
    } else {
        var url = currentPath.split("/");
        locationPath = "/" + url[1] + "/" + url[2];
    }
    $('ul li a[href="'+ locationPath + '"]').parent().addClass('active');
</script>
</body>
</html>
