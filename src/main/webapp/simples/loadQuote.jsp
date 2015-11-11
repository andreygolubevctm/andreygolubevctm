<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="callCentreService" class="com.ctm.web.simples.services.CallCentreService" scope="application" />

<settings:setVertical verticalCode="GENERIC" />

<c:choose>
	<c:when test="${param.brandId != pageSettings.getBrandId()}">
		<c:redirect url="${callCentreService.createHandoverUrl(pageContext.getRequest(), param.brandId, param.verticalCode, param.transactionId, null)}"/>
	</c:when>
	<c:otherwise>
		<simples:load_quote/>
	</c:otherwise>
</c:choose>