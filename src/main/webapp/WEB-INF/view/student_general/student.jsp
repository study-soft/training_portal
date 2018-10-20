<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDate" uri="/WEB-INF/custom_tags/formatLocalDate" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
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
                $(this).text() === "show" ? $(this).text("hide") : $(this).text("show");
                $("#credentials").fadeToggle("slow");
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <div id="edit-success" class="col-lg-5 mx-auto text-center correct update-success">
        Profile information successfully changed
        <button id="close" class="close">&times;</button>
    </div>
    <a href="${pageContext.request.contextPath}/student?lang=en">English</a> |
    <a href="${pageContext.request.contextPath}/student?lang=uk">Українська</a> |
    <a href="${pageContext.request.contextPath}/student?lang=ru">Русский</a>
    <br>locale: ${pageContext.response.locale}
    <br><spring:message code="test.message"/>
    <h2>Hi, ${student.firstName}! Welcome to the training portal!</h2>
    <h4><i class="fa fa-graduation-cap"></i> Student information</h4>
    <table class="col-lg-6 table-info">
        <tr>
            <td>Name</td>
            <td>${student.lastName} ${student.firstName}</td>
        </tr>
        <tr>
            <td>E-mail</td>
            <td>${student.email}</td>
        </tr>
        <tr>
            <td>Phone number</td>
            <td>${student.phoneNumber}</td>
        </tr>
        <c:if test="${student.dateOfBirth ne null}">
            <tr>
                <td>Date of birth</td>
                <td><localDate:format value="${student.dateOfBirth}"/></td>
            </tr>
        </c:if>
    </table>
    <h4 class="inline"><i class="fa fa-lock"></i> Login and password</h4>
    <a href="" id="switcher" style="padding-left: 15px;">show</a>
    <table id="credentials" class="col-lg-6 table-info hidden">
        <tr>
            <td>Login</td>
            <td>${student.login}</td>
        </tr>
        <tr>
            <td>Password</td>
            <td>${student.password}</td>
        </tr>
    </table>
    <div>
        <a href="${pageContext.request.contextPath}/student/edit-profile"
           class="btn btn-primary">Edit profile</a>
    </div>
    <h4><i class="fa fa-group"></i> Group information</h4>
    <c:choose>
        <c:when test="${group eq null}">
            <div class="row no-gutters align-items-center highlight-danger">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-danger.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    You do not belong to any group
                    <br>Say you teachers to add you
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="col-lg-6 table-info">
                <tr>
                    <td>Name</td>
                    <td><c:out value="${group.name}"/></td>
                </tr>
                <tr>
                    <td>Creation date</td>
                    <td><localDate:format value="${group.creationDate}"/></td>
                </tr>
                <tr>
                    <td>Number of students</td>
                    <td>${numberOfStudents}</td>
                </tr>
                <tr>
                    <td>Author</td>
                    <td>${authorName}</td>
                </tr>
            </table>
            <div>
                <a href="${pageContext.request.contextPath}/student/group"
                   class="btn btn-primary">More info</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<br>
</body>
</html>
