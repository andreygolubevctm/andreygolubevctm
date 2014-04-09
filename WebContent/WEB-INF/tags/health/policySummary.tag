<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showProductDetails" rtexprvalue="true"	 description="Display the additional product details?" %>
<%@ attribute name="showDualPricing"    rtexprvalue="true"	 description="Display the future pricing component?" %>

<%-- If page setting for dual pricing is turned off --%>
<c:if test="${not empty showDualPricing and (empty pageSettings.healthDualpricing or pageSettings.healthDualpricing == '0') }">
	<c:set var="showDualPricing" value="" />
</c:if>



<div class="policySummaryContainer ${className}">
	<h1 class="hidden-xs">Your policy details</h1>

	<div class="policySummaryTemplateHolder productSummary horizontal"></div>
	<div class="policyPriceWarning">You have made changes that will possibly affect your policy price</div>
</div>

<c:if test="${showDualPricing == true}">
	<div class="policySummary dualPricing">
		<ui:bubble variant="chatty" className="moreInfoBubble">
			<div class="row">
				<div class="col-xs-6 labels">
					<h5><c:out value="${pageSettings.healthDualpricing}" /> Rate Rise</h5>
					<p>Pricing from <c:out value="${pageSettings.healthDualpricing}" /></p>
				</div>
				<div class="col-xs-6 productSummary vertical altPremium">
				</div>
			</div>
		</ui:bubble>
	</div>
</c:if>

<c:if test="${showProductDetails == true}">
	<div class="productSummaryDetails">
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