<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Publication</title>
    <c:import url="../fragment/head.jsp"/>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2>${quiz.name}</h2>
    <form action="#" method="post">
        <div class="row">
            <div class="col-4">
                <h4>Publication</h4>
            </div>
            <div class="col-2">
                <button type="submit" class="btn btn-success">
                    <i class="fa fa-share-square-o"></i> Publish
                </button>
            </div>
        </div>
        <div class="highlight-primary">
            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                 width="25" height="25" class="icon-one-row">
            Select students or groups for whom you want to publish the quiz
        </div>
        <c:choose>
            <c:when test="${empty groups && empty studentsWithoutGroup}">
                <div class="highlight-primary">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25" class="icon-one-row">
                    There are no students and groups that you can publish quiz
                </div>
            </c:when>
            <c:when test="${empty groups}">
                <div class="col-8">
                    <table class="table">
                        <tr>
                            <th style="width: 80%">Students without group</th>
                            <th style="width: 20%"></th>
                        </tr>
                        <c:forEach items="${studentsWithoutGroup}" var="student" varStatus="status">
                            <tr>
                                <td>${student.lastName} ${student.firstName}</td>
                                <td>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" id="student${status.index}" name="student${status.index}"
                                               value="${student.userId}" class="custom-control-input">
                                        <label for="student${status.index}" class="custom-control-label"></label>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:when>
            <c:when test="${empty studentsWithoutGroup}">
                <div class="col-4">
                    <table class="table">
                        <tr>
                            <th style="width: 80%">Groups</th>
                            <th style="width: 20%"></th>
                        </tr>
                        <c:forEach items="${groups}" var="group" varStatus="status">
                            <tr>
                                <td>${group.name}</td>
                                <td>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" id="group${status.index}" name="group${status.index}"
                                               value="${group.groupId}" class="custom-control-input">
                                        <label for="group${status.index}" class="custom-control-label"></label>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-6">
                        <div id="accordion">
                            <div class="accordion-header">Groups</div>
                            <c:forEach items="${groups}" var="group">
                                <div class="card">
                                    <div class="card-header" id="heading${group.groupId}">
                                        <button type="button" class="btn-link" data-toggle="collapse"
                                                data-target="#collapse${group.groupId}"
                                                aria-expanded="false" aria-controls="collapse${group.groupId}">
                                                ${group.name}
                                        </button>
                                        <div class="custom-control custom-checkbox right">
                                            <input type="checkbox" id="group${group.groupId}"
                                                   name="group${group.groupId}"
                                                   value="${group.groupId}" class="custom-control-input">
                                            <label for="group${group.groupId}" class="custom-control-label"></label>
                                        </div>
                                    </div>
                                    <div id="collapse${group.groupId}" class="collapse"
                                         aria-labelledby="heading${group.groupId}" data-parent="#accordion">
                                        <div class="card-body">
                                            <c:forEach items="${students[group.groupId]}" var="student">
                                                <div class="row">
                                                    <div class="col-1"></div>
                                                    <div class="col-9">${student.lastName} ${student.firstName}</div>
                                                    <div class="col-2">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" id="student${student.userId}"
                                                                   name="student${student.userId}"
                                                                   value="${student.userId}" class="custom-control-input">
                                                            <label for="student${student.userId}" class="custom-control-label"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="col-6">
                        <table class="table">
                            <tr>
                                <th style="width: 90%">Students without group</th>
                                <th style="width: 10%"></th>
                            </tr>
                            <c:forEach items="${studentsWithoutGroup}" var="student">
                                <tr>
                                    <td>${student.lastName} ${student.firstName}</td>
                                    <td>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" id="student${student.userId}"
                                                   name="student${student.userId}"
                                                   value="${student.userId}" class="custom-control-input">
                                            <label for="student${student.userId}" class="custom-control-label"></label>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </form>
    <button type="button" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
