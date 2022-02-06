<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showProductDetails" rtexprvalue="true"	 description="Display the additional product details?" %>

<%-- This is a deactivated split test as it is likely to be run again in the future --%>
<%-- <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" /> --%>
<%-- <c:set var="isAltView" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" /> --%>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />

<div class="sidebar-box<c:if test="${isDualPriceActive eq true}"> hasDualPricing</c:if> policySummary-sidebar">
    <div class="policySummaryContainer ${className}">
        <c:choose>
            <c:when test="${isAltView}">
                <health_v4_payment:price_itemisation_template />
                <h1 class="hidden-xs hidden-sm">Your premium<a href="javascript:;" class="btn-show-how-calculated">how is this calculated?</a></h1>
                <div class="priceItemisationTemplateHolder priceItemisation hidden-xs hidden-sm"></div>

                <h1 class="visible-sm">Your quote details</h1>
                <div class="policySummaryTemplateHolder productSummary horizontal hidden-md hidden-lg"></div>
            </c:when>
            <c:otherwise>
                <h1 class="hidden-xs">Your Chosen Policy</h1>
                <div class="policySummaryTemplateHolder productSummary horizontal"></div>
            </c:otherwise>
        </c:choose>
    </div>

<c:if test="${isDualPriceActive eq true}">
    <h1>Your quote details</h1>
    <div class="quoterefTemplateHolder"></div>
    <div class="policySummary productSummary dualPricing"></div>
</c:if>

<c:if test="${isDualPriceActive eq true}">
    </div>
    <div class="sidebar-box sidebarFrequency hidden-xs"></div>
    <div class="sidebar-box">
</c:if>
</div>
