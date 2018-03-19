<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit profile success</title>
    <c:import url="../fragment/student-navbar.jsp"/>
</head>
<body>
<h2>Profile information successfully changed</h2>
<div>Password: ${student.password}</div>
<div>Email: ${student.email}</div>
<div>Phone number: ${student.phoneNumber}</div>
<div>First name: ${student.firstName}</div>
<div>Last name: ${student.lastName}</div>
<c:if test="${student.dateOfBirth ne null}">
    <div>Date of birth: ${student.dateOfBirth}</div>
</c:if>
<div>
    <a href="/student">Home</a>
</div>
</body>
</html>
