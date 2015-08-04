<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="results-summary-template">
    <span class="vertical-middle snapshot-intro">
        <span class="hidden-md">Your quote</span>
        <span class="hidden-lg">Quote</span> <span class="hidden-md">is</span> based on:
    </span>
    <span class="segment vertical-middle">
        {{= data.postcode }}
    </span>

    {{ var segmentClass = data.isSpendEstimate ? "vertical-middle" : data.segmentClass }}

    {{ if(data.electricitySpend || data.electricityPeak || data.electricityOffPeak) { }}
        <span class="segment {{= segmentClass }} ">
            {{ if(data.isSpendEstimate) { }}
                Electricity spend of {{= data.electricitySpend }}
            {{ } else { }}
                Electricity peak usage {{= data.electricityPeak }} <br>
                Electricity off-peak usage {{= data.electricityOffPeak }}
            {{ } }}
        </span>
    {{ } }}

    {{ if(data.gasSpend || data.gasPeak || data.gasOffPeak) { }}
        <span class="segment segment-last {{= segmentClass }}">
            {{ if(data.isSpendEstimate) { }}
                Gas spend of {{= data.gasSpend }}
            {{ } else { }}
                Gas peak usage {{= data.gasPeak }} <br>
                Gas off-peak usage {{= data.gasOffPeak }}
            {{ } }}
        </span>
    {{ } }}
</core:js_template>