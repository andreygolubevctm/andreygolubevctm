<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-home-template">

    {{ var addressDetails = typeof obj.property != 'undefined' && typeof obj.property.address != 'undefined' ? obj.property.address : {}; }}
    {{ var coverAmountDetails = typeof obj.coverAmounts != 'undefined' ? obj.coverAmounts : {}; }}

    <h5>{{= obj.coverType.replace(' Cover', '') }} Insurance</h5>

    {{ if(addressDetails.fullAddressLineOne && addressDetails.suburbName) { }}
    <div class="quote-detail">
        <strong>Address: </strong> {{= addressDetails.fullAddressLineOne }}, {{= addressDetails.suburbName }}
    </div>
    {{ } }}
    {{ if(coverAmountDetails.rebuildCostentry) { }}
    <div class="quote-detail">
        <strong>Home Value: </strong> {{= coverAmountDetails.rebuildCostentry }}
    </div>
    {{ } }}
    {{ if(coverAmountDetails.replaceContentsCostentry) { }}
    <div class="quote-detail">
        <strong>Contents Value: </strong> {{= coverAmountDetails.replaceContentsCostentry }}
    </div>
    {{ } }}
</core:js_template>