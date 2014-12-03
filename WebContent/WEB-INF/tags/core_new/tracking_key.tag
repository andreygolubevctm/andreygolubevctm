<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--

This tag populates the form with a hidden element containing a
reference to the trackingKey.

The value is utilised in core:trackingKey.js to include this value
in ALL calls to tracking.

--%>

<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<go:setData dataVar="data" xpath="${journeyVertical}/currentJourney" value="${journeyRef}" />

<field:hidden xpath="${journeyVertical}/trackingKey" defaultValue="${data[journeyVertical].trackingKey}" />