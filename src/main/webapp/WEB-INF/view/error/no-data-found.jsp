<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>No data found</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<c:import url="../fragment/navbar.jsp"/>
<body>
<div class="container">
    <h2>No data found</h2>
    <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
</body>
</html>
