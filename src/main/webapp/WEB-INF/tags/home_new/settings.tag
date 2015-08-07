<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- SET ESCAPEXML'd VARIABLES HERE FROM BROCHUREWARE --%>

<%-- VARIABLES --%>
<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${false}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>
<c:set var="priceDisplayMode" value="price"/>
<c:if test="${param.display eq 'features'}">
	<c:set var="priceDisplayMode" value="features"/>
</c:if>
<c:set var="defaultToHomeQuote"><content:get key="makeHomeQuoteMainJourney" /></c:set>

{
	isCallCentreUser: <c:out value="${not empty callCentre}"/>,
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	brochureValues: {},
	journeyStage: "<c:out value="${data['home/journey/stage']}"/>",
	pageAction: '<c:out value="${param.action}"/>',
	previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
	isNewQuote: <c:out value="${isNewQuote eq true}" />,
	userId: '<c:out value="${authenticatedData.login.user.uid}" />',
	isDefaultToHomeQuote: ${defaultToHomeQuote},
	content:{
		callCentreNumber: '${callCentreNumber}',
		callCentreHelpNumber: '${callCentreHelpNumber}'
	},
	navMenu: {
		type: 'offcanvas',
		direction: 'right'
	},
	resultOptions: {
		displayMode: "<c:out value="${priceDisplayMode}" />"
	},
	commencementDate : '${data.home.options.commencementDate}'
}