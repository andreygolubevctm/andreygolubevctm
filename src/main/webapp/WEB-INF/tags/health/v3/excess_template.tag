<%@ tag description="The Health Excess feature template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-features-excess-template">

    {{ var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0]; }}
    {{ _.each(feature.children, function(ft) { }}
    {{ var dataSKey = typeof ft.shortlistKey != 'undefined' && ft.shortlistKey != '' ? 'data-skey="'+ft.shortlistKey + '"' : ''; }}
    {{ var dataSKeyParent = typeof ft.shortlistKeyParent != 'undefined' && ft.shortlistKeyParent != '' ? 'data-par-skey="'+ft.shortlistKeyParent + '"' : ''; }}
    <div class="cell {{= ft.classString }}" data-index="-1" {{=dataSKey }} {{=dataSKeyParent }}>
        <div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
            {{ var hasResult = ft.resultPath != null && ft.resultPath != ''; }}
            {{ var pathValue = hasResult ? Object.byString( obj, ft.resultPath ) : false; }}
            {{ if(hasResult) { }}
                {{ var displayValue = Features.parseFeatureValue( pathValue, true ); }}<%-- Below compressed to reduce number of whitespace nodes in DOM --%>
                {{ if( pathValue ) { }}<div>{{= displayValue }}</div>{{ } else { }}{{= "-" }}{{ } }}{{ } else { }}{{= "-" }}
            {{ } }}
        </div>
    </div>
    {{ }); }}

</core_v1:js_template>