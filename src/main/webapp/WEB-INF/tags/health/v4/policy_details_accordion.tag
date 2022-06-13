<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="id"	 rtexprvalue="true"	 description="accordion's id" %>
<%@ attribute name="hidden"	 rtexprvalue="true"	 description="should the accordion start in a hidden state" %>
<%@ attribute name="title"	 rtexprvalue="true"	 description="title" %>

{{ var excessValue, excessText, copayment; }}
{{ if (typeof obj.hospital.inclusions !== 'undefined') { }}
    {{ if(obj.custom != 'undefined' && obj.custom.reform.tab1 !== 'undefined' && obj.custom.reform.tab1.excess) { }}
        {{ excessText = obj.custom.reform.tab1.excess; }}
    {{ }else{ }}
        {{ excessText = obj.hospital.inclusions.excess; }}
    {{ } }}
    {{ excessValue = obj.hospital.inclusions.excesses.perPolicy; }}
    {{ copayment = obj.hospital.inclusions.copayment;}}
    {{ if (typeof copayment === 'string' && copayment.startsWith('No')) { copayment = 'No'; } }}
{{ } }}

<health_v4:accordion id="${id}" hidden="${hidden}">
    <jsp:attribute name="title">
        ${title}
    </jsp:attribute>
    <jsp:body>
        <div class="policy-details">
            <div class="policy-details-body start-date">
                <span class="content-title">Policy start date</span>
                <span class="content-value startDate">{{= (typeof meerkat.modules.healthCoverStartDate !== 'undefined' ?meerkat.modules.healthCoverStartDate.getVal() : obj.startDateString )}}</span>
            </div>
            <div class="policy-details-body excess"><span class="content-title">Excess</span><span class="content-value">{{= excessValue }}</span></div>
            <div class="policy-details-body excess-text">{{= excessText }}</div>
            <div class="policy-details-body co-payment"><span class="content-title">Co-payment / % Hospital contribution</span>
                <span class="content-value">{{= (typeof copayment === 'string' && copayment.trim().startsWith('No')) ? 'No' : copayment }}</span>
            </div>
        </div>
        {{ if (typeof meerkat.modules.healthCoverStartDate !== 'undefined') { }}
            <div class="about-this-product-link hidden-lg hidden-md hidden-sm">
                <a href="javascript:;" class="about-this-fund">About this fund</a>
            </div>
        {{ } }}
    </jsp:body>
</health_v4:accordion>
