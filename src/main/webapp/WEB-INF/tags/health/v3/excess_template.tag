<%@ tag description="The Health Excess feature template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- NOTE: This is currently hard-coded because there are no feature details
    for the individual excess prices that are being added to the model during this project --%>
<core_v1:js_template id="results-features-excess-template">
    {{ var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0]; }}
    {{ var excessData = meerkat.modules.healthResultsTemplate.getExcessPrices(obj); if(excessData.hasExcesses) { }}
    <div class="row excessDetailContainer">
        <div class="col-xs-12 col-md-4">
            <p class="excess-label">Per Admission</p>
            <span class="excess-value">{{= excessData.perAdmission }}</span>
        </div>
        <div class="col-xs-12 col-md-4">
            <p class="excess-label">Per Person</p>
            <span class="excess-value">{{= excessData.perPerson }}</span>
        </div>
        <div class="col-xs-12 col-md-4">
            <p class="excess-label">Per Policy</p>
            <span class="excess-value">{{= excessData.perPolicy }}</span>
        </div>
    </div>{{ } }}
    {{ _.each(feature.children, function(ft) { if(excessData.hasExcesses && ft.name == "Excess" || ft.name == "Pre Existing Waiting Period") { return; } }}
    <div class="cell {{= ft.classString }}">
        <div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
            {{= meerkat.modules.healthResultsTemplate.getExcessChildDisplayValue(obj, ft) }}
        </div>
    </div>{{ }); }}

    <div class="cell">
        <div class="content">
            Includes Accident Override:
            <strong>{{ if(!_.isEmpty(obj.accident) && obj.accident.covered === 'Y') { }}Yes{{ }else{ }}No{{ } }}</strong>
        </div>
    </div>
</core_v1:js_template>