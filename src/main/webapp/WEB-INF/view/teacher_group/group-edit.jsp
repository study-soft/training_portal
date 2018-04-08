<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit group</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>Edit group</h2>
    <form action="/teacher/groups/${group.groupId}/edit" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <div>
            <label for="name" class="col-form-label">
                <strong>Name<span class="error">*</span></strong>
            </label>
        </div>
        <div>
            <input type="text" name="name" id="name" value="${group.name}" class="col-md-4 form-control">
            <span class="error">${emptyName}</span>
            <span class="error">${groupExists}</span>
        </div>
        <div>
            <label for="description" class="col-form-label"><strong>Description</strong></label>
        </div>
        <div>
            <textarea rows="6" name="description" id="description" placeholder="Description"
                      class="col-lg-6 form-control">${group.description}</textarea>
        </div>
        <div class="row no-gutters align-items-center highlight-primary">
            <div class="col-auto mr-3">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25">
            </div>
            <div class="col">
                Save changes to add or remove students from this group
            </div>
        </div>
        <h4>Students in group</h4>
        <c:choose>
            <c:when test="${empty students}">
                <div class="row no-gutters align-items-center highlight-primary">
                    <div class="col-auto mr-3">
                        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                             width="25" height="25">
                    </div>
                    <div class="col">
                        There is no students in this group
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <table class="table">
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
                            <td>
                                <label for="student${status.index}">${student.email}</label>
                            </td>
                            <td>
                                <label for="student${status.index}">${student.phoneNumber}</label>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
        <div>
            <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
            <input type="submit" class="btn btn-success" value="Save">
        </div>
    </form>
</div>
</body>
</html>
