<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="results-summary-template">
    <span class="vertical-middle snapshot-intro">
        <span class="hidden-md">Your quote</span>
        <span class="hidden-lg">Quote</span> <span class="hidden-md">is</span> based on:
    </span>
    <span class="segment vertical-middle">
        {{= obj.postcode }}
    </span>

    {{ var segmentClass = obj.isSpendEstimate ? "vertical-middle" : obj.segmentClass }}

    {{ if(obj.electricitySpend || obj.electricityPeak || obj.electricityOffPeak) { }}
        <span class="segment {{= segmentClass }} ">
            {{ if(obj.isSpendEstimate) { }}
                Electricity spend of {{= obj.electricitySpend }}
            {{ } else { }}
                Electricity peak usage {{= obj.electricityPeak }} <br>
                Electricity off-peak usage {{= obj.electricityOffPeak }}
            {{ } }}
        </span>
    {{ } }}

    {{ if(obj.gasSpend || obj.gasPeak || obj.gasOffPeak) { }}
        <span class="segment segment-last {{= segmentClass }}">
            {{ if(obj.isSpendEstimate) { }}
                Gas spend of {{= obj.gasSpend }}
            {{ } else { }}
                Gas peak usage {{= obj.gasPeak }} <br>
                Gas off-peak usage {{= obj.gasOffPeak }}
            {{ } }}
        </span>
    {{ } }}
</core:js_template>