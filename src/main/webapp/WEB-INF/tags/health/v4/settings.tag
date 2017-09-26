<%@ tag description="Loading of the Health Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty param.cover || not empty param.situation  || not empty param.health_location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>

<%-- Moved from choices.tag --%>
<c:set var="xpathSituation" value="${pageSettings.getVerticalCode()}/situation" />
<c:set var="xpathBenefitsExtras" value="${pageSettings.getVerticalCode()}/benefits/benefitsExtras" />
<c:set var="cover" value="${data[xpathSituation].healthCvr}" />
<c:set var="state" value="${data[xpathSituation].state}" />
<c:set var="situation" value="${data[xpathSituation].healthSitu}" />

<%-- Test if the data is already set. Advance the user if Params are filled. Preload will override any params --%>
<c:if test="${empty data[xpathSituation].healthCvr && empty data[xpathSituation].healthSitu}">

	<c:set var="cover"><c:out value="${param.cover}" escapeXml="true" /></c:set>
	<c:set var="param_location">
		<c:choose>
			<c:when test="${not empty param.postcode_suburb_location}"><c:out value="${param.postcode_suburb_location}" escapeXml="true" /></c:when>
			<c:when test="${not empty param.postcode_suburb_mobile_location}"><c:out value="${param.postcode_suburb_mobile_location}" escapeXml="true" /></c:when>
			<c:when test="${not empty param.health_location}"><c:out value="${param.health_location}" escapeXml="false" /></c:when>
		</c:choose>
	</c:set>
	<c:set var="situation"><c:out value="${param.situation}" escapeXml="true" /></c:set>
	<c:set var="state"><c:out value="${param.state}" escapeXml="true" /></c:set>

	<%-- Data Bucket --%>
	<go:setData dataVar="data" xpath="${xpathSituation}/healthCvr" value="${cover}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/location" value="${param_location}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/state" value="${state}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/healthSitu" value="${situation}" />
	<go:setData dataVar="data" xpath="${xpathBenefits}/healthSitu" value="${situation}" />
</c:if>


<%-- Only ajax-fetch and update benefits if situation is defined in a param (e.g. from brochureware). No need to update if new quote or load quote etc. --%>
<c:set var="performHealthChoicesUpdate" value="false" />
<c:if test="${not empty situation or (not empty param.preload and empty data[xpathBenefitsExtras])}">
	<c:set var="performHealthChoicesUpdate" value="true" />
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
<c:set var="reviewEdit">
	<c:choose>
		<c:when test="${not empty param.reviewedit}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
<c:set var="defaultToHealthQuote"><content:get key="makeHealthQuoteMainJourney" /></c:set>
<c:set var="defaultToHealthApply"><content:get key="makeHealthApplyMainJourney" /></c:set>

<c:set var="fund1800NumberActive">
	<c:set var="temp"><content:get key="fundCallCentreNumber" /></c:set>
	<c:choose>
		<c:when test="${empty temp or temp eq 'n'}">false</c:when>
		<c:otherwise>true</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${fund1800NumberActive eq 'true'}">
	<c:set var="funds" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "fundCallCentreNumber")}' />
	<c:set var="fund1800Numbers"></c:set>
	<c:forEach items="${funds.getSupplementary()}" var="fund" varStatus="loop" >
		<c:set var="fund1800Numbers">${fund1800Numbers}<c:if test="${loop.count > 1}">,</c:if>${fund.getSupplementaryKey().toLowerCase()}:"${fund.getSupplementaryValue()}"</c:set>
	</c:forEach>
</c:if>

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

<c:set var="openingHoursTimeZone"><content:get key="openingHoursTimeZone" /></c:set>

<competition:octoberCompSettings />
<health_v1:dual_pricing_settings />
<health_v4:pyrr_campaign_settings />
<agg_v1:remember_me_settings vertical="health" />
<agg_v1:popular_products_settings vertical="health" />
{
	octoberComp: <c:out value="${octoberComp}" />,
	isCallCentreUser: <c:out value="${not empty callCentre}"/>,
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	journeyStage: "<c:out value="${data['health/journey/stage']}"/>",
	pageAction: '<c:out value="${pageAction}"/>',
	reviewEdit: <c:out value="${reviewEdit}"/>,
	previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
	isNewQuote: <c:out value="${isNewQuote eq true}" />,
	productId: '<c:out value="${data.health.application.productId}" />',
	loadProductId: '<c:out value="${param.productId}"/>',
	loadProductTitle: '<c:out value="${param.productTitle}"/>',
	userId: '<c:out value="${authenticatedData.login.user.uid}" />',
	utm_source: '<c:out value="${utm_source}" />',
	utm_medium: '<c:out value="${utm_medium}" />',
	utm_campaign: '<c:out value="${utm_campaign}" />',
	isDefaultToHealthQuote: ${defaultToHealthQuote},
    isDefaultToHealthApply: ${defaultToHealthApply},
	isTaxTime: '<content:get key="taxTime"/>',
	isDualPricingActive: ${isDualPriceActive},
	isPyrrActive: ${isPyrrActive},
	<jsp:useBean id="healthApplicationService" class="com.ctm.web.health.services.HealthApplicationService"/>
	<c:set var="providerList" value="${miscUtils:convertToJson(healthApplicationService.getAllProviders(pageSettings.getBrandId()))}"/>
	navMenu: {
		type: 'offcanvas',
		direction: 'right'
	},
	providerList: ${providerList},
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
		callCentreHelpNumber			: '${callCentreHelpNumber}'
	},
	callbackPopup: {
		enabled: <c:out value="${pageSettings.getSetting('callbackPopupEnabled') eq 'Y'}"/>,
		timeout: <c:out value="${pageSettings.getSetting('callbackPopupTimeout')}"/>,
		timeoutMouseEnabled: <c:out value="${pageSettings.getSetting('callbackPopupTimeoutMouseEnabled') eq 'Y'}"/>,
		timeoutKeyboardEnabled: <c:out value="${pageSettings.getSetting('callbackPopupTimeoutKeyEnabled') eq 'Y'}"/>,
		timeoutStepEnabled: <c:out value="${pageSettings.getSetting('callbackPopupTimeoutStepEnabled') eq 'Y'}"/>,
		steps: '<c:out value="${pageSettings.getSetting('callbackPopupValidSteps')}"/>',
		position: '<c:out value="${pageSettings.getSetting('callbackPopupPosition')}"/>'
	},
	emailBrochures: {
		enabled: <c:out value="${pageSettings.getSetting('emailBrochuresEnabled') eq 'Y'}"/>
	},
	<c:if test="${not empty worryFreePromo35 or not empty worryFreePromo36}">
	competitionActive : true,
	</c:if>
	choices: {
		cover: '${cover}',
		situation: '${situation}',
		benefits: '${_benefits}',
		state: '${state}',
		performHealthChoicesUpdate: ${performHealthChoicesUpdate}
	},
	<c:if test="${not empty data.health.simples}">simplesCheckboxes: <c:out value="${go:XMLtoJSON(data.health.simples)}" escapeXml="false" />,</c:if>
	<c:if test="${not empty data.health.application.dependants}">dependants:  <c:out value="${go:XMLtoJSON(data.health.application.dependants)}" escapeXml="false" />,</c:if>
	alternatePricing: <health_v1:alternate_pricing_json />,
	bsbServiceURL : "<content:get key="bsbValidationServiceUrl" />",
	ccOpeningHoursText : "<content:get key="ccHoursText" />"
	<c:if test="${fund1800NumberActive eq 'true'}">
	,fund1800s : {
		active : ${fund1800NumberActive},
		phones : {${fund1800Numbers}}
	}
	</c:if>
	,openingHoursTimeZone : '${openingHoursTimeZone}',
	isRememberMe: ${isRememberMe},
	showPopularProducts: ${showPopularProducts}
}
