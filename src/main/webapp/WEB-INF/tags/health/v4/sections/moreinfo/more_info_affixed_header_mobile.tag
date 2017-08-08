<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="verticalId" value="${pageSettings.getVertical().getId()}"/>
<c:set var="callCentreOpen" scope="request">${openingHoursService.isCallCentreOpenNow(verticalId, pageContext.getRequest())}</c:set>

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />

<script id="moreInfoAffixedHeaderMobileTemplate" type="text/html">
	<div class="container <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if>">
		<div class="row dockedHeaderLarge /*dockedHeaderSlim*/">
			<div class="col-xs-6">
				<div class="logo-header hidden-slim">
					<div class="companyLogo {{= info.provider }}"></div>
				</div>
				<div class="productTitleText hidden-slim">
					<h5 class="noTopMargin productName text-center">{{= info.productTitle }}</h5>
				</div>
			</div>
			<div class="col-xs-6 text-center mobile-pricing hidden-slim">
				{{= renderedPriceTemplate }}
			</div>
			{{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
				{{= renderedPyrrCampaign }}
			{{ } }}
			<div class="col-xs-12 text-center dockedHeaderBottom <c:if test="${callCentreOpen eq true}">callCentreOpen</c:if>">
				<c:choose>
					<c:when test="${callCentreOpen eq true}">
						<a href="tel:{{= '${callCentreNumber}'.replace(/\s/g, '') }}" target="_blank" class="btn btn-cta btn-more-info-call-now" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />> <span class="icon-phone" />&nbsp;Call&nbsp;${callCentreNumber}</a>
						<div class="col-xs-6">
							<div class="quote-reference-number hidden-lg">
								<h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3>
							</div>
							<div class="getPrintableBrochures hidden-slim">
								<a href="javascript:;" class="getPrintableBrochures">Email brochures</a>
							</div>
						</div>
						<div class="col-xs-6">
							<a href="javascript:;" class="btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online&nbsp;<span class="icon-arrow-right" /></a>
						</div>
					</c:when>
					<c:otherwise>
						<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
						<div class="quote-reference-number hidden-lg">
							<h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3>
						</div>
						<a href="javascript:;" class="getPrintableBrochures hidden-slim">Email brochures</a>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</script>