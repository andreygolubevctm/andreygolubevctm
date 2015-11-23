<%@ tag description="Business Activity" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="quoteService" class="com.ctm.web.core.services.QuoteService" scope="application" />
<%--

This tag populates the form with a hidden element containing a
reference to the current split test. Multiple split tests can be
run so ensure you are aware of what split test references you
need to include in your tests.

The value is utilised in core:splitTest.js

Usage: to confirm whether split test 2 is applicable

	meerkat.modules.splitTest.isActive(2);

--%>

<%-- Retrieve the current split tests from backend --%>
<jsp:useBean id="splitTests" class="com.ctm.web.core.services.tracking.SplitTestService" />
<c:set var="journeyIn" value="${splitTests.getJourney(pageContext.getRequest(), data.current.transactionId)}" />
<c:set var="journey">
	<c:if test="${not empty journeyIn}">${journeyIn}</c:if>
</c:set>

<%-- for Health V2 A/B testing --%>
<c:if test="${isHealthV2 eq true}"><c:set var="journey" value="2" /></c:if>

<%-- Get reference to current journey xpath root --%>
<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<c:set var="xpath" value="${journeyVertical}/currentJourney" />
<c:if test="${not empty journey}">
	<c:set var="ignore">${quoteService.writeSingle(data.current.transactionId, xpath, journey)}</c:set>
</c:if>
<field:hidden xpath="${xpath}" defaultValue="${journey}" />