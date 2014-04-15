<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="country" value="${param.country}" />
<c:set var="region" value="${param.region}" />
<c:set var="fromDate" value="${param.fromDate}" />
<c:set var="toDate" value="${param.toDate}" />
<c:set var="format" value="${param.format}" />

<c:choose>
	<c:when test="${not empty country}">
		<read:public_holidays country="${country}" region="${region}" fromDate="${fromDate}" toDate="${toDate}" format="${format}" />
	</c:when>
	<c:otherwise>
		{error:true, errorMsg: "You need to provide at least a country for which to retrieve public holidays."}
	</c:otherwise>
</c:choose>