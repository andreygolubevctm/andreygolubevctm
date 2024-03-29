<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.unsubscribe')}" />

<c:set var="json" value='{"error": "Oops, something seems to have gone wrong! We couldn\'t unsubscribe you. Please try again."}'/>
<c:catch var="error">
    <jsp:useBean id="unsubscribe" class="com.ctm.web.core.model.Unsubscribe" scope="session"/>
    <jsp:useBean id="unsubscribeService" class="com.ctm.web.core.services.UnsubscribeService" scope="request"/>
    <settings:setVertical verticalCode="GENERIC"/>
    <c:choose>
        <c:when test="${unsubscribe.getEmailDetails().isValid()}">
            <c:set var="ignore" value="${unsubscribeService.unsubscribe(pageSettings, unsubscribe)}" />
            <agg_v1:write_stamp
                    action="toggle_marketing"
                    vertical="${fn:toLowerCase(unsubscribe.getVertical())}"
                    value="N"
                    target="${unsubscribe.getEmailDetails().getEmailAddress()}"
                    comment="UNSUBSCRIBE_PAGE"/>
            <c:set var="json" value="{}"/>
        </c:when>
        <c:otherwise>
            <% response.setStatus(500); /* Internal Server Error */ %>
        </c:otherwise>
    </c:choose>
</c:catch>
<c:if test="${not empty error}">
    <% response.setStatus(500); /* Internal Server Error */ %>
    ${logger.error('Failed to unsubscribe. {}', log:kv('emailAddress', unsubscribe.emailDetails.emailAddress) , error)}
</c:if>
<c:out value="${json}" escapeXml="false"/>