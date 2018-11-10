<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="localDateTime" uri="/WEB-INF/custom_tags/formatLocalDateTime" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><spring:message code="title.quizzes"/></title>
    <c:import url="../fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("button:has(i[class='fa fa-close'])").click(function (event) {
                event.preventDefault();
                let quizId = $(this).val();
                let button = $(this);
                $.ajax({
                    type: "POST",
                    url: "/student/quizzes/" + quizId + "/close",
                    success: function () {
                        window.scrollTo(0, 0);
                        let selectedRow = button.parents("tr");
                        let quizName = selectedRow.children().first().find("a").text();
                        let copiedSelectedRow = selectedRow.clone();
                        selectedRow.remove();
                        let passedQuizzes = $("#passedQuizzes");
                        if (passedQuizzes.find("tr").length === 1) {
                            passedQuizzes.after('<div class="row no-gutters align-items-center highlight-primary">\n' +
                                '                <div class="col-auto mr-3">\n' +
                                '                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"\n' +
                                '                         width="25" height="25">\n' +
                                '                </div>\n' +
                                '                <div class="col">\n' +
                                '                    <spring:message code="quiz.quizzes.passed.not"/>\n' +
                                '                </div>\n' +
                                '            </div>');
                            passedQuizzes.remove();
                        }
                        alert('<spring:message code="quiz.quiz"/> \'' +
                            quizName.trim() + '\' <spring:message code="quiz.successfully.closed"/>');
                        let closedQuizzesBody = $("#closedQuizzes").find("tbody");
                        if (closedQuizzesBody.length === 0) {
                            let info = $("#noClosedQuizzesInfo");
                            info.after(
                                '<table id="closedQuizzes" class="table">\n' +
                                '    <thead>\n' +
                                '    <tr>\n' +
                                '        <th style="width: 25%"><spring:message code="quiz.name"/></th>\n' +
                                '        <th style="width: 10%"><spring:message code="quiz.questions"/></th>\n' +
                                '        <th style="width: 8%"><spring:message code="quiz.score"/></th>\n' +
                                '        <th style="width: 20%"><spring:message code="quiz.submitted"/></th>\n' +
                                '        <th style="width: 37%"><spring:message code="quiz.author"/></th>\n' +
                                '    </tr>\n' +
                                '    </thead>\n' +
                                '    <tbody>\n' +
                                '    </tbody>\n' +
                                '</table>');
                            info.remove();
                            closedQuizzesBody = $("#closedQuizzes").find("tbody");
                        }
                        closedQuizzesBody.append(copiedSelectedRow);
                        closedQuizzesBody.find("td").last().remove();
                    }
                });
            });

            $("input[type=search]").on("keyup", function () {
                let value = $(this).val().toLowerCase();
                $("tbody tr").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</head>
<body>
<c:import url="../fragment/navbar.jsp"/>
<div class="container">
    <h2><spring:message code="quiz.quizzes"/></h2>
    <div class="input-group">
        <input type="search" class="col-sm-4 form-control" placeholder="<spring:message code="search"/>...">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fa fa-search"></i></span>
        </div>
    </div>
    <h4><spring:message code="quiz.quizzes.opened"/></h4>
    <c:choose>
        <c:when test="${empty openedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.quizzes.opened.not"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                <tr>
                    <th style="width: 25%"><spring:message code="quiz.name"/></th>
                    <th style="width: 10%"><spring:message code="quiz.questions"/></th>
                    <th style="width: 8%"><spring:message code="quiz.score"/></th>
                    <th style="width: 20%"><spring:message code="quiz.submitted"/></th>
                    <th style="width: 37%"><spring:message code="quiz.author"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${openedQuizzes}" var="openedQuiz">
                    <tr>
                        <td>
                            <a href="/student/quizzes/${openedQuiz.quizId}">
                                <c:out value="${openedQuiz.quizName}"/>
                            </a>
                        </td>
                        <td>${openedQuiz.questionsNumber}</td>
                        <td>${openedQuiz.score}</td>
                        <td><localDateTime:format value="${openedQuiz.submitDate}"/></td>
                        <td>${openedQuiz.authorName}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <h4><spring:message code="quiz.quizzes.passed"/></h4>
    <c:choose>
        <c:when test="${empty passedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.quizzes.passed.not"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table id="passedQuizzes" class="table">
                <thead>
                <tr>
                    <th style="width: 25%"><spring:message code="quiz.name"/></th>
                    <th style="width: 10%"><spring:message code="quiz.questions"/></th>
                    <th style="width: 8%"><spring:message code="quiz.score"/></th>
                    <th style="width: 20%"><spring:message code="quiz.submitted"/></th>
                    <th style="width: 25%"><spring:message code="quiz.author"/></th>
                    <th style="width: 12%"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${passedQuizzes}" var="quiz">
                    <tr>
                        <td>
                            <a href="/student/quizzes/${quiz.quizId}">
                                <c:out value="${quiz.quizName}"/>
                            </a>
                        </td>
                        <td>${quiz.questionsNumber}</td>
                        <td>${quiz.score}</td>
                        <td><localDateTime:format value="${quiz.submitDate}"/></td>
                        <td>${quiz.authorName}</td>
                        <td>
                            <button type="submit" value="${quiz.quizId}" class="success-button">
                                <i class="fa fa-close"></i> <spring:message code="quiz.result.close"/>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <h4><spring:message code="quiz.quizzes.closed"/></h4>
    <c:choose>
        <c:when test="${empty closedQuizzes}">
            <div class="row no-gutters align-items-center highlight-primary">
                <div class="col-auto mr-3">
                    <img src="${pageContext.request.contextPath}/resources/icon-primary.png"
                         width="25" height="25">
                </div>
                <div class="col">
                    <spring:message code="quiz.quizzes.closed.not"/>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <table id="closedQuizzes" class="table">
                <thead>
                <tr>
                    <th style="width: 25%"><spring:message code="quiz.name"/></th>
                    <th style="width: 10%"><spring:message code="quiz.questions"/></th>
                    <th style="width: 8%"><spring:message code="quiz.score"/></th>
                    <th style="width: 20%"><spring:message code="quiz.submitted"/></th>
                    <th style="width: 37%"><spring:message code="quiz.author"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${closedQuizzes}" var="quiz">
                    <tr>
                        <td>
                            <a href="/student/quizzes/${quiz.quizId}">
                                <c:out value="${quiz.quizName}"/>
                            </a>
                        </td>
                        <td>${quiz.questionsNumber}</td>
                        <td>${quiz.score}</td>
                        <td><localDateTime:format value="${quiz.submitDate}"/></td>
                        <td>${quiz.authorName}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <button class="btn btn-primary" onclick="window.history.go(-1);"><spring:message code="back"/></button>
</div>
<br>
</body>
</html>
