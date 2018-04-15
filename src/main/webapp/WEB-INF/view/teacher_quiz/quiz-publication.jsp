<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Publication</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("[id*='group']").change(function () {
                var studentsCheckboxes = $(this).parents(".card").find("[id*='student']");
                if ($(this).prop("checked")) {
                    studentsCheckboxes.prop("checked", true);
                } else {
                    studentsCheckboxes.prop("checked", false);
                }
            });

            $("[id*='collapse'] [id*='student']").change(function () {
                var allChecked = true;
                var section = $(this).parents("[id*='collapse']");
                section.find("[id*='student']").each(function () {
                    if ($(this).prop("checked") === false) {
                        allChecked = false;
                    }
                });

                var groupCheckbox = $(this).parents(".card").find("[id*='group']");
                if (allChecked) {
                    groupCheckbox.prop("checked", true);
                } else {
                    groupCheckbox.prop("checked", false);
                }
            });

            $("#publicationForm").submit(function () {
                var checkboxes = $("[id*='group']:checked, [id*='student']:checked");
                if (checkboxes.length === 0) {
                    alert("Select anyone to whom you want to publish this quiz");
                    return false;
                }
                $("[id*='group']:checked").prop("disabled", true);
                return true;
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><c:out value="${quiz.name}"/></h2>
    <c:choose>
        <c:when test="${empty groups && empty studentsWithoutGroup}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    There is no students and groups that you can publish quiz
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <form id="publicationForm" action="/teacher/quizzes/${quiz.quizId}/publication" method="post">
                <div class="row">
                    <div class="col-sm-4">
                        <h4>Publication</h4>
                    </div>
                    <div class="col-sm-2 align-self-end">
                        <button type="submit" class="btn btn-success" style="margin-bottom: 20px">
                            <i class="fa fa-share-square-o"></i> Publish
                        </button>
                    </div>
                </div>
                <div class="row no-gutters align-items-center highlight-primary">
                    <div class="col-auto mr-3">
                        <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                             width="25" height="25">
                    </div>
                    <div class="col">
                        Select students or groups for whom you want to publish quiz
                    </div>
                </div>
                <div class="row">
                    <c:if test="${not empty groups}">
                        <div class="col-sm-6">
                            <div class="accordion-header">Groups</div>
                            <c:forEach items="${groups}" var="group">
                                <div class="card">
                                    <div class="card-header" id="heading${group.groupId}">
                                        <button type="button" class="btn-link" data-toggle="collapse"
                                                data-target="#collapse${group.groupId}"
                                                aria-expanded="false" aria-controls="collapse${group.groupId}">
                                                <c:out value="${group.name}"/>
                                        </button>
                                        <div class="custom-control custom-checkbox right">
                                            <input type="checkbox" id="group${group.groupId}"
                                                   name="group${group.groupId}"
                                                   value="${group.groupId}" class="custom-control-input">
                                            <label for="group${group.groupId}" class="custom-control-label"></label>
                                        </div>
                                    </div>
                                    <div id="collapse${group.groupId}" class="collapse"
                                         aria-labelledby="heading${group.groupId}">
                                        <div class="card-body">
                                            <c:forEach items="${students[group.groupId]}" var="student">
                                                <div class="row">
                                                    <div class="col-9 offset-1">
                                                            ${student.lastName} ${student.firstName}
                                                    </div>
                                                    <div class="col-2">
                                                        <div class="custom-control custom-checkbox">
                                                            <input type="checkbox" id="student${student.userId}"
                                                                   name="student${student.userId}"
                                                                   value="${student.userId}"
                                                                   class="custom-control-input">
                                                            <label for="student${student.userId}"
                                                                   class="custom-control-label"></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${not empty studentsWithoutGroup}">
                        <div class="col-sm-6">
                            <table class="table">
                                <tr>
                                    <th style="width: 90%">Students without group</th>
                                    <th style="width: 10%"></th>
                                </tr>
                                <c:forEach items="${studentsWithoutGroup}" var="student">
                                    <tr>
                                        <td>${student.lastName} ${student.firstName}</td>
                                        <td>
                                            <div class="custom-control custom-checkbox">
                                                <input type="checkbox" id="student${student.userId}"
                                                       name="student${student.userId}"
                                                       value="${student.userId}" class="custom-control-input">
                                                <label for="student${student.userId}"
                                                       class="custom-control-label"></label>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>
                    </c:if>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
    <button type="button" class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
</div>
<br>
</body>
</html>
