<%@ tag description="The Health Extras List section template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-features-extras-template">
    <div class="cell category">
        <div class="content isMultiRow" data-featureId="99999">
        {{= meerkat.modules.healthResultsTemplate.getAvailableExtrasAsList(obj) }}
            <div class="featuresViewAll">
                <span class="icon expander leftPosition" />  <span>View full details</span>
            </div>
        </div>
    </div>
</core_v1:js_template>