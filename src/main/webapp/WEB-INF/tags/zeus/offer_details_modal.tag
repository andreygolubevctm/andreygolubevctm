<%@ tag description="Container for various input fields used by dialogs" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="zeus-offer-details-template">
	{{= meerkat.modules.rewardCampaign.getCampaignContentHtml().find('.zeus-offer-details').html() }}
</core_v1:js_template>