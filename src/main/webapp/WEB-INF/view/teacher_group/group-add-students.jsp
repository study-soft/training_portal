<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.add.students"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            let form = $("#addStudentsForm");
            form.submit(function (e) {
                e.preventDefault();
                let formData = form.serialize();
                if (formData) {
                    $.ajax({
                        type: form.attr("method"),
                        url: form.attr("action"),
                        data: formData,
                        success: function (students) {
                            window.scrollTo(0, 0);
                            $('.modal-body').html('<div><spring:message code="group.students.added"/>:</div><ul></ul>');
                            for (let i = 0; i < students.length; i++) {
                                let student = students[i];
                                $('input[value="' + student.userId + '"]').parents("tr").remove();
                                $('.modal-title').text('<spring:message code="success"/>');
                                $('.modal-body ul').append('<li>' + student.lastName + ' ' + student.firstName + '</li>');
                            }
                            if ($("#addStudentsForm table tr").length === 1) {
                                $('#addStudentsForm table').after('<div class="row no-gutters align-items-center highlight-primary">\n' +
                                    '                <div class="col-auto mr-3">\n' +
                                    '                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                    '                         width="25" height="25">\n' +
                                    '                </div>\n' +
                                    '                <div class="col">\n' +
                                    '                    <spring:message code="group.no.students.without"/>\n' +
                                    '                </div>\n' +
                                    '            </div>');
                                $('#addStudentsForm table').remove();
                                $('#add').remove();
                            }
                        }
                    });
                } else {
                    $('.modal-title').text('<spring:message code="oops"/>...');
                    $('.modal-body').text('<spring:message code="group.select.student"/>');
                }
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${group.name}"/></h2>
    <h4><spring:message code="group.students.add"/>:</h4>
    <c:choose>
        <c:when test="${empty students}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="group.no.students.without"/>
                </div>
            </div>
            <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
        </c:when>
        <c:otherwise>
            <span class="error">${noStudents}</span>
            <form id="addStudentsForm" action="/teacher/groups/${group.groupId}/add-students" method="post">
                <table class="table">
                    <tr>
                        <th><spring:message code="user.name"/></th>
                        <th><spring:message code="user.mail"/></th>
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
                <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
                <!-- Button trigger modal -->
                <button class="btn btn-success btn-wide" id="add" data-toggle="modal" data-target="#modal">
                    <i class="fa fa-user-plus"></i> <spring:message code="group.add"/>
                </button>
                <div>
                    <!-- Modal -->
                    <div class="modal fade" id="modal" tabindex="-1" role="dialog"
                         aria-labelledby="modalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modalLabel"><spring:message code="success"/></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <ul></ul>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" data-dismiss="modal">
                                        <spring:message code="ok"/>
                                    </button>
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