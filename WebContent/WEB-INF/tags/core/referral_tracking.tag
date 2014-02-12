<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Collect querystring params, e.g. campaign codes, and store them in transaction details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ tag import="java.net.URLDecoder, java.util.List"%>

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
		<c:set var="source" value="data bucket"/>
	</c:when>
	<c:when test="${not empty cookie.CampaignID and not empty cookie.CampaignID.value}">
		<c:set var="cid" scope="request" >
			<c:out value="${go:decodeUrl(cookie.CampaignID.value)}" escapeXml="true"/>
		</c:set>
		<c:set var="source" value="cookie"/>
		<go:setData dataVar="data" xpath="${xpath}" value="${cid}" />
	</c:when>
	<c:when test="${not empty param.cid}">
		<c:set var="cid" ><c:out value="${param.cid}" escapeXml="true"/></c:set>
		<c:set var="source" value="param"/>
		<go:setData dataVar="data" xpath="${xpath}" value="${cid}" />
	</c:when>
</c:choose>
<go:log source="core:referral_tracking">CID: ${cid} from ${source}</go:log>
<field:hidden xpath="${xpath}" defaultValue="" />

