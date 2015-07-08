<%@ tag description="Fuel Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="fuel"><c:out value="${param.fueltype}" escapeXml="true"/></c:set>
<c:set var="location"><c:out value="${param.fuel_location}" escapeXml="true"/></c:set>
<c:set var="isFromBrochureSite" value="${not empty fuel and not empty location}" />

{
    journeyStage: "<c:out value="${data['fuel/journey/stage']}"/>",
    pageAction: '<c:out value="${param.action}"  escapeXml="true"/>',
    navMenu: {
        type: 'offcanvas',
        direction: 'right'
    },
    isFromBrochureSite: ${isFromBrochureSite},
    isCallCentreUser: <c:out value="${not empty callCentre}"/>,
    isNewQuote: <c:out value="${isNewQuote eq true}"/>,
    userId: '<c:out value="${authenticatedData.login.user.uid}"/>',
    <c:if test="${isFromBrochureSite}">
        formData: {
            fuelType: "${fuel}",
            location: "${location}"
        }
    </c:if>
}