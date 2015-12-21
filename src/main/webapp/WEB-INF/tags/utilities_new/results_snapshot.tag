<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="results-summary-template">
    <span class="vertical-middle snapshot-intro">
        <span class="hidden-md">Your quote</span>
        <span class="hidden-lg">Quote</span> <span class="hidden-md">is</span> based on:
    </span>
    <span class="segment vertical-middle">
        {{= obj.postcode }}
    </span>

    {{ if(obj.electricitySpend || obj.electricityPeak || obj.electricityOffPeak) { }}
        <span class="segment usage ">
            {{ if(obj.recentElectricityBill === 'Y') { }}
                Electricity peak usage {{= obj.electricityPeak }} <br>
                Electricity off-peak usage {{= obj.electricityOffPeak }}
                {{ if(obj.electricityShoulder !== '') { }}
                    <br>Electricity shoulder usage {{= obj.electricityShoulder }}
                {{ } }}
            {{ } else { }}
                Estimated electricity usage is: {{= obj.electricitySpend }}
            {{ } }}
        </span>
    {{ } }}

    {{ if(obj.gasSpend || obj.gasPeak || obj.gasOffPeak) { }}
        <span class="segment segment-last usage">
            {{ if(obj.recentGasBill === 'Y') { }}
                Gas peak usage {{= obj.gasPeak }} <br>
                Gas off-peak usage {{= obj.gasOffPeak }}
            {{ } else { }}
                Estimated gas usage: {{= obj.gasSpend }}
            {{ } }}
        </span>
    {{ } }}
</core_v1:js_template>