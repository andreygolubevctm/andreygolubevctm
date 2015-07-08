<%@ tag description="Loading of the Roadside Settings JS Object" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>

<%-- SET ESCAPEXML'd VARIABLES HERE FROM BROCHUREWARE --%>
<c:set var="roadside_vehicle_make"><c:out value="${param.roadside_vehicle_make}" escapeXml="true"/></c:set>
<c:set var="roadside_vehicle_year"><c:out value="${param.roadside_vehicle_year}" escapeXml="true"/></c:set>

<%-- VARIABLES --%>
<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty roadside_vehicle_make || not empty quote_vehicle_year}">
    <c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>
<c:set var="pageAction"><c:out value="${param.action}" escapeXml="true"/></c:set>


<%-- Retrieve values passed from Brochure Site --%>
<c:if test="${not empty param.action && param.action == 'ql'}">
    <c:if test="${not empty roadside_vehicle_make}">
        <go:setData dataVar="data" value="${roadside_vehicle_make}" xpath="${vertical}/vehicle/make"/>
        <c:if test="${not empty roadside_vehicle_year}">
            <go:setData dataVar="data" value="${roadside_vehicle_year}" xpath="${vertical}/vehicle/year"/>
        </c:if>
    </c:if>
</c:if>

<%-- Retrieve the vehicle MAKE data --%>
<jsp:useBean id="service" class="com.ctm.services.car.CarVehicleSelectionService" scope="request" />
<c:set var="json" value="${service.getVehicleSelection(data.roadside.vehicle.make, '', '', '', '', '') }" />

{
    isCallCentreUser: <c:out value="${not empty callCentre}"/>,
    isFromBrochureSite: <c:out value="${fromBrochure}"/>,
    brochureValues: {},
    journeyStage: "<c:out value="${data['roadside/journey/stage']}"/>",
    pageAction: '<c:out value="${pageAction}"/>',
    previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
    isNewQuote: <c:out value="${isNewQuote eq true}"/>,
    userId: '<c:out value="${authenticatedData.login.user.uid}"/>',
    navMenu: {
        type: 'offcanvas',
        direction: 'right'
    },
    vehicleSelectionDefaults : {
        makes: '${data.roadside.vehicle.make}',
        makeDes: '${data.roadside.vehicle.makeDes}',
        years: '${data.roadside.vehicle.year}',
        data: ${json}
    }

}