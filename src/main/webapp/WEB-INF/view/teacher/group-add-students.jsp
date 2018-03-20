<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add students</title>
    <link rel="shortcut icon" type="image/png"
          href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
</head>
<body>
<c:import url="../fragment/teacher-navbar.jsp"/>
<h2>${group.name}</h2>
<h3>Students to add:</h3>
<c:choose>
    <c:when test="${empty students}">
        <div>There is no students without group.</div>
        <div><input type="button" value="Back" onclick="window.history.go(-1);"></div>
    </c:when>
    <c:otherwise>
        <span class="error">${noStudents}</span>
        <form id="addStudentsForm" action="/teacher/groups/${group.groupId}/add-students" method="post">
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
            <div>
                <input type="button" class="btn btn-primary" value="Back" onclick="window.history.go(-1);">
                <!-- Button trigger modal -->
                <input type="submit" class="btn btn-primary" id="add" value="Add"
                       data-toggle="modal" data-target="#modal">
                <!-- Modal -->
                <div class="modal fade" id="modal" tabindex="-1" role="dialog"
                     aria-labelledby="modalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="modalLabel">Success</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <ul></ul>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" data-dismiss="modal">Ok</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </c:otherwise>
</c:choose>
<script>
    $(document).ready(function () {
        var form = $("#addStudentsForm");
        form.submit(function (e) {
            e.preventDefault();
            var formData = form.serialize();
            if (formData) {
                $.ajax({
                    type: form.attr("method"),
                    url: form.attr("action"),
                    data: formData,
                    success: function (students) {
                        $('.modal-body').html('<div>You have added such students:</div><ul></ul>');
                        for (var i = 0; i < students.length; i++) {
                            var student = students[i];
                            $('input[value="' + student.userId + '"]').parents("tr").remove();
                            $('.modal-title').text('Success');
                            $('.modal-body ul').append('<li>' + student.lastName + ' ' + student.firstName + '</li>');
                        }
                        if ($('tr').length === 1) {
                            $('table').remove();
                            $('h3').after('<div>There is no students without group.</div>');
                            $('input[type="submit"]').remove();
                        }
                    }
                });
            } else {
                $('.modal-title').text('Oops...');
                $('.modal-body').text('Select at least one student please');
            }
        });
    });
</script>
</body>
</html>