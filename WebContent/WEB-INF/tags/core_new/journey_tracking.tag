<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--

This tag populates the form with a hidden element containing a
reference to the current split test. The default is 1.

The value is utilised in core:tracking.js to include this value
in ALL calls to tracking.

--%>

<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<c:set var="journeyRef" value="1" />
<c:if test="${not empty param.j}">
	<c:set var="journeyRef" value="${param.j}" />
</c:if>

<go:setData dataVar="data" xpath="${journeyVertical}/currentJourney" value="${journeyRef}" />

<field:hidden xpath="${journeyVertical}/currentJourney" defaultValue="${journeyRef}" />