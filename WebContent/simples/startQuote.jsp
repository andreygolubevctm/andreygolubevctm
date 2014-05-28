<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_new:no_cache_header />
<settings:setVertical verticalCode="${param.verticalCode}" />
<session:getAuthenticated />

<jsp:useBean id="callCentreService" class="com.ctm.services.CallCentreService" scope="application" />

<%-- Get url for transfer --%>
<c:set var="brandId" value="${callCentreService.getBrandIdForNewQuote(pageContext)}" />

<c:choose>
	<c:when test="${brandId == -1}">
		<%-- Unknown brand code to transfer to, get user to select the right one --%>
		<c:set var="redirectionUrl" value="${pageSettings.getBaseUrl()}/simples/selectBrand.jsp?verticalCode=${param.verticalCode}" />
	</c:when>
	<c:otherwise>
		<c:set var="redirectionUrl" value="${callCentreService.createHandoverUrl(pageContext, brandId, param.verticalCode, null)}" />
	</c:otherwise>

</c:choose>

<c:redirect url="${redirectionUrl}"/>
