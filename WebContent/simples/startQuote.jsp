<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="callCentreService" class="com.ctm.services.CallCentreService" scope="application" />

<core_new:no_cache_header />

<c:set var="verticalCode" value="" />
<c:set var="verticalCodeParam" value="${param.verticalCode}" />

<c:choose>
	<c:when test="${not empty verticalCodeParam}">
		<settings:setVertical verticalCode="${verticalCodeParam}" />
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="SIMPLES" />
	</c:otherwise>
</c:choose>

<session:getAuthenticated />

<%-- Get phone call details --%>
<c:catch>
	<c:set var="phoneDetails" value="${callCentreService.getInboundPhoneDetails(pageContext.getRequest())}" />
</c:catch>
<c:if test="${not empty phoneDetails}">
	<c:set var="brandId" value="${phoneDetails.getStyleCodeId()}" />
	<c:set var="verticalId" value="${phoneDetails.getVerticalId()}" />

	<%-- If vertical has not been specified, use the call's details --%>
	<c:if test="${empty verticalCodeParam}">
		<c:set var="brand" value="${applicationService.getBrandById(brandId)}" />
		<c:if test="${not empty brand}">
			<c:set var="vertical" value="${brand.getVerticalById(verticalId)}" />
			<c:if test="${not empty vertical}">
				<c:set var="verticalCodeParam" value="${vertical.getCode()}" />
			</c:if>
		</c:if>
	</c:if>
</c:if>

<c:choose>
	<c:when test="${empty verticalCodeParam}">
		Unable to determine vertical from your phone call details.<br>Please choose <kbd>New > XXX quote</kbd> from the menu.
	</c:when>

	<%-- Unknown brand code to transfer to, get user to select the right one --%>
	<c:when test="${empty brandId or brandId == -1}">
		<c:redirect url="${pageSettings.getBaseUrl()}simples/selectBrand.jsp?verticalCode=${verticalCodeParam}" />
	</c:when>

	<c:otherwise>
		<c:redirect url="${callCentreService.createHandoverUrl(pageContext, brandId, verticalCodeParam, null)}" />
	</c:otherwise>

</c:choose>
