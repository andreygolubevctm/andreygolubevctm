<%@ tag description="The Health Extras List section template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-features-extras-template">
    <div class="cell category">
        <div class="content isMultiRow" data-featureId="99999">
        <strong>Product also covers:</strong> {{= meerkat.modules.healthv4Results.getAvailableExtrasAsList(obj) }}</div>
    </div>
</core_v1:js_template>