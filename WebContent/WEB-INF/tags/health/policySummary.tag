<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showProductDetails" rtexprvalue="true"	 description="Display the additional product details?" %>

<!-- This is a deactivated split test as it is likely to be run again in the future -->
<%-- <jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" /> --%>
<%-- <c:set var="isAltView" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" /> --%>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.services.health.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />


<div class="policySummaryContainer ${className}">
	<c:choose>
		<c:when test="${isAltView}">
			<health:price_itemisation_template />
			<h1 class="hidden-xs hidden-sm">Your premium<a href="javascript:;" class="btn-show-how-calculated">how is this calculated?</a></h1>
			<div class="priceItemisationTemplateHolder priceItemisation hidden-xs hidden-sm"></div>

			<h1 class="visible-sm">Your policy details</h1>
			<div class="policySummaryTemplateHolder productSummary horizontal hidden-md hidden-lg"></div>
		</c:when>
		<c:otherwise>
			<h1 class="hidden-xs">Your policy details</h1>
			<div class="policySummaryTemplateHolder productSummary horizontal"></div>
		</c:otherwise>
	</c:choose>
	<div class="policyPriceWarning">You have made changes that will possibly affect your policy price</div>
</div>

<c:if test="${healthAlternatePricingActive eq true}">
	<div class="policySummary dualPricing">
		<ui:bubble variant="chatty" className="moreInfoBubble rateRise">
			<div class="row">
				Beat the rate rise
			</div>
		</ui:bubble>
		<ui:bubble variant="chatty" className="moreInfoBubble pricingDetails">
			<div class="row">
				<div class="col-xs-5 col-sm-5 labels productSummary vertical Premium">

				</div>
				<div class="col-xs-2 col-sm-2 arrow-column">
					<span class="icon icon-arrow-thick-right"></span>
				</div>
				<div class="col-xs-5 col-sm-5 labels productSummary vertical altPremium">
				</div>
			</div>
		</ui:bubble>
		<div class="payAdvance">
			<p>Did you know, if you buy now and <strong>pay up to 12 months in advance</strong> before the rate rise applies, you can <strong>lock in the current price.</strong></p>
			<c:if test="${not empty callCentreNumber}">
				<p class="datesDetail">Please note: cut off dates for each fund may vary.
				<br/><span class="callCentreNumberSection">Call <span class="noWrap callCentreNumber">${callCentreNumber}</span> and select Option 2 for more information</span></p>
			</c:if>
		</div>
	</div>
</c:if>

<c:if test="${showProductDetails == true}">
	<div class="productSummaryDetails">
		<c:if test="${isAltView}">
			<h1 class="hidden-sm">Your policy details</h1>
			<div class="companyLogo hidden-sm"></div>
		</c:if>
		<h5 class="name">NAME</h5>
		<p>
			<strong>Start Date:</strong> <span class="startDate">XXX</span>
		</p>
		<p>
			<strong>Excess:</strong> <span class="excess">XXX</span>
		</p>
		<p>
			<strong>Excess Waivers:</strong> <span class="excessWaivers">XXX</span>
		</p>
		<p>
			<strong>Co-payment / % Hospital Contribution:</strong> <span class="copayment">XXX</span>
		</p>
		<div class="footer">
			<a href="javascript:;" class="more-info">view more info</a>
		</div>
	</div>

</c:if>