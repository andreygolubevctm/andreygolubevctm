<%@ tag description="The Health Brochure Download button template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="btnAttribute"><field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" /></c:set>

<core_v1:js_template id="brochure-download-template">
    {{ var coverType = !_.isEmpty(promo.coverType) ? promo.coverType : meerkat.modules.health.getCoverType(); }}
    {{ if(coverType == 'C' && promo.hospitalPDF == promo.extrasPDF) { }}
    <a class="btn btn-block btn-download" href="{{= promo.hospitalPDF }}" target="_blank" ${btnAttribute}>Download Brochures</a>
    {{ } else if(coverType == 'C' && promo.hospitalPDF != promo.extrasPDF) { }}
    <a class="btn btn-block btn-download" href="javascript:;" data-class="brochuresTooltip" data-toggle="popover" data-adjust-y="5" data-trigger="click" data-my="top center" data-at="bottom center" data-scroll="false" data-content="#brochurePopover{{= productId }}" ${btnAttribute}>Download Brochures</a>
    <div id="brochurePopover{{= productId }}" class="hidden">
        <div class="row">
            <div class="col-xs-12 col-md-6 brochureRow">
                <a class="btn btn-block btn-sm btn-tertiary" href="{{= promo.hospitalPDF }}" target="_blank">Hospital <span class="icon icon-angle-down"></span></a>
            </div>
            <div class="col-xs-12 col-md-6 brochureRow">
                <a class="btn btn-block btn-sm btn-secondary" href="{{= promo.extrasPDF }}" target="_blank">Extras <span class="icon icon-angle-down"></span></a>
            </div>
        </div>
    </div>
    {{ } else { }}
        {{ var pdfLink = coverType == 'H' ? promo.hospitalPDF : (coverType == 'E' ? promo.extrasPDF : ''); }}
        {{ if(pdfLink != '') { }} <a class="btn btn-block btn-download" href="{{= pdfLink }}" target="_blank">Download Brochure</a> {{ } }}
    {{ } }}
</core_v1:js_template>