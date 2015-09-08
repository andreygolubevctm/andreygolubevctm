<%@ tag description="Loading of the Health Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty param.cover || not empty param.situation || not empty param.health_location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>

<%-- Force this to be confirmation because it is set by a param value and might change. This is a safety decision because if it is something else, bad things happen. --%>
<c:set var="pageAction">
	<c:choose>
		<c:when test="${pageContext.request.servletPath == '/health_confirmation.jsp'}">
			confirmation
		</c:when>
		<c:otherwise>
			<c:out value="${param.action}"/>
		</c:otherwise>
	</c:choose>
</c:set>

<c:set var="utm_source">
	<c:choose>
		<c:when test="${not empty param.utm_source}">
			<c:out value="${param.utm_source}"/>
		</c:when>
		<c:when test="${not empty data['health/tracking/sourceid']}">
			<c:out value="${data['health/tracking/sourceid']}"/>
		</c:when>
</c:choose>
</c:set>
<c:set var="utm_medium">
	<c:choose>
		<c:when test="${not empty param.utm_medium}">
			<c:out value="${param.utm_medium}"/>
		</c:when>
		<c:when test="${not empty data['health/tracking/medium']}">
			<c:out value="${data['health/tracking/medium']}"/>
		</c:when>
	</c:choose>
</c:set>
<c:set var="utm_campaign">
	<c:choose>
		<c:when test="${not empty param.utm_campaign}">
			<c:out value="${param.utm_campaign}"/>
		</c:when>
		<c:when test="${not empty data['health/tracking/cid']}">
			<c:out value="${data['health/tracking/cid']}"/>
		</c:when>
	</c:choose>
</c:set>
{
	isCallCentreUser: <c:out value="${not empty callCentre}"/>,
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	journeyStage: "<c:out value="${data['health/journey/stage']}"/>",
	pageAction: '<c:out value="${pageAction}"/>',
	previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
	isNewQuote: <c:out value="${isNewQuote eq true}" />,
	productId: '<c:out value="${data.health.application.productId}" />',
	loadProductId: '<c:out value="${param.productId}"/>',
	loadProductTitle: '<c:out value="${param.productTitle}"/>',
	userId: '<c:out value="${authenticatedData.login.user.uid}" />',
	utm_source: '<c:out value="${utm_source}" />',
	utm_medium: '<c:out value="${utm_medium}" />',
	utm_campaign: '<c:out value="${utm_campaign}" />',
	liveChat: {
		config: {
			lpServer			: "server.lon.liveperson.net",
			lpTagSrv			: "sr1.liveperson.net",
			lpNumber			: "1563103",
			deploymentID		: "1",
			//pluginsConsoleDebug will suppress debug console logs being output for our liveperson plugins.
			pluginsConsoleDebug	: false
		},
		instance: {
			brand	: '${pageSettings.getBrandCode()}',
			vertical: 'Health',
			unit	: 'health-insurance-sales',
			button	: 'chat-health-insurance-sales'
		},
		enabled: <c:out value="${pageSettings.getSetting('liveChatEnabled') eq 'Y'}"/>
	},
	content:{
		callCentreNumber: '${callCentreNumber}',
		callCentreNumberApplication		: '${callCentreNumberApplication}',
		callCentreHelpNumber			: '${callCentreHelpNumber}',
		callCentreHelpNumberApplication	: '${callCentreHelpNumberApplication}'
	},
	emailBrochures: {
		enabled: <c:out value="${pageSettings.getSetting('emailBrochuresEnabled') eq 'Y'}"/>
	},
	alternatePricing: <health:alternate_pricing_json />
}