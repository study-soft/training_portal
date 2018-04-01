<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Groups</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("a:contains(Delete)").click(function (event) {
                event.preventDefault();
                var groupName = $(this).parent().prev().prev().prev().prev().text();
                $("#deleteForm").attr("action", $(this).attr("href"));
                $(".modal-body").text("Are you sure you want to delete group '" + groupName + "'?");
                $("#modal").modal();
            });

            $("input[type=search]").on("keyup", function () {
                var value = $(this).val().toLowerCase();
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
    <h2>Groups</h2>
    <form>
        <div class="row">
            <div class="col-4">
                <div class="input-group">
                    <input type="search" class="form-control" placeholder="Search...">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fa fa-search"></i></span>
                    </div>
                </div>
            </div>
            <div class="col-6"></div>
            <div class="col-2">
                <a href="/teacher/groups/create" class="btn btn-success btn-wide">
                    <i class="fa fa-group"></i> New group
                </a>
            </div>
        </div>
    </form>
    <table class="table">
        <thead>
        <tr>
            <th style="width: 40%">Name</th>
            <th style="width: 20%">Students</th>
            <th style="width: 20%">Creation date</th>
            <th style="width: 10%"></th>
            <th style="width: 10%"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${groups}" var="group" varStatus="status">
            <tr>
                <td><a href="/teacher/groups/${group.groupId}">${group.name}</a></td>
                <td>${studentsNumber[status.index]}</td>
                <td><localDate:format value="${group.creationDate}"/></td>
                <c:choose>
                    <c:when test="${fn:contains(teacherGroupsIds, group.groupId)}">
                        <td><a href="/teacher/groups/${group.groupId}/edit"><i class="fa fa-edit"></i> Edit</a></td>
                        <td><a href="/teacher/groups/${group.groupId}/delete"><i class="fa fa-trash-o"></i> Delete</a>
                        </td>
                    </c:when>
                    <c:otherwise>
                        <td></td>
                        <td></td>
                    </c:otherwise>
                </c:choose>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div>
        <input type="button" class="btn btn-primary" value="Back" onclick="window.history.go(-1);">
    </div>
    <br>
    <div class="modal fade" id="modal" tabindex="-1" role="dialog"
         aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">Attention</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <form id="deleteForm" action="" method="post">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                        <input type="submit" id="yes" class="btn btn-primary" value="Yes">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>