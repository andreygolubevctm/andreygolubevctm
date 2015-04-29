<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- SET ESCAPEXML'd VARIABLES HERE FROM BROCHUREWARE --%>
<c:set var="quote_vehicle_make"><c:out value="${param.quote_vehicle_make}" escapeXml="true" /></c:set>
<c:set var="quote_vehicle_model"><c:out value="${param.quote_vehicle_model}" escapeXml="true" /></c:set>
<c:set var="quote_vehicle_year"><c:out value="${param.quote_vehicle_year}" escapeXml="true" /></c:set>
<%-- VARIABLES --%>
<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty quote_vehicle_make || not empty quote_vehicle_model || not empty quote_vehicle_year}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>
<c:set var="priceDisplayMode" value="price"/>
<c:if test="${param.display eq 'features'}">
	<c:set var="priceDisplayMode" value="features"/>
</c:if>

<%-- Retrieve values passed from Brochure Site --%>
<c:if test="${not empty param.action && param.action == 'ql'}">
	<c:if test="${not empty param.quote_vehicle_make}">
		<go:setData dataVar="data" value="${param.quote_vehicle_make}" xpath="quote/vehicle/make" />
		<c:if test="${not empty param.quote_vehicle_model}">
			<go:setData dataVar="data" value="${param.quote_vehicle_model}" xpath="quote/vehicle/model" />
			<c:if test="${not empty param.quote_vehicle_year}">
				<go:setData dataVar="data" value="${param.quote_vehicle_year}" xpath="quote/vehicle/year" />
			</c:if>
		</c:if>
	</c:if>
</c:if>

<%-- Retrieve the vehicle MAKE data --%>
<jsp:useBean id="service" class="com.ctm.services.car.CarVehicleSelectionService" scope="request" />
<c:set var="json" value="${service.getVehicleSelection(data.quote.vehicle.make, data.quote.vehicle.model, data.quote.vehicle.year, data.quote.vehicle.body, data.quote.vehicle.trans, data.quote.vehicle.fuel) }" />

<%-- Retrieve non-standard accessories list --%>
<c:set var="nonStandardAccessories" value="${service.getVehicleNonStandardsJson()}" />

<%-- Check whether to force to use disc for GetaCall lead feeds --%>
<c:set var="forceToUseDISCForGetACall" value="${contentService.getContentWithSupplementary(pageContext.getRequest(), 'forceToUseDISC').getSupplementaryValueByKey('GetaCall')}" />
<c:set var="defaultLeadFeedURL" value="ajax/write/lead_feed_save.jsp" />
<c:set var="useDISCLeadFeedProperties" value="${false}" />
<c:set var="getACallLeadFeedURL">
	<c:choose>
		<c:when test="${not empty forceToUseDISCForGetACall and forceToUseDISCForGetACall eq 'Y'}">
			<c:set var="useDISCLeadFeedProperties" value="${true}" />
			<c:out value="${defaultLeadFeedURL}" />
		</c:when>
		<c:otherwise>
			<c:out value="leadfeed/car/getacall.json" />
		</c:otherwise>
	</c:choose>
</c:set>
{
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
		marketValue:		'${data.quote.vehicle.marketValue}',
		variant:			'${data.quote.vehicle.variant}',
		securityOption:		'${data.quote.vehicle.securityOption}',
		data:				${json}
	},
	nonStandardAccessoriesList : ${nonStandardAccessories},
	resultOptions: {
		displayMode: "<c:out value="${priceDisplayMode}" />"
	},
	commencementDate : '${data.quote.options.commencementDate}',
	leadfeed : {
		CallDirect : {
			use_disc_props : ${true},
			url : '${defaultLeadFeedURL}'
		},
		GetaCall : {
			use_disc_props : ${useDISCLeadFeedProperties},
			url : '${getACallLeadFeedURL}'
		}
	}
}