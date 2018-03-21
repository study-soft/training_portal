<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<sec:authentication var="principal" property="principal.username"/>
<sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin"/>
<sec:authorize access="hasRole('ROLE_PM')" var="isPM"/>
<sec:authorize access="hasRole('ROLE_LM')" var="isLM"/>
<sec:authorize access="hasRole('ROLE_SE')" var="isSE"/>
