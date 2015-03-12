<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showProductDetails" rtexprvalue="true"	 description="Display the additional product details?" %>
<%@ attribute name="showDualPricing"    rtexprvalue="true"	 description="Display the future pricing component?" %>

<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="isAltView" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" />

<%-- If page setting for dual pricing is turned off --%>
<c:if test="${not empty showDualPricing and (empty healthDualpricing or healthDualpricing == '0') }">
	<c:set var="showDualPricing" value="" />
</c:if>

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

<c:if test="${showDualPricing == true}">
	<div class="policySummary dualPricing">
		<ui:bubble variant="chatty" className="moreInfoBubble">
			<div class="row">
				<div class="col-xs-6 labels">
					<h5><c:out value="${healthDualpricing}" /> Rate Rise</h5>
					<p>Pricing from <c:out value="${healthDualpricing}" /></p>
				</div>
				<div class="col-xs-6 productSummary vertical altPremium">
				</div>
			</div>
		</ui:bubble>
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