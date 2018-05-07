<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="duration" uri="/WEB-INF/custom_tags/formatDuration" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Published quiz</title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const publicationSuccess = "${publicationSuccess}";
            if (publicationSuccess) {
                $("#publication-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#publication-success").fadeOut("slow");
            });

            $("#back").click(function () {
                const previousUri = document.referrer;
                const publicationUri = "http://${header["host"]}${pageContext.request.contextPath}" +
                    "/teacher/quizzes/${publishedQuiz.quizId}/publication";

                if (previousUri === publicationUri) {
                    window.location = "/teacher/quizzes";
                } else {
                    window.history.go(-1);
                }
            });

            $("#unpublish").click(function () {
                $.ajax({
                    type: "GET",
                    url: "${publishedQuiz.quizId}/students-number",
                    error: function (xhr) {
                        alert("Some error. See log in console");
                        console.log(xhr.responseText);
                    },
                    success: function (studentsNumber) {
                        const closedStudents = studentsNumber.closedStudents;
                        const totalStudents = studentsNumber.totalStudents;
                        const modalBody = $(".modal-body");
                        if (closedStudents === totalStudents) {
                            modalBody.text("All students have closed this quiz. \n" +
                                "If you unpublish it results of all students will be lost. Continue?");
                        } else {
                            modalBody.text("Only " + closedStudents + "/" + totalStudents + " students " +
                                "closed this quiz. If you unpublish it, the results of all students " +
                                "will be lost and the remaining students will not be able " +
                                "to pass this quiz. Continue?");
                        }
                        modalBody.append(
                            '<br>\n' +
                            '<br>\n' +
                            '<div class="col-9 form-group">\n' +
                            '    <label class="col-form-label" for="password">Enter password to confirm action</label>\n' +
                            '    <input type="password" class="form-control modal-input" id="password" name="password">\n' +
                            '</div>');
                        $("#modal").modal();
                    }
                });
            });

            $("#unpublishForm").submit(function () {
                const password = "${password}";
                const inputPassword = $("#password").val();
                if (inputPassword !== password) {
                    const modalBody = $(".modal-body");
                    modalBody.find(".error").remove();
                    modalBody.append('<div class="error">Incorrect password</div>');
                    return false;
                }
                return true;
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="publication-success" class="col-lg-5 mx-auto text-center correct update-success">
        Quiz was successfully published
        <button id="close" class="close">&times;</button>
    </div>
    <h2><c:out value="${publishedQuiz.name}"/></h2>
    <div class="row">
        <div class="col-auto">
            <div class="row no-gutters align-items-center highlight-success">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-success.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    This quiz is published
                </div>
            </div>
        </div>
        <div class="col-auto">
            <a href="/teacher/quizzes/${publishedQuiz.quizId}/publication"
               class="btn btn-success btn-wide">Publish again</a>
        </div>
        <div class="col-auto">
            <button type="button" id="unpublish" class="btn btn-danger">Unpublish</button>
        </div>
    </div>
    <c:if test="${publishedQuiz.description ne null}">
        <div class="col-lg-6">
            <strong>Description: </strong><c:out value="${publishedQuiz.description}"/>
        </div>
    </c:if>
    <table class="table-info col-lg-6">
        <tr>
            <td>Creation date</td>
            <td><localDate:format value="${publishedQuiz.creationDate}"/></td>
        </tr>
        <c:if test="${publishedQuiz.passingTime ne null}">
            <tr>
                <td>Passing time</td>
                <td><duration:format value="${publishedQuiz.passingTime}"/></td>
            </tr>
        </c:if>
        <tr>
            <td>Score</td>
            <td>${publishedQuiz.score}</td>
        </tr>
        <tr>
            <td>Total questions</td>
            <td>${publishedQuiz.questionsNumber}</td>
        </tr>
        <tr>
            <td>Questions by types:</td>
            <td></td>
        </tr>
        <c:if test="${questions['ONE_ANSWER'] ne null}">
            <tr>
                <td style="font-weight: normal">One answer</td>
                <td>${questions['ONE_ANSWER']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['FEW_ANSWERS'] ne null}">
            <tr>
                <td style="font-weight: normal;">Few answers</td>
                <td>${questions['FEW_ANSWERS']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['ACCORDANCE'] ne null}">
            <tr>
                <td style="font-weight: normal">Accordance</td>
                <td>${questions['ACCORDANCE']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['SEQUENCE'] ne null}">
            <tr>
                <td style="font-weight: normal">Sequence</td>
                <td>${questions['SEQUENCE']}</td>
            </tr>
        </c:if>
        <c:if test="${questions['NUMBER'] ne null}">
            <tr>
                <td style="font-weight: normal">Numerical</td>
                <td>${questions['NUMBER']}</td>
            </tr>
        </c:if>
    </table>
    <c:if test="${publishedQuiz.explanation ne null}">
        <div class="col-lg-6">
            <strong>Explanation: </strong><c:out value="${publishedQuiz.explanation}"/>
        </div>
        <div class="row no-gutters align-items-center highlight-primary">
            <div class="col-auto mr-3">
                <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                     width="25" height="25">
            </div>
            <div class="col">
                Students will see explanation after all group close this quiz
            </div>
        </div>
    </c:if>

    <h4>Groups and students to whom quiz was published</h4>
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
                        </div>
                        <div id="collapse${group.groupId}" class="collapse"
                             aria-labelledby="heading${group.groupId}">
                            <div class="card-body">
                                <c:forEach items="${students[group.groupId]}" var="student" varStatus="status">
                                    <div class="row">
                                        <div class="col-7 offset-1">
                                            <a href="/teacher/students/${student.userId}">
                                                    ${student.lastName} ${student.firstName}
                                            </a>
                                        </div>
                                        <div class="col-auto align-self-end">
                                                ${statuses[group.groupId][status.index]}
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
                        <th style="width: 70%;">Students without group</th>
                        <th style="width: 30%"></th>
                    </tr>
                    <c:forEach items="${studentsWithoutGroup}" var="student" varStatus="status">
                        <tr>
                            <td>
                                <a href="/teacher/students/${student.userId}">
                                        ${student.lastName} ${student.firstName}
                                </a>
                            </td>
                            <td>${statusesWithoutGroup[status.index]}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:if>
    </div>

    <button type="button" id="back" class="btn btn-primary">Back</button>
    <a href="/teacher/quizzes/${publishedQuiz.quizId}/questions" class="btn btn-primary">Questions</a>
    <a href="/quizzes/${publishedQuiz.quizId}/initialize" class="btn btn-primary">Preview</a>
</div>
<br>
<div class="modal fade" id="modal" tabindex="-1" role="dialog"
     aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title red" id="modalLabel">Danger</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <form id="unpublishForm" action="/teacher/quizzes/${publishedQuiz.quizId}/unpublish" method="post">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                    <button type="submit" id="yes" class="btn btn-primary">Yes</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
