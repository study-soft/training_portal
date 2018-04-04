<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="hasRole('ROLE_TEACHER')">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="/teacher">
            <img src="/resources/training-portal-favicon.png" width="30" height="35"> Training portal
        </a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
            <%--suppress XmlDuplicatedId --%>
        <div id="navbarSupportedContent" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/teacher">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/teacher/quizzes">Quizzes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/teacher/groups">Groups</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/teacher/students">Students</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/teacher/results">Results</a>
                </li>
            </ul>
            <ul class="navbar-nav justify-content-end">
                <li class="nav-item">
                        <%--suppress XmlDuplicatedId --%>
                    <a id="logout" href="/logout" class="nav-link">Log out<i
                            class="fa fa-sign-out nav-link nav-icon inline"></i></a>
                </li>
            </ul>
        </div>
    </nav>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_STUDENT')">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="/student">
            <img src="/resources/training-portal-favicon.png" width="30" height="35"> Training portal
        </a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
            <%--suppress XmlDuplicatedId --%>
        <div id="navbarSupportedContent" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/student">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/quizzes">Quizzes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/teachers">Teachers</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/student/results">Results</a>
                </li>
            </ul>
            <ul class="navbar-nav justify-content-end">
                <li class="nav-item">
                        <%--suppress XmlDuplicatedId --%>
                    <a id="logout" href="/quiz-passing-logout" class="nav-link">Log out<i
                            class="fa fa-sign-out nav-link nav-icon inline"></i></a>
                </li>
            </ul>
        </div>
    </nav>
</sec:authorize>
