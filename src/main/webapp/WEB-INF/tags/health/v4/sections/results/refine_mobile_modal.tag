<%@ tag description="Results refine for mobile modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<core_v1:js_template id="refine-mobile-modal-template">
    <h3>My Insurance Preferences</h3>

    <div class="refine-results-sub-heading">Hospital</div>
    <div class="refine-results-by-container">
        <div class="refine-results-by-benefits">
            <div class="">{{= hospitalType }} Cover</div>
            <div class=""></div>
            <a href="javascript:;"></a>
        </div>
    </div>

    <div class="refine-results-sub-heading">Extras</div>
    <div class="refine-results-by-container">
        <div class="refine-results-by-extras-benefits"></div>
    </div>
</core_v1:js_template>