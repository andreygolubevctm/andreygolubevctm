<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var excessValue, excessText, copayment; }}
{{ if (typeof obj.hospital.inclusions !== 'undefined') { }}
    {{ if(obj.custom != 'undefined' && obj.custom.reform.tab1 !== 'undefined' && obj.custom.reform.tab1.excess) { }}
        {{ excessText = obj.custom.reform.tab1.excess; }}
    {{ }else{ }}
        {{ excessText = obj.hospital.inclusions.excess; }}
    {{ } }}
    {{ excessValue = obj.hospital.inclusions.excesses.perPolicy; }}
    {{ copayment = obj.hospital.inclusions.copayment; }}
{{ } }}

<div class="policy-details">
    <div class="policy-details-header">POLICY DETAILS</div>
    <div class="policy-details-body start-date"><span class="content-title">Policy start date</span><span class="content-value">{{= meerkat.modules.healthCoverStartDate.getVal() }}</span></div>
    <div class="policy-details-body excess"><span class="content-title">Excess</span><span class="content-value">{{= excessValue }}</span></div>
    <div class="policy-details-body excess-text">{{= excessText }}</div>
    <div class="policy-details-body co-payment"><span class="content-title">Co-payment / % Hospital contribution</span>
        <span class="content-value">{{= (typeof copayment === 'string' && copayment.trim().startsWith('No')) ? 'No' : copayment }}</span>
    </div>
</div>

