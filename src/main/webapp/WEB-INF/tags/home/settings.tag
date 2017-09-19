<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- SET ESCAPEXML'd VARIABLES HERE FROM BROCHUREWARE --%>

<%-- VARIABLES --%>
<c:set var="octoberComp" scope="application" value="${false}"/>
<c:set var="octoberCompDB"><content:get key="octoberComp" /></c:set>
<c:if test="${pageSettings.getBrandCode() eq 'ctm' && octoberCompDB eq 'Y'}">
	<c:set var="octoberComp" scope="application" value="${true}"/>
</c:if>

<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${false}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>

<c:if test="${empty param.landlord}">
	<c:set var="landlord" scope="request" value="${false}" />
</c:if>

<c:set var="priceDisplayMode"><content:get key="resultsDisplayMode" /></c:set>
<c:if test="${not empty param.display and (param.display eq 'price' or param.display eq 'features')}">
	<c:set var="priceDisplayMode" value="${param.display}"/>
</c:if>

<c:set var="defaultToHomeQuote"><content:get key="makeHomeQuoteMainJourney" /></c:set>
<home:lead_capture_settings />
{
	isLandlord: <c:out value="${landlord}" />,
	isCallCentreUser: <c:out value="${not empty callCentre}"/>,
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	brochureValues: {
		coverType: '<c:out value="${param.coverType}"/>',
		ownProperty: '<c:out value="${param.ownProperty}"/>'
	},
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
