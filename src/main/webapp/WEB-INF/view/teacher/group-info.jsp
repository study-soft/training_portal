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
                $("#create-success").fadeIn("slow").delay(3000).fadeOut("slow");
            }
            if (editSuccess) {
                $("#edit-success").fadeIn("slow").delay(3000).fadeOut("slow");
            }
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <br>
    <div id="create-success" class="col-4 mx-auto text-center correct edit-success">
        Group successfully created
    </div>
    <div id="edit-success" class="col-4 mx-auto text-center correct edit-success">
        Group information successfully changed
    </div>
    <h2>${group.name}</h2>
    <small>Creation date: <localDate:format value="${group.creationDate}"/></small>
    <div>Number of students: ${studentsNumber}</div>
    <div>Description:</div>
    <div>${group.description}</div>
    <h3 class="inline">Students</h3>
    <a href="/teacher/groups/${group.groupId}/add-students">+ Add students</a>
    <br>
    <c:choose>
        <c:when test="${empty students}">
            <div>There is no students in group.</div>
        </c:when>
        <c:otherwise>
            <table>
                <tr>
                    <th>Name</th>
                    <th></th>
                    <th></th>
                </tr>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <tr id="${student.userId}">
                        <td id="studentName">${student.lastName} ${student.firstName}</td>
                        <td><a href="/student/${student.userId}">More</a></td>
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
    <div>
        <input type="button" value="Back" onclick="window.history.go(-1);">
    </div>
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
<script>
    $(document).ready(function () {
        $('td a').click(function (event) {
            event.preventDefault();
            var studentName = $(this).parent().prev().prev().text();
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
</body>
</html>