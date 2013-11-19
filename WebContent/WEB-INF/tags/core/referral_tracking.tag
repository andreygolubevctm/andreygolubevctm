<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Collect querystring params, e.g. campaign codes, and store them in transaction details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical"	required="true"	 	rtexprvalue="true" 	description="Vertical to associate this tracking with e.g. health" %>

<c:set var="vertical" value="${fn:toLowerCase(vertical)}" />
<c:set var="root" value="${vertical}/tracking" />

<%--
	Marketing/promo code collector
--%>
<c:set var="xpath" value="${root}/cid" />
<c:choose>
	<c:when test="${not empty data[xpath]}">
		<%-- Retain campaign in data bucket --%>
	</c:when>
	<c:when test="${not empty cookie.CampaignID and not empty cookie.CampaignID.value}">
		<go:setData dataVar="data" xpath="${xpath}" value="${cookie.CampaignID.value}" />
	</c:when>
	<c:when test="${not empty param.cid}">
		<go:setData dataVar="data" xpath="${xpath}" value="${param.cid}" />
	</c:when>
</c:choose>
<field:hidden xpath="${xpath}" defaultValue="" />

