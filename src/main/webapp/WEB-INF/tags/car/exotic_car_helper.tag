<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="quote_vehicle_exoticCar"><c:out value="${param.quote_vehicle_exoticCar}" escapeXml="true" /></c:set>
<c:set var="isFromExoticPage" scope="request" value="${false}" />
<c:if test="${not empty quote_vehicle_exoticCar}">
    <c:set var="isFromExoticPage" scope="request" value="${true}" />
</c:if>

<c:set var="quote_vehicle_exoticManualEntry"><c:out value="${param.quote_vehicle_exoticManualEntry}" escapeXml="true" /></c:set>
<c:set var="isExoticManualEntry" scope="request" value="${false}" />
<c:if test="${not empty quote_vehicle_exoticManualEntry}">
    <c:set var="isExoticManualEntry" scope="request" value="${true}" />
    <c:set var="isFromExoticPage" scope="request" value="${true}" />
</c:if>

<c:set var="exoticCarContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "exoticCarContent")}' />

<c:set var="originalHeading" value="${exoticCarContent.getSupplementaryValueByKey('normalHeading')}" scope="request" />
<c:set var="origintalCopy" value="${exoticCarContent.getSupplementaryValueByKey('normalCopy')}" scope="request" />
<c:set var="exoticHeading" value="${exoticCarContent.getSupplementaryValueByKey('exoticHeading')}" scope="request" />
<c:set var="exoticCopy" value="${exoticCarContent.getSupplementaryValueByKey('exoticCopy')}" scope="request" />
<c:set var="resultsHeading" value="${exoticCarContent.getSupplementaryValueByKey('resultsHeading')}" scope="request" />
<c:set var="resultsContact" value="${exoticCarContent.getSupplementaryValueByKey('resultsContact')}" scope="request" />
