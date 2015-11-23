<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="callCentreService" class="com.ctm.web.simples.services.CallCentreService" scope="application" />
<c:redirect url="${callCentreService.createHandoverUrl(pageContext.getRequest(), param.brandId, param.verticalCode, param.transactionId, param.vdn)}"/>