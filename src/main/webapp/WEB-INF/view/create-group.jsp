<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create group</title>
    <c:import url="fragment/teacher-navbar.jsp"/>
</head>
<body>
<h2>Create group</h2>
<form action="/teacher/groups/create" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div>
        <label for="name">Name<span class="error">*</span>:</label>
    </div>
    <div>
        <input type="text" name="name" id="name">
        <span class="error">${emptyName}</span>
    </div>
    <br>
    <div>
        <label for="description">Description:</label>
    </div>
    <div>
        <textarea rows="6" cols="40" name="description" id="description"></textarea>
    </div>
    <h3>Students to add:</h3>
    <c:choose>
        <c:when test="${empty students}">
            <div>There is no students without a group.</div>
            <div>You can create an empty group and later add students to it that do not belong to any group</div>
        </c:when>
        <c:otherwise>
            <table>
                <tr>
                    <th>Name</th>
                    <th>E-mail</th>
                    <th></th>
                </tr>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <tr>
                        <td>
                            <label for="student${status.index}">${student.lastName} ${student.firstName}</label>
                        </td>
                        <td>${student.email}</td>
                        <td><input type="checkbox" name="student${status.index}"
                                   value="${student.userId}" id="student${status.index}"></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <div>
        <input type="button" value="Back" onclick="window.history.go(-1);">
        <input type="submit" value="Create">
    </div>
</form>
</body>
</html>
