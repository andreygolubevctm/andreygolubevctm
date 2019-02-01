<%@ tag description="The Health Excess feature template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- NOTE: This is currently hard-coded because there are no feature details
    for the individual excess prices that are being added to the model during this project --%>
<core_v1:js_template id="results-features-excess-template">
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var feature = module.getItem(obj, Features.getPageStructure(obj.featuresStructureIndexToUse)[0]); }}
    {{ var feature = module.getItem(obj, Features.getPageStructure(obj.featuresStructureIndexToUse)[0]); }}

    {{ var excessData = module.getExcessPrices(obj); if(excessData.hasExcesses) { }}
    <div class="cell category">
        <div class="content" data-featureId="{{= feature.id }}">
            <div class="featureLabel">
                {{= feature.safeName }}
            </div>
            <div class="featureValue">
                <span class="excess-value">{{= excessData.perAdmission }} <small>/admission</small></span>
            </div>
            <div class="clearfix"></div>
        </div>
    </div>
        <div class="cell category">
        <div class="content" data-featureId="{{= feature.id }}">
            <div class="featureLabel">
                Excess Waivers
            </div>
            <div class="featureValue">
                <span>{{= obj.hospital.inclusions.waivers }}</span>
            </div>
            <div class="clearfix"></div>
        </div>
    </div>
    {{ } }}
    {{ _.each(feature.children, function(ft) { }}
    {{ if((excessData.hasExcesses && ft.name == "Excess") || (ft.classStringForInlineLabel.indexOf('more-info-only') != -1)) { return; } }}
    {{ ft = module.getExcessItem(obj, ft); }}
    <div class="cell {{= ft.classString }}">
        <div class="content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
            <div class="featureLabel">{{= ft.safeName }}</div><div class="featureValue">{{= ft.displayValue }}</div><div class="clearfix"></div>
        </div>
    </div>
    {{ }); }}
</core_v1:js_template>