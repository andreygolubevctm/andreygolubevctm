<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="quote_vehicle_exoticCar"><c:out value="${param.quote_vehicle_exoticCar}" escapeXml="true" /></c:set>
<c:set var="isFromExoticPage" scope="request" value="${false}" />
<c:if test="${not empty quote_vehicle_exoticCar}">
    <c:set var="isFromExoticPage" scope="request" value="${true}" />
</c:if>