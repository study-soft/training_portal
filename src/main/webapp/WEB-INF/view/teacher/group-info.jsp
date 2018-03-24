<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group info</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            var createSuccess = "${createSuccess}";
            var editSuccess = "${editSuccess}";
            if (createSuccess) {
                $("#create-success").fadeIn("slow");
            }
            if (editSuccess) {
                $("#edit-success").fadeIn("slow");
            }

            $(".close").click(function () {
                $(".edit-success").fadeOut("slow");
            });

            $("#back").click(function () {
                var previousUri = document.referrer;
                var createGroupUri = "http://" + "${header["host"]}" + "/teacher/groups/create";
                var editGroupUri = "http://" + "${header["host"]}" + "/teacher/groups/" + ${group.groupId} + "/edit";
                if (previousUri === createGroupUri || previousUri === editGroupUri) {
                    window.history.go(-2);
                } else {
                    window.history.go(-1);
                }
            });

            $('a:contains(Delete)').click(function (event) {
                event.preventDefault();
                var studentName = $(this).parent().prev().text();
                $('.modal-body').text('Are you sure you want to delete ' + studentName + ' from group?');
                var studentId = $(this).next().val();
                $('#studentId').val(studentId);
            });

            $('#yes').click(function () {
                var studentId = $(this).next().val();
                $.ajax({
                    type: 'POST',
                    url: '/teacher/groups/${group.groupId}/delete-student',
                    data: 'studentId=' + studentId,
                    success: function (studentId) {
                        $('#' + studentId).remove();
                        if ($('tr').length === 1) {
                            var table = $('table');
                            table.before('<div>There is no students in group.</div>');
                            table.remove();
                        }
                    }
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="create-success" class="col-5 mx-auto text-center correct edit-success">
        Group successfully created
        <button class="close">&times;</button>
    </div>
    <div id="edit-success" class="col-5 mx-auto text-center correct edit-success">
        Group information successfully changed
        <button class="close">&times;</button>
    </div>
    <h2>${group.name}</h2>
    <div class="col-6"><strong>Description: </strong>${group.description}</div>
    <table class="col-6 table-info">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td>Number of students</td>
            <td>${studentsNumber}</td>
        </tr>
    </table>
    <h3>Students</h3>
    <c:choose>
        <c:when test="${empty students}">
            <div>There is no students in group.</div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <tr>
                    <th style="width: 50%">Name</th>
                    <th style="width: 50%"></th>
                </tr>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <tr id="${student.userId}">
                        <td id="studentName"><a
                                href="/student/${student.userId}">${student.lastName} ${student.firstName}</td>
                        <td>
                            <a href="/teacher/groups/${group.groupId}/delete-student"
                               data-toggle="modal" data-target="#modal">Delete</a>
                            <input type="hidden" name="studentId" value="${student.userId}">
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <button id="back" class="btn btn-primary">Back</button>
    <a href="/teacher/groups/${group.groupId}/add-students" class="btn btn-success" style="width: 150px">
        <i class="fa fa-user-plus"></i> Add students
    </a>
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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <button id="yes" type="button" class="btn btn-primary" data-dismiss="modal">Yes</button>
                    <input id="studentId" type="hidden" name="studentId" value="">
                </div>
            </div>
        </div>
    </div>
    <br>
</div>
<br>
</body>
</html>