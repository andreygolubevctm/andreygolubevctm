<%@ tag description="Loading of the Travel Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty param.cover || not empty param.situation || not empty param.location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>
{
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	journeyStage: "<c:out value="${data['travel/journey/stage']}"/>",
	pageAction: '<c:out value="${param.action}"  escapeXml="true"/>',
	previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
	isNewQuote: <c:out value="${isNewQuote eq true}" />,
	productId: '<c:out value="${data.travel.application.productId}" />',
	userId: '<c:out value="${authenticatedData.login.user.uid}" />',
	countrySelectionDefaults: '<c:out value="${data.travel.destination}" />',
	navMenu: {
		type: 'offcanvas',
		direction: 'right'
	},
	ctmh: {
		fBase: "${pageSettings.getSetting("handoverRootUrl")}${pageSettings.getContextFolder()}"
	}
}