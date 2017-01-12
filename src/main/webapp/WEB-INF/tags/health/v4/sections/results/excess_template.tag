<%@ tag description="The Health Excess feature template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- NOTE: This is currently hard-coded because there are no feature details
    for the individual excess prices that are being added to the model during this project --%>
<core_v1:js_template id="results-features-excess-template">
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var feature = module.getItem(obj, Features.getPageStructure(obj.featuresStructureIndexToUse)[0]); }}
    {{ var excessData = module.getExcessPrices(obj); if(excessData.hasExcesses) { }}
    <div class="cell category expandable collapsed ">
        <div class="labelInColumn category expandable collapsed">
            <div class="content" data-featureId="{{= feature.id }}">
                <div class="contentInner">
                    {{= feature.safeName }} {{ if(feature.hasChildFeatures) { }}<span class="icon expander"></span>{{ } }}
                </div>
            </div>
        </div>
        <div class="children row excessDetailContainer text-center" data-fid="{{= feature.id }}">
            <div class="col-xs-4">
                <span class="excess-value">{{= excessData.perAdmission }}</span>
                <p class="excess-label">/admission</p>
            </div>
            <div class="col-xs-4">
                <span class="excess-value">{{= excessData.perPerson }}</span>
                <p class="excess-label">/person</p>
            </div>
            <div class="col-xs-4">
                <span class="excess-value">{{= excessData.perPolicy }}</span>
                <p class="excess-label">/policy</p>
            </div>
        </div>
    </div>
    {{ } }}
    {{ _.each(feature.children, function(ft) { }}{{ if(excessData.hasExcesses && ft.name == "Excess") { return; } }}
    {{ ft = module.getExcessItem(obj, ft); }}<div class="cell {{= ft.classString }}">
        <div class="content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
            <div class="featureLabel">{{= ft.safeName }}</div><div class="featureValue">{{= ft.displayValue }}</div><div class="clearfix"></div>
        </div>
    </div>
    {{ }); }}
</core_v1:js_template>