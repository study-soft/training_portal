<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add students</title>
    <c:import url="../fragment/head.jsp"/>
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
                                $('h3').after('<div class="row no-gutters align-items-center highlight-primary">\n' +
                                    '                <div class="col-auto mr-3">\n' +
                                    '                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                    '                         width="25" height="25">\n' +
                                    '                </div>\n' +
                                    '                <div class="col">\n' +
                                    '                    There is no students without group\n' +
                                    '                </div>\n' +
                                    '            </div>');
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
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${group.name}"/></h2>
    <h4>Students to add:</h4>
    <c:choose>
        <c:when test="${empty students}">
            <div>There is no students without group.</div>
            <div><input type="button" class="btn btn-primary" value="Back" onclick="window.history.go(-1);"></div>
        </c:when>
        <c:otherwise>
            <span class="error">${noStudents}</span>
            <form id="addStudentsForm" action="/teacher/groups/${group.groupId}/add-students" method="post">
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
                            <td>${student.email}</td>
                            <td>
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" id="student${status.index}" name="student${status.index}"
                                           class="custom-control-input" value="${student.userId}">
                                    <label for="student${status.index}" class="custom-control-label"></label>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
                <input type="button" class="btn btn-primary" value="Back" onclick="window.history.go(-1);">
                <!-- Button trigger modal -->
                <button class="btn btn-success" id="add" data-toggle="modal" data-target="#modal">
                    <i class="fa fa-user-plus"></i> Add
                </button>
                <div>
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
</div>
</body>
</html>