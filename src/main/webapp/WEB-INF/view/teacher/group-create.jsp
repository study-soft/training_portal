<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create group</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Create group</h2>
    <form action="/teacher/groups/create" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <div>
            <label for="name" class="col-form-label">Name<span class="error">*</span>:</label>
        </div>
        <div>
            <input type="text" name="name" id="name" class="col-4 form-control">
            <span class="error">${emptyName}</span>
            <span class="error">${groupExists}</span>
        </div>
        <div>
            <label for="description" class="col-form-label">Description:</label>
        </div>
        <div>
            <textarea rows="6" name="description" id="description" class="col-6 form-control"></textarea>
        </div>
        <h3>Students to add:</h3>
        <c:choose>
            <c:when test="${empty students}">
                <div>There is no students without a group.</div>
                <div>You can create an empty group and later add students to it that do not belong to any group</div>
            </c:when>
            <c:otherwise>
                <table class="table">
                    <tr>
                        <th>Name</th>
                        <th>E-mail</th>
                        <th>Phone number</th>
                        <th></th>
                    </tr>
                    <c:forEach items="${students}" var="student" varStatus="status">
                        <tr>
                            <td>
                                <label for="student${status.index}">${student.lastName} ${student.firstName}</label>
                            </td>
                            <td>
                                <label for="student${status.index}">${student.email}</label>
                            </td>
                            <td>
                                <label for="student${status.index}">${student.phoneNumber}</label>
                            </td>
                            <td>
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" name="student${status.index}" id="student${status.index}"
                                           value="${student.userId}" class="custom-control-input">
                                    <label for="student${status.index}" class="custom-control-label"> </label>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
        <input type="button" value="Back" onclick="window.history.go(-1);" class="btn btn-primary">
        <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Create</button>
    </form>
</div>
<br>
</body>
</html>
