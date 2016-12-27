<%@ tag description="The Health Extras List section template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="results-features-extras-template">
    {{ var availableBenefits = meerkat.modules.healthResultsTemplate.getAvailableBenefits(obj); }}
    {{ var onlyHasOneBenefit = availableBenefits.length === 1; }}
    {{ var popoverContent = onlyHasOneBenefit ? "" : meerkat.modules.healthResultsTemplate.getPopOverContent(obj, availableBenefits); }}
    <div class="cell category">
        <div class="content isMultiRow" data-featureId="99999">
            {{ if (!onlyHasOneBenefit) { }}<a data-toggle="popover" data-adjust-y="0" data-trigger="click" data-my="bottom center" data-at="top center" data-content="{{= popoverContent }}" data-class="resultsOtherBenefitsTooltip">{{= availableBenefits[0].safeName }} and {{= (availableBenefits.length - 1) }} more</a>
            {{ } else { }}Also includes {{= availableBenefits[0].safeName }}{{ } }}
        </div>
    </div>
</core_v1:js_template>