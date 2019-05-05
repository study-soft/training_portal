<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="text-center">
    <a id="en" href="javascript:void(0);">
        <img src="${pageContext.request.contextPath}/resources/icons/united-states.png"
             width="20" height="20" alt="English">
        <spring:message code="navbar.language.english"/>
    </a>&nbsp;&nbsp;&nbsp;
    <a id="ru" href="#">
        <img src="${pageContext.request.contextPath}/resources/icons/russia.png"
             width="20" height="20" alt="Russian">
        <spring:message code="navbar.language.russian"/>
    </a>&nbsp;&nbsp;&nbsp;
    <a id="uk" href="javascript:void(0);">
        <img src="${pageContext.request.contextPath}/resources/icons/ukraine.png"
             width="20" height="20" alt="Ukrainian">
        <spring:message code="navbar.language.ukrainian"/>
    </a>
</div>
<br>
<div class="row justify-content-center">
    <div class="col-auto">
        <div class="media">
            <img class="mr-2" style="margin-top: 15px"
                 src="${pageContext.request.contextPath}/resources/icons/training-portal-favicon.png"
                 width="30" height="35" alt="<spring:message code="login.training.portal"/>">
            <div class="media-body">
                <h2>
                    <a style="color: inherit; text-decoration: none;"
                       href="${pageContext.request.contextPath}/"><spring:message code="login.training.portal"/></a>
                </h2>
            </div>
        </div>
    </div>
</div>