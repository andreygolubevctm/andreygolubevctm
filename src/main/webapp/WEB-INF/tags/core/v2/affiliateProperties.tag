<%@ tag description="Inpiut" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Get reference to current journey xpath root --%>
<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<%-- If affiliate properties already exists then render them as hidden inputs --%>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate_id" />
<c:if test="${not empty data[fieldXpath]}">
	<field_v1:hidden xpath="${fieldXpath}" />
</c:if>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate_campaign" />
<c:if test="${not empty data[fieldXpath]}">
	<field_v1:hidden xpath="${fieldXpath}" />
</c:if>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate_clickref" />
<c:if test="${not empty data[fieldXpath]}">
	<field_v1:hidden xpath="${fieldXpath}" />
</c:if>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate_cd1" />
<c:if test="${not empty data[fieldXpath]}">
	<field_v1:hidden xpath="${fieldXpath}" />
</c:if>