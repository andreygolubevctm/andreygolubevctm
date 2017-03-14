<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Pay your rate rise (pyrr) campaign templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="pyrr-campaign-moreinfo-template">
    <div class="container-fluid pyrrContainerSimples">
        <div class="row">
            <div class="col-xs-6">
                <div class="coupon-blurb">
                    PYRR offer:
                </div>
            </div>
            <div class="col-xs-6">
                <span class="coupon-value">
                    &#36;{{= obj.giftCardAmount ? obj.giftCardAmount : 0 }}
                </span>
            </div>
        </div>
    </div>
</core_v1:js_template>


