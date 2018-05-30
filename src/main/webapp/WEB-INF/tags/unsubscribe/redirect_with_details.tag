<%@ tag import="java.time.LocalDateTime" %>
<%@ tag import="com.ctm.web.core.model.session.SessionData" %>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Redirects back to unsubscribe.jsp with details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('tag.unsubcribe.redirect_with_details')}" />

<jsp:useBean id="unsubscribeService" class="com.ctm.web.core.services.UnsubscribeService" scope="request"/>
<c:set var="brandId" value="0"/>

<c:catch var="error">
    <%-- #WHITELABEL: support meerkat brand--%>
    <c:if test="${fn:toUpperCase(param.brand) == 'MEER'}">
        <c:set var="brandId" value="2"/>
    </c:if>

    <c:set var="unsubscribe"
           value="${unsubscribeService.getUnsubscribeDetails(param.vertical, brandId, fn:substring(param.unsubscribe_email, 0, 256), param.email, false, pageSettings, param.token)}"
           scope="session"/>

    <% SessionData.markSessionForCommit(request); %>

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
<c:set var="redirectUrl" value='${pageSettings.getBaseUrl()}unsubscribe.jsp' />
${logger.debug('Redirecting user {}', log:kv('redirectionUrl', redirectUrl))}
<c:redirect url="${redirectUrl}" />