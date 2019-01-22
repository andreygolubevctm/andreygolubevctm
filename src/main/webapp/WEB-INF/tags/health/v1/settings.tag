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
<c:set var="healthCvr" value="${data[xpathSituation].healthCvr}" />
<c:set var="state" value="${data[xpathSituation].state}" />
<c:set var="healthSitu" value="${data[xpathSituation].healthSitu}" />
<c:set var="simplesHealthReformMessaging" scope="request"><content:get key="simplesHealthReformMessaging" /></c:set>

<%-- Only ajax-fetch and update benefits if situation is defined in a param (e.g. from brochureware). No need to update if new quote or load quote etc. --%>
<c:set var="performHealthChoicesUpdate" value="false" />
<c:if test="${not empty param.situation or (not empty param.preload and empty data[xpathBenefitsExtras])}">
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
<c:set var="defaultToHealthQuote"><content:get key="makeHealthQuoteMainJourney" /></c:set>
<c:set var="defaultToHealthApply"><content:get key="makeHealthApplyMainJourney" /></c:set>

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

	<c:set var="benefitsContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "benefitsContent")}' />

	<c:set var="hospitalFamilyYoung" value="${benefitsContent.getSupplementaryValueByKey('hospitalFamilyYoung')}" />
	<c:set var="hospitalFamilyOlder" value="${benefitsContent.getSupplementaryValueByKey('hospitalFamilyOlder')}" />
	<c:set var="hospitalFamilyHelp" value="${benefitsContent.getSupplementaryValueByKey('hospitalFamilyHelp')}" />
	<c:set var="hospitalFamilyDisabled" value="${benefitsContent.getSupplementaryValueByKey('hospitalFamilyDisabled')}" />

	<c:set var="hospitalSettledFamilyYoung" value="${benefitsContent.getSupplementaryValueByKey('hospitalSettledFamilyYoung')}" />
	<c:set var="hospitalSettledFamilyOlder" value="${benefitsContent.getSupplementaryValueByKey('hospitalSettledFamilyOlder')}" />
	<c:set var="hospitalSettledFamilyHelp" value="${benefitsContent.getSupplementaryValueByKey('hospitalSettledFamilyHelp')}" />
	<c:set var="hospitalSettledFamilyDisabled" value="${benefitsContent.getSupplementaryValueByKey('hospitalSettledFamilyDisabled')}" />

	<c:set var="hospitalNewYoung" value="${benefitsContent.getSupplementaryValueByKey('hospitalNewYoung')}" />
	<c:set var="hospitalNewOlder" value="${benefitsContent.getSupplementaryValueByKey('hospitalNewOlder')}" />
	<c:set var="hospitalNewHelp" value="${benefitsContent.getSupplementaryValueByKey('hospitalNewHelp')}" />
	<c:set var="hospitalNewDisabled" value="${benefitsContent.getSupplementaryValueByKey('hospitalNewDisabled')}" />

	<c:set var="hospitalCompareYoung" value="${benefitsContent.getSupplementaryValueByKey('hospitalCompareYoung')}" />
	<c:set var="hospitalCompareOlder" value="${benefitsContent.getSupplementaryValueByKey('hospitalCompareOlder')}" />
	<c:set var="hospitalCompareHelp" value="${benefitsContent.getSupplementaryValueByKey('hospitalCompareHelp')}" />
	<c:set var="hospitalCompareDisabled" value="${benefitsContent.getSupplementaryValueByKey('hospitalCompareDisabled')}" />

	<c:set var="hospitalSpecificYoung" value="${benefitsContent.getSupplementaryValueByKey('hospitalSpecificYoung')}" />
	<c:set var="hospitalSpecificOlder" value="${benefitsContent.getSupplementaryValueByKey('hospitalSpecificOlder')}" />
	<c:set var="hospitalSpecificHelp" value="${benefitsContent.getSupplementaryValueByKey('hospitalSpecificHelp')}" />
	<c:set var="hospitalSpecificDisabled" value="${benefitsContent.getSupplementaryValueByKey('hospitalSpecificDisabled')}" />

	<c:set var="hospitalLimitedAll" value="${benefitsContent.getSupplementaryValueByKey('hospitalLimitedAll')}" />
	<c:set var="hospitalLimitedAllALT" value="${benefitsContent.getSupplementaryValueByKey('hospitalLimitedAllALT')}" />
	<c:set var="hospitalLimitedHelp" value="${benefitsContent.getSupplementaryValueByKey('hospitalLimitedHelp')}" />

	<c:set var="extrasFamilyYoung" value="${benefitsContent.getSupplementaryValueByKey('extrasFamilyYoung')}" />
	<c:set var="extrasFamilyOlder" value="${benefitsContent.getSupplementaryValueByKey('extrasFamilyOlder')}" />
	<c:set var="extrasFamilyHelp" value="${benefitsContent.getSupplementaryValueByKey('extrasFamilyHelp')}" />
	<c:set var="extrasFamilyDisabled" value="${benefitsContent.getSupplementaryValueByKey('extrasFamilyDisabled')}" />

	<c:set var="extrasSettledFamilyYoung" value="${benefitsContent.getSupplementaryValueByKey('extrasSettledFamilyYoung')}" />
	<c:set var="extrasSettledFamilyOlder" value="${benefitsContent.getSupplementaryValueByKey('extrasSettledFamilyOlder')}" />
	<c:set var="extrasSettledFamilyYoungSingleCouple" value="${benefitsContent.getSupplementaryValueByKey('extrasSettledFamilyYoungSingleCouple')}" />
	<c:set var="extrasSettledFamilyOlderSingleCouple" value="${benefitsContent.getSupplementaryValueByKey('extrasSettledFamilyOlderSingleCouple')}" />
	<c:set var="extrasSettledFamilyHelp" value="${benefitsContent.getSupplementaryValueByKey('extrasSettledFamilyHelp')}" />
	<c:set var="extrasSettledFamilyDisabled" value="${benefitsContent.getSupplementaryValueByKey('extrasSettledFamilyDisabled')}" />

	<c:set var="extrasNewYoung" value="${benefitsContent.getSupplementaryValueByKey('extrasNewYoung')}" />
	<c:set var="extrasNewOlder" value="${benefitsContent.getSupplementaryValueByKey('extrasNewOlder')}" />
	<c:set var="extrasNewHelp" value="${benefitsContent.getSupplementaryValueByKey('extrasNewHelp')}" />
	<c:set var="extrasNewDisabled" value="${benefitsContent.getSupplementaryValueByKey('extrasNewDisabled')}" />

	<c:set var="extrasCompareYoung" value="${benefitsContent.getSupplementaryValueByKey('extrasCompareYoung')}" />
	<c:set var="extrasCompareOlder" value="${benefitsContent.getSupplementaryValueByKey('extrasCompareOlder')}" />
	<c:set var="extrasCompareHelp" value="${benefitsContent.getSupplementaryValueByKey('extrasCompareHelp')}" />
	<c:set var="extrasCompareDisabled" value="${benefitsContent.getSupplementaryValueByKey('extrasCompareDisabled')}" />

	<c:set var="extrasSpecificYoung" value="${benefitsContent.getSupplementaryValueByKey('extrasSpecificYoung')}" />
	<c:set var="extrasSpecificOlder" value="${benefitsContent.getSupplementaryValueByKey('extrasSpecificOlder')}" />
	<c:set var="extrasSpecificHelp" value="${benefitsContent.getSupplementaryValueByKey('extrasSpecificHelp')}" />
	<c:set var="extrasSpecificDisabled" value="${benefitsContent.getSupplementaryValueByKey('extrasSpecificDisabled')}" />

	<c:set var="extrasLimitedAll" value="${benefitsContent.getSupplementaryValueByKey('extrasLimitedAll')}" />
	
	<c:set var="combinedNewHelp" value="${benefitsContent.getSupplementaryValueByKey('combinedNewHelp')}" />
	<c:set var="combinedCompareHelp" value="${benefitsContent.getSupplementaryValueByKey('combinedCompareHelp')}" />
	<c:set var="combinedFamilyHelp" value="${benefitsContent.getSupplementaryValueByKey('combinedFamilyHelp')}" />
	<c:set var="combinedSettledFamilyHelp" value="${benefitsContent.getSupplementaryValueByKey('combinedSettledFamilyHelp')}" />
	<c:set var="combinedSpecificHelp" value="${benefitsContent.getSupplementaryValueByKey('combinedSpecificHelp')}" />

	<c:set var="extrasCompareSpecialA" value="${benefitsContent.getSupplementaryValueByKey('extrasCompareSpecialA')}" />
	<c:set var="hospitalCompareSpecialA" value="${benefitsContent.getSupplementaryValueByKey('hospitalCompareSpecialA')}" />
	<c:set var="extrasCompareSpecialB" value="${benefitsContent.getSupplementaryValueByKey('extrasCompareSpecialB')}" />
	<c:set var="hospitalCompareSpecialB" value="${benefitsContent.getSupplementaryValueByKey('hospitalCompareSpecialB')}" />

	<health_v1:dual_pricing_settings />
	<health_v1:pyrr_campaign_settings />

	<c:set var="isContactTypeTrialCampaign">
		<c:choose>
			<c:when test="${not empty data['health/simples/contactTypeTrial']}">true</c:when>
			<c:otherwise>false</c:otherwise>
		</c:choose>
	</c:set>

	<%-- Check and list funds who have special discount functionality required --%>
	<jsp:useBean id="providerService" class="com.ctm.web.core.provider.services.ProviderService"/>
	<c:set var="providerPropertyId" value="discountActive" />
	<c:set var="AUFDiscount" value="${providerService.getProperty(pageContext.request, 1, providerPropertyId)}"/>

	<jsp:useBean id="touchService" class="com.ctm.web.core.services.AccessTouchService" scope="request" />
	<c:set var="previousTransactionId" value="${data['current/previousTransactionId']}" />
	<c:set var="hasTouchF" value="${touchService.touchCheck(previousTransactionId, 'F')}" scope="request"  />
	<competition:africaCompSettings />
{
	isCallCentreUser: <c:out value="${not empty callCentre}"/>,
	<c:if test="${not empty callCentre}">
		contactType: "<c:out value="${data['health/simples/contactType']}"/>",
		isContactTypeTrialCampaign: ${isContactTypeTrialCampaign},
		styleCodeId: "<c:out value="${pageSettings.getBrandId()}"/>",
	</c:if>
	gaClientId: "<c:out value="${data['health/gaclientid']}"/>",
	<core_v2:affiliateSettings />
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
	isDefaultToHealthQuote: ${defaultToHealthQuote},
    isDefaultToHealthApply: ${defaultToHealthApply},
	isTaxTime: '<content:get key="taxTime"/>',
	isDualPricingActive: ${isDualPriceActive},
	isHealthReformMessaging: '<content:get key="simplesHealthReformMessaging"/>',
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
		callCentreHelpNumber			: '${callCentreHelpNumber}',

		hospitalNewYoung				: "${hospitalNewYoung}",
		hospitalNewOlder				: "${hospitalNewOlder}",
		hospitalNewDisabled				: "${hospitalNewDisabled}",
		extrasNewYoung					: "${extrasNewYoung}",
		extrasNewOlder					: "${extrasNewOlder}",
		extrasNewDisabled				: "${extrasNewDisabled}",
		hospitalNewHelp					: "${hospitalNewHelp}",
		extrasNewHelp					: "${extrasNewHelp}",
		combinedNewHelp					: "${combinedNewHelp}",

		hospitalCompareYoung			: "${hospitalCompareYoung}",
		hospitalCompareOlder			: "${hospitalCompareOlder}",
		hospitalCompareDisabled			: "${hospitalCompareDisabled}",
		extrasCompareYoung				: "${extrasCompareYoung}",
		extrasCompareOlder				: "${extrasCompareOlder}",
		extrasCompareDisabled			: "${extrasCompareDisabled}",
		hospitalCompareHelp				: "${hospitalCompareHelp}",
		extrasCompareHelp				: "${extrasCompareHelp}",
		combinedCompareHelp				: "${combinedCompareHelp}",

		hospitalFamilyYoung				: "${hospitalFamilyYoung}",
		hospitalFamilyOlder				: "${hospitalFamilyOlder}",
		hospitalFamilyDisabled			: "${hospitalFamilyDisabled}",
		extrasFamilyYoung				: "${extrasFamilyYoung}",
		extrasFamilyOlder				: "${extrasFamilyOlder}",
		extrasFamilyDisabled			: "${extrasFamilyDisabled}",
		hospitalFamilyHelp				: "${hospitalFamilyHelp}",
		extrasFamilyHelp				: "${extrasFamilyHelp}",
		combinedFamilyHelp				: "${combinedFamilyHelp}",

		hospitalSettledFamilyYoung		: "${hospitalSettledFamilyYoung}",
		hospitalSettledFamilyOlder		: "${hospitalSettledFamilyOlder}",
		hospitalSettledFamilyDisabled	: "${hospitalSettledFamilyDisabled}",
		extrasSettledFamilyYoung		: "${extrasSettledFamilyYoung}",
		extrasSettledFamilyOlder		: "${extrasSettledFamilyOlder}",
		extrasSettledFamilyYoungSingleCouple		: "${extrasSettledFamilyYoungSingleCouple}",
		extrasSettledFamilyOlderSingleCouple		: "${extrasSettledFamilyOlderSingleCouple}",
		extrasSettledFamilyDisabled		: "${extrasSettledFamilyDisabled}",
		hospitalSettledFamilyHelp		: "${hospitalSettledFamilyHelp}",
		extrasSettledFamilyHelp			: "${extrasSettledFamilyHelp}",
		combinedSettledFamilyHelp		: "${combinedSettledFamilyHelp}",

		hospitalSpecificYoung			: "${hospitalSpecificYoung}",
		hospitalSpecificOlder			: "${hospitalSpecificOlder}",
		hospitalSpecificDisabled		: "${hospitalSpecificDisabled}",
		extrasSpecificYoung				: "${extrasSpecificYoung}",
		extrasSpecificOlder				: "${extrasSpecificOlder}",
		extrasSpecificDisabled			: "${extrasSpecificDisabled}",
		hospitalSpecificHelp			: "${hospitalSpecificHelp}",
		extrasSpecificHelp				: "${extrasSpecificHelp}",
		combinedSpecificHelp			: "${combinedSpecificHelp}",

		hospitalLimitedAll				: "${hospitalLimitedAll}",
		hospitalLimitedAllALT			: "${hospitalLimitedAllALT}",
		hospitalLimitedHelp				: "${hospitalLimitedHelp}",
		extrasLimitedAll 				: "${extrasLimitedAll}",

		hospitalCompareSpecialA			: "${hospitalCompareSpecialA}",
		extrasCompareSpecialA 			: "${extrasCompareSpecialA}",
		hospitalCompareSpecialB			: "${hospitalCompareSpecialB}",
		extrasCompareSpecialB 			: "${extrasCompareSpecialB}"
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
		cover: '${healthCvr}',
		situation: '${healthSitu}',
		benefits: '${_benefits}',
		state: '${state}',
		performHealthChoicesUpdate: ${performHealthChoicesUpdate}
	},
	<c:if test="${not empty data.health.simples}">simplesCheckboxes: <c:out value="${go:XMLtoJSON(data.health.simples)}" escapeXml="false" />,</c:if>
	<c:if test="${not empty data.health.application.dependants}">dependants:  <c:out value="${go:XMLtoJSON(data.health.application.dependants)}" escapeXml="false" />,</c:if>
	alternatePricing: <health_v1:alternate_pricing_json />,
	bsbServiceURL : "<content:get key="bsbValidationServiceUrl" />",
	ccOpeningHoursText : "<content:get key="ccHoursText" />",
	situationHealthCvr: "<c:out value="${data['health/situation/healthCvr']}"/>",
	hasPrimaryCover: "<c:out value="${data['health/healthCover/primary/cover']}"/>",
	hasPartnerCover: "<c:out value="${data['health/healthCover/partner/cover']}"/>",
	hasTouchF: ${hasTouchF},
	fundDiscounts : {
		AUF : "${AUFDiscount}"
	},
	africaComp: <c:out value="${africaComp}" />
}