<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Group info</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const createSuccess = "${createSuccess}";
            const editSuccess = "${editSuccess}";
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
                const previousUri = document.referrer;
                const createGroupUri = "http://" + "${header["host"]}" + "/teacher/groups/create";
                const editGroupUri = "http://" + "${header["host"]}" + "/teacher/groups/" + ${group.groupId} +"/edit";
                if (previousUri === createGroupUri || previousUri === editGroupUri) {
                    window.history.go(-2);
                } else {
                    window.history.go(-1);
                }
            });

            $('a:contains(Delete)').click(function (event) {
                event.preventDefault();
                const studentName = $(this).parent().prev().text();
                $('.modal-body').text('Are you sure you want to delete ' + studentName + ' from group?');
                const studentId = $(this).next().val();
                $('#studentId').val(studentId);
                $("#modal-student").modal();
            });

            $('#yes-student').click(function () {
                const studentId = $(this).next().val();
                $.ajax({
                    type: "POST",
                    url: "/teacher/groups/${group.groupId}/delete-student",
                    data: "studentId=" + studentId,
                    success: function (studentId) {
                        var $numberOfStudents = $("#numberOfStudents");
                        $numberOfStudents.text(Number($numberOfStudents.text()) - 1);

                        $("#" + studentId).remove();
                        const studentsTable = $('#studentsTable');
                        if (studentsTable.find("tr").length === 0) {
                            studentsTable.before('<div class="row no-gutters align-items-center highlight-primary">\n' +
                                '                <div class="col-auto mr-3">\n' +
                                '                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                '                         width="25" height="25">\n' +
                                '                </div>\n' +
                                '                <div class="col">\n' +
                                '                    There is no students in this group\n' +
                                '                </div>\n' +
                                '            </div>');
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
    <div id="create-success" class="col-lg-5 mx-auto text-center correct update-success">
        Group successfully created
        <button class="close">&times;</button>
    </div>
    <div id="edit-success" class="col-lg-5 mx-auto text-center correct update-success">
        Group information successfully changed
        <button class="close">&times;</button>
    </div>
    <h2><c:out value="${group.name}"/></h2>
    <c:if test="${group.description ne null}">
        <div class="col-lg-6">
            <strong>Description: </strong><c:out value="${group.description}"/>
        </div>
    </c:if>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${group.creationDate}"/></td>
        </tr>
        <tr>
            <td>Number of students</td>
            <td id="numberOfStudents">${studentsNumber}</td>
        </tr>
    </table>
    <h4>You gave next quizzes to this group</h4>
    <c:choose>
        <c:when test="${empty publishedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    You did not give quizzes to this group
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="col-lg-6 table-info">
                <c:forEach items="${publishedQuizzes}" var="quiz" varStatus="status">
                    <tr>
                        <td>
                            <a href="/teacher/quizzes/${quiz.quizId}">
                                <c:out value="${quiz.name}"/>
                            </a>
                        </td>
                        <td>${statuses[status.index]}</td>
                        <td>${studentsProgress[quiz.quizId][0]} / ${studentsProgress[quiz.quizId][1]}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
    <h4>Students</h4>
    <c:choose>
        <c:when test="${empty studentsList}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    There is no students in this group
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table id="studentsTable" class="col-lg-6 table-info">
                <c:forEach items="${studentsList}" var="student" varStatus="status">
                    <tr id="${student.userId}">
                        <td id="studentName"><a
                                href="/teacher/students/${student.userId}">${student.lastName} ${student.firstName}</a>
                        </td>
                        <td>
                            <a href="/teacher/groups/${group.groupId}/delete-student" class="danger">
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