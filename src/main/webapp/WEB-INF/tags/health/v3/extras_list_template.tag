<%@ tag description="The Health Extras List section template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-features-extras-template">
    {{ var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0]; var availableExtras = []; }}
    {{ _.each(feature.children, function(ft) { }}
        {{ var hasResult = ft.resultPath != null && ft.resultPath != ''; }}
        {{ var pathValue = hasResult ? Object.byString( obj, ft.resultPath ) : false; }}
        {{ if(pathValue == "Y") { availableExtras.push(ft); } }}
    {{ }); }}
    <div class="cell category">
        <div class="content" data-featureId="99999">
        <strong>Product also covers:</strong> {{ _.each(availableExtras, function(ft, i) { }}
        {{= ft.safeName }}{{ if(i == (availableExtras.length-2) ) { }} and {{ } else if(i != availableExtras.length-1) { }}, {{ } }}
        {{ }); }}</div>
    </div>
</core_v1:js_template>