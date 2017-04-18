<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Results call button templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="call-direct-button-template">
    <%-- Call Insurer Direct action button. --%>
    <div class="btnContainer">
        <a class="btn btn-sm btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="{{= obj.productId }}">
            Call Insurer
        </a>
    </div>
</core_v1:js_template>

<core_v1:js_template id="call-back-button-template">
    <%-- Call Me Back action button. --%>
    <div class="btnContainer">
        <a class="btn btn-sm btn-back btn-block btn-call-actions btn-callback" data-callback-toggle="callback" href="javascript:;" data-productId="{{= obj.productId }}">
            Get <span class="hidden-xs">a</span> Call Back
        </a>
    </div>
</core_v1:js_template>