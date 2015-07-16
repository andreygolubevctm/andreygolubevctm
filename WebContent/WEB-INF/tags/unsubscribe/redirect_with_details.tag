<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Redirects back to unsubscribe.jsp with details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="unsubscribeService" class="com.ctm.services.UnsubscribeService" scope="request"/>

<c:catch var="error">
    <c:set var="unsubscribe"
           value="${unsubscribeService.getUnsubscribeDetails(param.vertical , fn:substring(param.unsubscribe_email, 0, 256),param.email, false, pageSettings, pageContext.getRequest())}"
           scope="session"/>

    <%-- #WHITELABEL TODO: support meerkat brand--%>
    <c:if test="${fn:toUpperCase(param.brand) == 'MEER'}">
        <c:set var="ignore">
            ${unsubscribe.setMeerkat(true)}
            <c:if test="${empty param.vertical}">
                ${unsubscribe.setVertical('competition')}
            </c:if>
        </c:set>
    </c:if>
</c:catch>

<c:if test="${not empty error}">
    <c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
        <c:param name="page" value="${pageContext.request.servletPath}"/>
        <c:param name="message" value="Failed to check email" />
        <c:param name="description" value="${error}"/>
    </c:import>
</c:if>

<%-- Redirect --%>
<go:log level="DEBUG">redirect to ${pageSettings.getBaseUrl()}unsubscribe.jsp"</go:log>
<c:redirect url="${pageSettings.getBaseUrl()}unsubscribe.jsp"/>