<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Pay your rate rise (pyrr) campaign templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="pyrr-campaign-results-template">
	<div class="container-fluid pyrrContainer">
		<div class="row">
			<div class="col-xs-2">
				<img src="assets/brand/ctm/images/health-giftcard-promotion-2017.png" alt="Gift Card Icon">
			</div>
			<div class="col-xs-5">
				<div class="coupon-blurb">
					{{= obj.coupon.contentBanner }}
				</div>
			</div>
			<div class="col-xs-5">
				<span class="coupon-value">
					<sup class="smallDollar">&#36;</sup>{{= obj.giftCardAmount ? obj.giftCardAmount : 0 }}
				</span>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- MORE INFO TEMPLATES --%>
<core_v1:js_template id="pyrr-campaign-moreinfo-template">
	<div class="container-fluid pyrrMoreInfoContainer">
		<div class="row">
			<div class="col-xs-4 imgCol">
				<img src="assets/brand/ctm/images/health-giftcard-promotion-2017.png" alt="Gift Card Icon">
			</div>
			<div class="col-xs-8">
				<div class="row">
					<div class="col-xs-12 blurbCol">
						<div class="coupon-blurb">
							{{= obj.coupon.contentBanner }}
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 valueCol">
						<div class="coupon-value">
							<sup class="smallDollar">&#36;</sup>{{= obj.giftCardAmount ? obj.giftCardAmount : 0 }}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="pyrr-campaign-moreinfo-xs-template">
	<div class="col-xs-12 pyrrMoreInfoXSContainer">
		<div class="row">
			<div class="col-xs-3 imgCol">
				<img src="assets/brand/ctm/images/health-giftcard-promotion-2017.png" alt="Gift Card Icon">
			</div>
			<div class="col-xs-6 blurbCol">
				<div class="coupon-blurb">
					{{= obj.coupon.contentBanner }}
				</div>
			</div>
			<div class="col-xs-3 valueCol">
				<span class="coupon-value">
					<sup class="smallDollar">&#36;</sup>{{= obj.giftCardAmount ? obj.giftCardAmount : 0 }}
				</span>
			</div>
		</div>
	</div>
</core_v1:js_template>
