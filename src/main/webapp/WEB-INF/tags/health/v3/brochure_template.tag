<%@ tag description="The Health Brochure Download button template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="brochure-download-template">
    {{ var coverType = meerkat.modules.health.getCoverType(); }}
    {{ if(coverType == 'C' && promo.hospitalPDF == promo.extrasPDF) { }}
    <a class="hide-on-affix btn btn-block btn-download" href="{{= promo.hospitalPDF }}" target="_blank">Download Brochure</a>
    {{ } else if(coverType == 'C' && promo.hospitalPDF != promo.extrasPDF) { }}
    <a class="hide-on-affix btn btn-block btn-download" href="javascript:;" data-title="" data-toggle="popover" data-adjust-y="5" data-trigger=" click" data-my="top center" data-at="bottom center"
       data-content="#brochurePopover{{= productId }}">Download Brochures</a>
    <div id="brochurePopover{{= productId }}" class="hidden">
        <a class="btn btn-block btn-tertiary" href="{{= promo.hospitalPDF }}" target="_blank">Hospital Brochure</a>
        <a class="btn btn-block btn-secondary" href="{{= promo.extrasPDF }}" target="_blank">Extras Brochures</a>
    </div>
    {{ } else { }}
    {{ if(coverType == 'H') { }} <a class="btn btn-block btn-download" href="{{= promo.hospitalPDF }}" target="_blank">Download Brochure</a> {{ } }}
    {{ if(coverType == 'E') { }} <a class="btn btn-block btn-download" href="{{= promo.extrasPDF }}" target="_blank">Download Brochure</a> {{ } }}
    {{ } }}
</core_v1:js_template>