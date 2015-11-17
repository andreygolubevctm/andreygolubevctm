<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="dependant details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricing" value="${healthPriceDetailService.getAlternatePricingJSON(pageContext.getRequest())}" />
<c:if test="${empty healthAlternatePricing}">
	<c:set var="healthAlternatePricing" value="null" />
</c:if>
<c:out value="${healthAlternatePricing}" escapeXml="false" />