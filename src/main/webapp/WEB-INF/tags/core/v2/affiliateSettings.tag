<%@ tag description="Inpiut" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Get reference to current journey xpath root --%>
<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<%-- If affiliate data exists then create affiliate properties --%>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate/id" />

<c:if test="${not empty data[fieldXpath]}">
	affiliate_id: "<c:out value="${data[fieldXpath]}"/>",
	affiliate_details: <content:get key="affiliateDetails" suppKey="${data[fieldXpath]}"/>,
</c:if>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate/campaign" />
<c:if test="${not empty data[fieldXpath]}">
	affiliate_campaign: "<c:out value="${data[fieldXpath]}"/>",
</c:if>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate/clickref" />
<c:if test="${not empty data[fieldXpath]}">
	affiliate_clickref: "<c:out value="${data[fieldXpath]}"/>",
</c:if>
<c:set var="fieldXpath" value="${journeyVertical}/affiliate/cd1" />
<c:if test="${not empty data[fieldXpath]}">
	affiliate_cd1: "<c:out value="${data[fieldXpath]}"/>",
</c:if>