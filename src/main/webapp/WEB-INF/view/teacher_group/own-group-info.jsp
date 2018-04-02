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
                $(".update-success").fadeOut("slow");
            });

            $("#back").click(function () {
                var previousUri = document.referrer;
                var createGroupUri = "http://" + "${header["host"]}" + "/teacher/groups/create";
                var editGroupUri = "http://" + "${header["host"]}" + "/teacher/groups/" + ${group.groupId} +"/edit";
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
                $("#modal-student").modal();
            });

            $('#yes-student').click(function () {
                var studentId = $(this).next().val();
                $.ajax({
                    type: 'POST',
                    url: '/teacher/groups/${group.groupId}/delete-student',
                    data: 'studentId=' + studentId,
                    success: function (studentId) {
                        $('#' + studentId).remove();
                        var studentsTable = $('#studentsTable');
                        if (studentsTable.find("tr").length === 1) {
                            studentsTable.before('<div>There is no students in group.</div>');
                            studentsTable.remove();
                        }
                    }
                });
            });

            $("#delete-group").click(function () {
                $("#deleteForm").attr("action", "/teacher/groups/" + "${group.groupId}" + "/delete");
                $(".modal-body").text("Are you sure you want to delete group '" + "${group.name}" + "'?");
                $("#modal-group").modal();
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="create-success" class="col-5 mx-auto text-center correct update-success">
        Group successfully created
        <button class="close">&times;</button>
    </div>
    <div id="edit-success" class="col-5 mx-auto text-center correct update-success">
        Group information successfully changed
        <button class="close">&times;</button>
    </div>
    <h2>${group.name}</h2>
    <c:if test="${group.description ne null}">
        <div class="col-6"><strong>Description: </strong>${group.description}</div>
    </c:if>
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
            <div class="highlight-primary">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25" class="icon-one-row">
                There is no students in group
            </div>
        </c:when>
        <c:otherwise>
            <table id="studentsTable" class="table">
                <tr>
                    <th style="width: 50%">Name</th>
                    <th style="width: 50%"></th>
                </tr>
                <c:forEach items="${students}" var="student" varStatus="status">
                    <tr id="${student.userId}">
                        <td id="studentName"><a
                                href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                        </td>
                        <td>
                            <a href="/teacher/groups/${group.groupId}/delete-student">
                                <i class="fa fa-user-times"></i> Delete
                            </a>
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
    <a href="/teacher/groups/${group.groupId}/edit" class="btn btn-primary">
        <i class="fa fa-edit"></i> Edit
    </a>
    <button id="delete-group" class="btn btn-danger"><i class="fa fa-trash-o"></i> Delete</button>

    <div class="modal fade" id="modal-student" tabindex="-1" role="dialog"
         aria-labelledby="modalLabelStudent" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabelStudent">Attention</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <button id="yes-student" type="button" class="btn btn-primary" data-dismiss="modal">Yes</button>
                    <input id="studentId" type="hidden" name="studentId" value="">
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modal-group" tabindex="-1" role="dialog"
         aria-labelledby="modalLabelGroup" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabelGroup">Attention</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <form id="deleteForm" action="" method="post">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                        <input type="submit" id="yes-group" class="btn btn-primary" value="Yes">
                    </form>
                </div>
            </div>
        </div>
    </div>
    <br>
</div>
<br>
</body>
</html>