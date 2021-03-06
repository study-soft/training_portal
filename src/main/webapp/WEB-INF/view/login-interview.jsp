<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.login"/></title>
    <c:import url="fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $(".close").click(function () {
                $("#registrationSuccess").fadeOut("slow");
            });
        });
    </script>
</head>
<body>
<br>
<div class="container">
    <c:if test="${registrationSuccess ne null}">
        <div id="registrationSuccess" class="col-lg-6 mx-auto text-center correct">
                ${registrationSuccess}
            <button class="close">&times;</button>
        </div>
    </c:if>
    <div class="right">
        <a id="en" href="#">EN</a> <a id="ru" href="#">RU</a> <a id="uk" href="#">UK</a>
    </div>
    <br>
    <div class="row justify-content-center">
        <div class="col-auto">
            <div class="media">
                <img class="mr-2" style="margin-top: 15px" src="${pageContext.request.contextPath}/resources/icons/training-portal-favicon.png"
                     width="30" height="35">
                <div class="media-body">
                    <h2><spring:message code="login.training.portal"/></h2>
                </div>
            </div>
        </div>
    </div>
    <div class="row justify-content-center">
        <a target="_blank" href="https://github.com/training-portal/training_portal" class="inline">
            <h5><spring:message code="login.github.link"/> <i class="fa fa-external-link"></i></h5>
        </a>
        <a href="${pageContext.request.contextPath}/help" class="ml-5">
            <h5><spring:message code="login.help"/> <i class="fa fa-external-link"></i></h5>
        </a>
    </div>
    <div class="row justify-content-around">
        <div class="col-lg-6 p-lg-4">
            <div class="row correct">
                <div class="col-6">
                    <div>
                        <strong>Teacher credentials:</strong>
                    </div>
                    <div>Login: Andrew</div>
                    <div>Password: 123</div>
                </div>
                <div class="col-6">
                    <div>
                        <strong>Student credentials:</strong>
                    </div>
                    <div>Login: Artem</div>
                    <div>Password: 123</div>
                </div>
            </div>
            <br>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <c:if test="${param.error ne null}">
                    <p class="error"><spring:message code="login.invalid.login.password"/></p>
                </c:if>
                <span class="success">${registrationSuccess}</span>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label for="username" class="col-form-label"><strong><spring:message code="user.login"/></strong></label>
                    </div>
                    <div class="col-md-8">
                        <input type="text" class="form-control" id="username" name="username"
                               placeholder="<spring:message code="user.login"/>">
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-4">
                        <label for="password" class="col-form-label"><strong><spring:message code="user.password"/></strong></label>
                    </div>
                    <div class="col-md-8">
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="<spring:message code="user.password"/>">
                    </div>
                </div>
                <div class="row justify-content-end">
                    <div class="col-auto">
                        <input type="submit" value="<spring:message code="login.log.in"/>" class="btn btn-primary">
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-auto">
                        <div><spring:message code="login.no.account"/>
                            <a href="${pageContext.request.contextPath}/register"><spring:message code="login.register"/></a></div>
                    </div>
                </div>
            </form>
        </div>
        <div class="col-lg-6 p-lg-4">
            <table class="col table">
                <tr>
                    <th colspan="2">
                        <h5 class="text-center">Technologies used</h5>
                    </th>
                </tr>
                <tr>
                    <td><strong>Java 8</strong></td>
                    <td>backend programming language</td>
                </tr>
                <tr>
                    <td><strong>Apache Tomcat 8.5.24</strong></td>
                    <td>application server</td>
                </tr>
                <tr>
                    <td><strong>Apache Maven 3.5.3</strong></td>
                    <td>build tool</td>
                </tr>
                <tr>
                    <td><strong>Spring 4.3 Core, JDBC, MVC, Security</strong></td>
                    <td>server libraries</td>
                </tr>
                <tr>
                    <td><strong>Log4j 1.2.17</strong></td>
                    <td>logging events</td>
                </tr>
                <tr>
                    <td><strong>JUnit 4.12, Spring 4.3 Test, H2 database 1.4.196</strong></td>
                    <td>testing</td>
                </tr>
                <tr>
                    <td><strong>BoneCP 0.8.0</strong></td>
                    <td>connection pool</td>
                </tr>
                <tr>
                    <td><strong>MySQL 5.1.39</strong></td>
                    <td>data storage</td>
                </tr>
                <tr>
                    <td><strong>HTML 5, CSS 3, Bootstrap 4, JSP 2.2, JSTL 1.2</strong></td>
                    <td>frontend</td>
                </tr>
                <tr>
                    <td><strong>JavaScript 5.1</strong></td>
                    <td>frontend programming language</td>
                </tr>
                <tr>
                    <td><strong>JQuery 3.3.1</strong></td>
                    <td>JavaScript library</td>
                </tr>
                <tr>
                    <td><strong>Git 2.17.0</strong></td>
                    <td>versions control</td>
                </tr>
            </table>
        </div>
    </div>
</div>
</body>
</html>