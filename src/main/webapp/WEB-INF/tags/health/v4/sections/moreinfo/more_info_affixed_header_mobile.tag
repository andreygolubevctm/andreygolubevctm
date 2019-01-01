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
	<div class="container <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if> visible-xs">
		<div class="row dockedHdr dockedHeaderLarge cloned-docked-header">
			<div class="col-xs-12">
				<div class="logo-header col-xs-4">
					<div class="companyLogo {{= info.provider }}"></div>
				</div>
				<div class="productTitleText col-xs-8">
					<h5 class="noTopMargin productName">{{= info.productTitle }}</h5>
					<div class="col-xs-12 aboutThisFundLink">
        		<a href="javascript:;" class="about-this-fund"><img class="aboutIcon" src="assets/brand/ctm/images/icons/down_arrow.svg" />About this fund</a>
    			</div>
				</div>
			</div>
			<div class="col-xs-12 text-center mobile-pricing">
				{{= renderedPriceTemplate }}
			</div>
			{{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
				{{= renderedPyrrCampaign }}
			{{ } }}
			{{ if (obj.premium[obj._selectedFrequency].lhcfreepricing) { }}
				<div class="current-pricing-details">
					<span>{{= obj.premium[obj._selectedFrequency].lhcfreepricing }}</span>
				</div>
			{{ } }}
			<div class="col-xs-12 text-center dockedHeaderBottom <c:if test="${callCentreOpen eq true}">callCentreOpen</c:if>">
				<health_v4_moreinfo:more_info_mobile_elements />
				<c:choose>
					<c:when test="${callCentreOpen eq true}">
						<c:set var="continueOnlineAsCTA" scope="request"><content:get key="continueOnlineAsCTA"/></c:set>
						<c:choose>
							<c:when test="${continueOnlineAsCTA eq 'Y'}">
								${continueOnlineCTAHtml}
							</c:when>
							<c:otherwise>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						${continueOnlineCTAHtml}
						${quoteRefHtml}
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</script>