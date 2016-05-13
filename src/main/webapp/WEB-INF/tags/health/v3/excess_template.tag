<%@ tag description="The Health Excess feature template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- NOTE: This is currently hard-coded because there are no feature details
    for the individual excess prices that are being added to the model during this project --%>
<core_v1:js_template id="results-features-excess-template">
    {{ var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0]; }}
    {{ var excessData = Object.byString( obj, "hospital.inclusions.excesses" );  var formatCurrency = meerkat.modules.currencyField.formatCurrency; }}
    <div class="row excessDetailContainer">
        <div class="col-xs-12 col-md-4">
            <p class="excess-label">Per Admission</p>
            <span class="excess-value">{{= formatCurrency(excessData.perAdmission, {roundToDecimalPlace: 0}) }}</span>
        </div>
        <div class="col-xs-12 col-md-4">
            <p class="excess-label">Per Person</p>
            <span class="excess-value">{{= formatCurrency(excessData.perPerson, {roundToDecimalPlace: 0}) }}</span>
        </div>
        <div class="col-xs-12 col-md-4">
            <p class="excess-label">Per Policy</p>
            <span class="excess-value">{{= formatCurrency(excessData.perPolicy, {roundToDecimalPlace: 0}) }}</span>
        </div>
    </div>
    {{ _.each(feature.children, function(ft) { if(ft.name == "Excess") { return; } }}
    <div class="cell {{= ft.classString }}">
        <div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
            {{ var hasResult = ft.resultPath != null && ft.resultPath != ''; }}
            {{ var pathValue = hasResult ? Object.byString( obj, ft.resultPath ) : false; }}
            {{ if(hasResult) { }}
            {{ var displayValue = Features.parseFeatureValue( pathValue, true ); }}<%-- Below compressed to reduce number of whitespace nodes in DOM --%>
            {{ if( pathValue ) { }}
            <div>{{= displayValue }}</div>
            {{ } else { }}{{= "-" }}{{ } }}{{ } else { }}{{= "-" }}
            {{ } }}
        </div>
    </div>
    {{ }); }}
</core_v1:js_template>