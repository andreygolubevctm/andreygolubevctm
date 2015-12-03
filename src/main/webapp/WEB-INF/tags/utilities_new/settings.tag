<%@ tag description="Loading of the Utilities Settings JS Object" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="fromBrochure" scope="request" value="${false}"/>

<c:set var="providerResults" value="null" />

<c:if test="${( not empty data.utilities.householdDetails.suburb) and (not empty data.utilities.householdDetails.postcode) }">
    <jsp:useBean id="providerService" class="com.ctm.web.utilities.services.UtilitiesProviderService" />
    <c:set var="suburb" value="${data.utilities.householdDetails.suburb}" />
    <c:set var="postCode" value="${data.utilities.householdDetails.postcode}" />
    <c:set var="providerResults" value="${providerService.getResults(pageContext.request, postCode, suburb).toJson()}" />
</c:if>

{
    isFromBrochureSite: false,
    journeyStage: "<c:out value="${data['utilities/journey/stage']}"/>",
    pageAction: '<c:out value="${param.action}" escapeXml="true"/>',
    previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
    isNewQuote: <c:out value="${isNewQuote eq true}"/>,
    navMenu: {
        type: 'offcanvas',
        direction: 'right',
    },
    content:{
        callCentreNumber				: '${callCentreNumber}',
        callCentreHelpNumber			: '${callCentreHelpNumber}'
    },
    session: {
        firstPokeEnabled: <c:choose><c:when test="${param.action eq 'confirmation'}">false</c:when><c:otherwise>true</c:otherwise></c:choose>
    },
    providerResults: ${providerResults}
}