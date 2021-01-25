<%@ tag description="The Health Brochure Download button template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="btnAttribute"><field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" /></c:set>

<core_v1:js_template id="brochure-download-template">
    {{ var coverType = !_.isEmpty(promo.coverType) ? promo.coverType : meerkat.modules.healthBenefitsCoverType.getCoverType(); }}
    <p class="brochure-download-label">Download Printable Brochure{{= (coverType == 'C' ? 's' : '') }}</p>
    <div class="row">
        {{ if(coverType == 'C' && promo.hospitalPDF == promo.extrasPDF) { }}
        <div class="col-xs-12 text-center">
            <a class="hide-on-affix" href="{{= promo.hospitalPDF }}" target="_blank" ${btnAttribute}>Hospital and Extras</a>
        </div>
        {{ } else if(coverType == 'C' && promo.hospitalPDF != promo.extrasPDF) { }}
        <div class="col-xs-4 col-xs-offset-2"><a class="hide-on-affix" href="{{= promo.hospitalPDF }}" target="_blank" ${btnAttribute}>Hospital</a></div>
        <div class="col-xs-4"><a class="hide-on-affix" href="{{= promo.extrasPDF }}" target="_blank" ${btnAttribute}>Extras</a></div>
        {{ } else { }}
        {{ var pdfLink = coverType == 'H' ? promo.hospitalPDF : (coverType == 'E' ? promo.extrasPDF : ''); }}
        {{ var pdfLabel = coverType == 'H' ? 'Hospital' : 'Extras'; }}
        {{ if(pdfLink != '') { }}
        <div class="col-xs-12">
            <a class="hide-on-affix" href="{{= pdfLink }}" target="_blank">{{= pdfLabel }}</a>
        </div>
        {{ } }}
        {{ } }}
    </div>
</core_v1:js_template>