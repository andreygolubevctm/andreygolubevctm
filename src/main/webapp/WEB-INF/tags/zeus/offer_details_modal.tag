<%@ tag description="Container for various input fields used by dialogs" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="zeus-offer-details-template">
	{{= meerkat.modules.rewardCampaign.getCampaignContentHtml().find('.zeus-offer-details').html() }}

	<%--
		<div class="zeus-offer-details-content">
			<div class="row">
				<div class="col-xs-12">
					<h1><strong>Meerkat toys are back!</strong></h1>
					<h4>(and just as handsome as last time)</h4>
					<p class="offer-text">Ready to claim your very own Aleksandr or Sergei toy?<br />Simply finish your quote, find a great deal on health insurance, and buy your policy before 30 June to claim your Meerkat toy reward.<br />Simples!</p>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 zeus-offer-details-img"></div>
				<div class="col-xs-12 col-sm-offset-8 col-sm-4 push-top-15 offer-btn-position">
					<a href="javascript:;" class="btn btn-block btn-success btn-zeus-offer-dtls">Continue</a>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 text-center">
					<div class="reward-t-and-c-text"><a href="https://www.comparethemarket.com.au/competition/meerkat-toys-terms-conditions-15.05.2017.pdf" target="_blank">Terms &amp; conditions<span class="sr-only">Opens in new window</span></a> apply. One toy per policy.</div>
				</div>
			</div>
		</div>
	--%>
</core_v1:js_template>