<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.groups"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("a[href*='/delete']").click(function (event) {
                window.scrollTo(0, 0);
                event.preventDefault();
                let groupName = $(this).parent("td").siblings().first().text();
                $("#deleteForm").attr("action", $(this).attr("href"));
                $(".modal-body").html("<spring:message code="group.delete.sure"/> '" + groupName + "'?");
                $("#modal").modal();
            });

            $("input[type=search]").on("keyup", function () {
                let value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="group.groups"/></h2>
    <form>
        <div class="row">
            <div class="col-auto col-md-4">
                <div class="input-group shifted-down-10px">
                    <input type="search" class="form-control" placeholder="<spring:message code="search"/>...">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fa fa-search"></i></span>
                    </div>
                </div>
            </div>
            <div class="col-md-2 offset-lg-6">
                <a href="${pageContext.request.contextPath}/teacher/groups/create" class="btn btn-success btn-wide">
                    <i class="fa fa-group"></i> <spring:message code="group.new"/>
                </a>
            </div>
        </div>
    </form>
    <div class="row no-gutters align-items-center highlight-primary">
        <div class="col-auto mr-3">
            <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                 width="25" height="25">
        </div>
        <div class="col">
            <spring:message code="group.groups.quizzes"/>
        </div>
    </div>
    <h4><spring:message code="group.groups.yours"/></h4>
    <c:choose>
        <c:when test="${not empty teacherGroups}">
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 30%"><spring:message code="group.name"/></th>
                    <th style="width: 15%"><spring:message code="group.students"/></th>
                    <th style="width: 20%"><spring:message code="group.creation.date"/></th>
                    <th style="width: 17.5%"></th>
                    <th style="width: 17.5%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${teacherGroups}" var="group" varStatus="status">
                    <tr>
                        <td>
                            <a href="/teacher/groups/${group.groupId}">
                                <c:out value="${group.name}"/>
                            </a>
                        </td>
                        <td>${studentsNumberForTeacherGroups[status.index]}</td>
                        <td><localDate:format value="${group.creationDate}"/></td>
                        <td>
                            <a href="/teacher/groups/${group.groupId}/edit">
                                <i class="fa fa-edit"></i> <spring:message code="edit"/>
                            </a>
                        </td>
                        <td>
                            <a href="/teacher/groups/${group.groupId}/delete" class="danger">
                                <i class="fa fa-trash-o"></i> <spring:message code="delete"/>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="group.no.groups.yours"/>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <h4><spring:message code="group.groups.others"/></h4>
    <c:choose>
        <c:when test="${not empty groups}">
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 30%"><spring:message code="group.name"/></th>
                    <th style="width: 15%"><spring:message code="group.students"/></th>
                    <th style="width: 20%"><spring:message code="group.creation.date"/></th>
                    <th style="width: 35%"><spring:message code="group.author"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${groups}" var="group" varStatus="status">
                    <tr>
                        <td>
                            <a href="/teacher/groups/${group.groupId}">
                                <c:out value="${group.name}"/>
                            </a>
                        </td>
                        <td>${studentsNumberForGroups[status.index]}</td>
                        <td><localDate:format value="${group.creationDate}"/></td>
                        <td>${authors[status.index].lastName} ${authors[status.index].firstName}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="group.no.groups.others"/>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
    <div class="modal fade" id="modal" tabindex="-1" role="dialog"
         aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel"><spring:message code="danger"/></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <form id="deleteForm" action="" method="post">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal"><spring:message code="no"/></button>
                        <input type="submit" id="yes" class="btn btn-primary" value="<spring:message code="yes"/>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>