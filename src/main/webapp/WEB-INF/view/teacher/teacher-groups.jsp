<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
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
                <input class="form-control" type="search" placeholder="Search..." aria-label="Search">
            </div>
            <div class="col-5"></div>
            <div class="col-3">
                <a href="/teacher/groups/create" class="btn btn-success float-right" style="width: 125px">
                    <i class="fa fa-group"></i> New group
                </a>
            </div>
        </div>
    </form>
    <table>
        <tr>
            <th>Name</th>
            <th>Students</th>
            <th>Creation date</th>
            <th></th>
            <th></th>
        </tr>
        <c:forEach items="${groups}" var="group" varStatus="status">
            <tr>
                <td><a href="/teacher/groups/${group.groupId}">${group.name}</a></td>
                <td>${studentsNumber[status.index]}</td>
                <td><localDate:format value="${group.creationDate}"/></td>
                <td><a href="/teacher/groups/${group.groupId}/edit"><i class="fa fa-edit"></i> Edit</a></td>
                <td><a href="/teacher/groups/${group.groupId}/delete"><i class="fa fa-trash-o"></i> Delete</a></td>
            </tr>
        </c:forEach>
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