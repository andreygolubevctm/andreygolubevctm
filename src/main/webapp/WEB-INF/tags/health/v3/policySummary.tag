<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showProductDetails" rtexprvalue="true"	 description="Display the additional product details?" %>

<%-- This is a deactivated split test as it is likely to be run again in the future --%>
<%-- <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" /> --%>
<%-- <c:set var="isAltView" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" /> --%>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />

<div class="sidebar-box hasDualPricing hidden-xs policySummary-sidebar">
	<h1>Your quote details</h1>
	<div class="quoterefTemplateHolder"></div>
	<div class="policySummary productSummary dualPricing"></div>
</div>
<div class="vertical-center-items hidden-lg hidden-md hidden-sm">
	<p class="brochurePlaceholder hidden-lg hidden-md hidden-sm">
</div>