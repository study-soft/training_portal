<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.home"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            const editSuccess = "${editSuccess}";
            if (editSuccess) {
                $("#edit-success").fadeIn("slow");
            }

            $("#close").click(function () {
                $("#edit-success").fadeOut("slow");
            });

            $("#switcher").click(function (event) {
                event.preventDefault();
                $(this).text() === '<spring:message code="home.show"/>' ?
                    $(this).text('<spring:message code="home.hide"/>') :
                    $(this).text('<spring:message code="home.show"/>');
                $("#credentials").fadeToggle("slow");
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="edit-success" class="col-lg-5 mx-auto text-center correct update-success">
        <spring:message code="home.info.changed"/>
        <button id="close" class="close">&times;</button>
    </div>
    <h2><spring:message code="home.hi"/>, ${student.firstName}! <spring:message code="home.welcome"/></h2>
    <h4><i class="fa fa-graduation-cap"></i> <spring:message code="home.student.info"/></h4>
    <table class="col-lg-6 table-info">
        <tr>
            <td><spring:message code="user.name"/></td>
            <td>${student.lastName} ${student.firstName}</td>
        </tr>
        <tr>
            <td><spring:message code="user.mail"/></td>
            <td>${student.email}</td>
        </tr>
        <tr>
            <td><spring:message code="user.phone"/></td>
            <td>${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td><spring:message code="user.birthday"/></td>
                <td><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
    </table>
    <h4 class="inline"><i class="fa fa-lock"></i> <spring:message code="home.security.info"/></h4>
    <a href="" id="switcher" style="padding-left: 15px;"><spring:message code="home.show"/></a>
    <table id="credentials" class="col-lg-6 table-info hidden">
        <tr>
            <td><spring:message code="user.login"/></td>
            <td>${student.login}</td>
        </tr>
        <tr>
            <td><spring:message code="user.password"/></td>
            <td>${student.password}</td>
        </tr>
    </table>
    <div>
        <a href="${pageContext.request.contextPath}/student/edit-profile"
           class="btn btn-primary btn-wide"><spring:message code="home.edit.profile"/></a>
    </div>
    <h4><i class="fa fa-group"></i> <spring:message code="home.group.information"/></h4>
    <c:choose>
        <c:when test="${group eq null}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="home.no.group"/>
                    <br><spring:message code="home.add.group"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="col-lg-6 table-info">
                <tr>
                    <td><spring:message code="group.name"/></td>
                    <td><c:out value="${group.name}"/></td>
                </tr>
                <tr>
                    <td><spring:message code="group.creation.date"/></td>
                    <td><localDate:format value="${group.creationDate}"/></td>
                </tr>
                <tr>
                    <td><spring:message code="group.students.number"/></td>
                    <td>${numberOfStudents}</td>
                </tr>
                <tr>
                    <td><spring:message code="group.author"/></td>
                    <td>${authorName}</td>
                </tr>
            </table>
            <div>
                <a href="${pageContext.request.contextPath}/student/group"
                   class="btn btn-primary btn-wide"><spring:message code="home.more.info"/></a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<br>
</body>
</html>
