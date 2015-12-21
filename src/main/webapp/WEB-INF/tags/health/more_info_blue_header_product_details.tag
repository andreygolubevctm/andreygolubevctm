<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRODUCT DETAILS TEMPLATE --%>
<core:js_template id="more-info-product-details-template">
	<div class="col-sm-12">
		<div class="row product-details-container">
			<div class="col-xs-12 col-sm-5">{{ var logoPriceTemplate = $("#more-info-logo-price-template").html(); }}
				{{ var htmlTemplatePrice = _.template(logoPriceTemplate); }}
				{{ obj._selectedFrequency = Results.getFrequency(); }}
				{{ obj.mode = ''; }}
				{{ obj.showAltPremium = false; obj.htmlString = htmlTemplatePrice(obj); }}
				{{ obj.showAltPremium = true;  obj.htmlStringAlt = htmlTemplatePrice(obj); }}
				{{= htmlString }}</div>
			<div class="col-sm-7 col-xs-12">
				<div class="row">
					<div class="col-lg-5 col-lg-offset-0 col-md-6 col-md-offset-3 col-sm-5 col-sm-offset-0 col-xs-6 col-xs-offset-3 pull-left more-info-apply-container"><a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= productId }}">Apply Now<span class="icon-arrow-right" /></a></div>
					<div class="col-lg-7 col-md-12 col-sm-7 col-xs-12 moreInfoCallRefNo"><span class="moreInfoCallUs">or Call <span class="noWrap callCentreNumber">${callCentreNumber}</span></span>
						<p class="moreInfoReferenceNoText">quote your reference number <span class="moreInfoReferenceNo">{{= transactionId }}</span></p></div>
				</div>
			</div>
		</div>
	</div>
</core:js_template>