<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="HEALTH" />

<%-- This file will receive a relative URL to a PDF. It will check if a branded version of the file exists
	and redirect the user to that PDF, otherwise the default requested PDF is shown. --%>

<c:set var="pdf" 			value="${fn:replace(param.pdf, ' ', '%20')}" />
<c:set var="brand"			value="${pageSettings.getBrandId()}" />
<c:set var="url_prefix"		value="${pageSettings.getBaseUrl()}health_fund_info/brochures/" />
<c:set var="url_branded" 	value="${url_prefix}${brand}${pdf}" />
<c:set var="url_default" 	value="${url_prefix}0${pdf}" />

<c:set var="url_final">
	<%-- only show branded brochure if set in database --%>
	<c:choose>
		<c:when test="${pageSettings.getSetting('hasBrandedProductBrochures') == 'Y'}">${url_branded}</c:when>
		<c:otherwise>${url_default}</c:otherwise>
	</c:choose>
</c:set>

<%-- Redirect to the PDF --%>
<c:redirect url="${url_final}" />