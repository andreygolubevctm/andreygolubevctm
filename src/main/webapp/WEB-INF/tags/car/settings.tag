<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- SET ESCAPEXML'd VARIABLES HERE FROM WEBSITE --%>
<c:set var="quote_vehicle_make"><c:out value="${param.quote_vehicle_make}" escapeXml="true" /></c:set>
<c:set var="quote_vehicle_model"><c:out value="${param.quote_vehicle_model}" escapeXml="true" /></c:set>
<c:set var="quote_vehicle_year"><c:out value="${param.quote_vehicle_year}" escapeXml="true" /></c:set>
<c:set var="quote_vehicle_searchRego"><c:out value="${param.quote_vehicle_searchRego}" escapeXml="true" /></c:set>
<c:set var="quote_vehicle_searchState"><c:out value="${param.quote_vehicle_searchState}" escapeXml="true" /></c:set>

<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty quote_vehicle_make || not empty quote_vehicle_model || not empty quote_vehicle_year || not empty quote_vehicle_searchRego || not empty quote_vehicle_searchState}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>

<c:set var="priceDisplayMode"><content:get key="resultsDisplayMode" /></c:set>
<c:if test="${not empty param.display and (param.display eq 'price' or param.display eq 'features')}">
	<c:set var="priceDisplayMode" value="${param.display}"/>
</c:if>

<%-- Retrieve values passed from website --%>
<c:if test="${not empty param.action && param.action == 'ql'}">
	<c:if test="${not empty param.quote_vehicle_make}">
		<go:setData dataVar="data" value="${quote_vehicle_make}" xpath="quote/vehicle/make" />
		<c:if test="${not empty param.quote_vehicle_model}">
			<go:setData dataVar="data" value="${quote_vehicle_model}" xpath="quote/vehicle/model" />
			<c:if test="${not empty param.quote_vehicle_year}">
				<go:setData dataVar="data" value="${quote_vehicle_year}" xpath="quote/vehicle/year" />
			</c:if>
		</c:if>
	</c:if>
</c:if>

<%-- Retrieve the vehicle MAKE data --%>
<jsp:useBean id="service" class="com.ctm.web.car.services.CarVehicleSelectionService" scope="request" />
<c:set var="json" value="${service.getVehicleSelection(data.quote.vehicle.make, data.quote.vehicle.model, data.quote.vehicle.year, data.quote.vehicle.body, data.quote.vehicle.trans, data.quote.vehicle.fuel) }" />

<%-- Retrieve non-standard accessories list --%>
<c:set var="nonStandardAccessories" value="${service.getVehicleNonStandardsJson()}" />

<car:lead_capture_settings />
<competition:octoberCompSettings />

{
	octoberComp: <c:out value="${octoberComp}" />,
	isCallCentreUser: <c:out value="${not empty callCentre}"/>,
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	brochureValues: {},
	journeyStage: "<c:out value="${data['quote/journey/stage']}"/>",
	pageAction: '<c:out value="${param.action}"/>',
	previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
	isNewQuote: <c:out value="${isNewQuote eq true}" />,
	userId: '<c:out value="${authenticatedData.login.user.uid}" />',
	content:{
		callCentreNumber: '${callCentreNumber}',
		callCentreHelpNumber: '${callCentreHelpNumber}'
	},
	navMenu: {
		type: 'offcanvas',
		direction: 'right'
	},
	vehicleSelectionDefaults : {
		makes:				'${data.quote.vehicle.make}',
		makeDes:			'${data.quote.vehicle.makeDes}',
		models:				'${data.quote.vehicle.model}',
		modelDes:			'${data.quote.vehicle.modelDes}',
		years:				'${data.quote.vehicle.year}',
		registrationYear:	'${data.quote.vehicle.registrationYear}',
		bodies:				'${data.quote.vehicle.body}',
		transmissions:		'${data.quote.vehicle.trans}',
		fuels:				'${data.quote.vehicle.fuel}',
		types:				'${data.quote.vehicle.redbookCode}',
		colours:			'${data.quote.vehicle.colour}',
		marketValue:		'${data.quote.vehicle.marketValue}',
		variant:			'${data.quote.vehicle.variant}',
		securityOption:		'${data.quote.vehicle.securityOption}',
        searchRego:         '${quote_vehicle_searchRego}',
		searchState:		'${quote_vehicle_searchState}',
		data:				${json}
	},
	userOptionPreselections: {
		factory : ${go:XMLtoJSON(go:getEscapedXml(data.quote.opts))},
		accessories : ${go:XMLtoJSON(go:getEscapedXml(data.quote.accs))}
	},
	nonStandardAccessoriesList : ${nonStandardAccessories},
	resultOptions: {
		displayMode: "<c:out value="${priceDisplayMode}" />"
	},
	commencementDate : '${data.quote.options.commencementDate}',
	skipNewCoverTypeCarJourney: ${skipNewCoverTypeCarJourney},
	ctpMessage: "<content:get key="ctpMessageCopy"/>",
	isFromExoticPage : <c:choose><c:when test="${not empty isFromExoticPage}">${isFromExoticPage}</c:when><c:otherwise>false</c:otherwise></c:choose>,
	isExoticManualEntry: <c:choose><c:when test="${not empty isExoticManualEntry}">${isExoticManualEntry}</c:when><c:otherwise>false</c:otherwise></c:choose>,
	isRegoLookup: ${isRegoLookup},
	exoticCarContent: {
		normalHeading : "${normalHeading}",
		normalCopy : "${normalCopy}",
		exoticHeading : <c:choose><c:when test="${not empty exoticHeading}">"${exoticHeading}"</c:when><c:otherwise>""</c:otherwise></c:choose>,
		exoticCopy : <c:choose><c:when test="${not empty exoticCopy}">"${exoticCopy}"</c:when><c:otherwise>""</c:otherwise></c:choose>
	},
	IBOXquoteNumber: null
}
