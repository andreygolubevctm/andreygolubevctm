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
            <div class="col-xs-6">
                <div class="coupon-blurb">
                    {{= obj.coupon.contentBanner }}
                </div>
            </div>
            <div class="col-xs-4">
                <span class="coupon-value">
                    &#36;{{= obj.giftCardAmount ? obj.giftCardAmount : 0 }}
                </span>
            </div>
        </div>
    </div>
</core_v1:js_template>


