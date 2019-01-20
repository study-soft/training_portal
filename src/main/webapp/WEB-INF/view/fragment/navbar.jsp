<%--suppress XmlDuplicatedId --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<sec:authorize access="isAuthenticated()" var="isAutenticated"/>
<sec:authorize access="hasRole('ROLE_TEACHER')">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/teacher">
            <img src="${pageContext.request.contextPath}/resources/icons/training-portal-favicon.png"
                 width="30" height="35" alt="Training portal"> <spring:message code="navbar.training.portal"/>
        </a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="navbarSupportedContent" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/teacher">
                        <i class="fa fa-home"></i> <spring:message code="navbar.home"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/teacher/quizzes">
                        <i class="fa fa-book"></i> <spring:message code="navbar.quizzes"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/teacher/groups">
                        <i class="fa fa-group"></i> <spring:message code="navbar.groups"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/teacher/students">
                        <i class="fa fa-graduation-cap"></i> <spring:message code="navbar.students"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/teacher/results">
                        <i class="fa fa-signal"></i> <spring:message code="navbar.results"/>
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav justify-content-end">
                <li class="nav-item dropdown bg-dark">
                    <a class="nav-link dropdown-toggle" href="javascript:void(0);" id="navbarDropdown" role="button"
                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fa fa-flag"></i> <spring:message code="navbar.language"/>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a id="en" class="dropdown-item" href="javascript:void(0);">
                            <img src="${pageContext.request.contextPath}/resources/icons/united-states.png"
                                 width="20" height="20" alt="English">
                            <spring:message code="navbar.language.english"/>
                        </a>
                        <a id="ru" class="dropdown-item" href="javascript:void(0);">
                            <img src="${pageContext.request.contextPath}/resources/icons/russia.png"
                                 width="20" height="20" alt="Russian">
                            <spring:message code="navbar.language.russian"/>
                        </a>
                        <a id="uk" class="dropdown-item" href="javascript:void(0);">
                            <img src="${pageContext.request.contextPath}/resources/icons/ukraine.png"
                                 width="20" height="20" alt="Ukrainian">
                            <spring:message code="navbar.language.ukrainian"/>
                        </a>
                    </div>
                </li>
                <c:if test="${isAutenticated}">
                    <li class="nav-item dropdown bg-dark">
                        <a class="nav-link dropdown-toggle" href="javascript:void(0);" id="navbarDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-user"></i> <sec:authentication property="principal.username"/>
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/teacher/edit-profile">
                                <i class="fa fa-cog"></i> <spring:message code="navbar.settings"/>
                            </a>
                            <a id="logout" class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fa fa-sign-out"></i> <spring:message code="navbar.logout"/>
                            </a>
                        </div>
                    </li>
                </c:if>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/help" class="nav-link">
                        <i class="fa fa-question-circle"></i> <spring:message code="navbar.help"/>
                    </a>
                </li>
            </ul>
        </div>
    </nav>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_STUDENT')">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/student">
            <img src="${pageContext.request.contextPath}/resources/icons/training-portal-favicon.png"
                 width="30" height="35"> <spring:message code="navbar.training.portal"/>
        </a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="navbarSupportedContent" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/student">
                        <i class="fa fa-home"></i> <spring:message code="navbar.home"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/student/quizzes">
                        <i class="fa fa-book"></i> <spring:message code="navbar.quizzes"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/student/teachers">
                        <i class="fa fa-group"></i> <spring:message code="navbar.teachers"/>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/student/results">
                        <i class="fa fa-signal"></i> <spring:message code="navbar.results"/>
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav justify-content-end align-items-center">
                <li class="nav-item dropdown bg-dark">
                    <a class="nav-link dropdown-toggle" href="javascript:void(0);" id="navbarDropdown" role="button"
                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fa fa-flag"></i> <spring:message code="navbar.language"/>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a id="en" class="dropdown-item" href="javascript:void(0);">
                            <img src="${pageContext.request.contextPath}/resources/icons/united-states.png"
                                 width="20" height="20" alt="English">
                            <spring:message code="navbar.language.english"/>
                        </a>
                        <a id="ru" class="dropdown-item" href="javascript:void(0);">
                            <img src="${pageContext.request.contextPath}/resources/icons/russia.png"
                                 width="20" height="20" alt="Russian">
                            <spring:message code="navbar.language.russian"/>
                        </a>
                        <a id="uk" class="dropdown-item" href="javascript:void(0);">
                            <img src="${pageContext.request.contextPath}/resources/icons/ukraine.png"
                                 width="20" height="20" alt="Ukrainian">
                            <spring:message code="navbar.language.ukrainian"/>
                        </a>
                    </div>
                </li>
                <c:if test="${isAutenticated}">
                    <li class="nav-item dropdown bg-dark">
                        <a class="nav-link dropdown-toggle" href="javascript:void(0);" id="navbarDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-user"></i> <sec:authentication property="principal.username"/>
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/student/edit-profile">
                                <i class="fa fa-cog"></i> <spring:message code="navbar.settings"/>
                            </a>
                            <a id="logout" class="dropdown-item" href="${pageContext.request.contextPath}/quiz-passing-logout">
                                <i class="fa fa-sign-out"></i> <spring:message code="navbar.logout"/>
                            </a>
                        </div>
                    </li>
                </c:if>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/help" class="nav-link">
                        <i class="fa fa-question-circle"></i> <spring:message code="navbar.help"/>
                    </a>
                </li>
            </ul>
        </div>
    </nav>
</sec:authorize>
