<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="moreInfoProductWidget_v2" id="moreInfoProductWidget">
    <div class="col-xs-12 productWidgetSection flex">
        <div class="companyLogo {{= info.provider }}"></div>
    </div>
    <div class="col-xs-12 productWidgetSection">
        <h3 class="productWidgetName">{{= info.productTitle }}</h3>
    </div>
    <c:if test="${onlineHealthReformMessaging eq 'Y'}">
        <div class="col-xs-12 productWidgetSection">
            {{ var classification = meerkat.modules.healthResultsTemplate.getClassification(obj); }}
            {{ var isExtrasOnly = info.ProductType === 'Ancillary' || info.ProductType === 'GeneralHealth'; }}
            {{ var icon = isExtrasOnly ? 'small-height' : classification.icon; }}
            {{ var classificationDate = ''; }}

            {{ if(classification.date && classification.icon !== 'gov-unclassified') { }}
                {{ classificationDate = 'As of ' + classification.date; }}
            {{ } }}

            {{ if(!isExtrasOnly) { }}
            <div class="results-header-classification">
                <div class="more-info-classification-icon {{= icon}}"></div>
            </div>
            {{ } }}
        </div>
    </c:if>
    <div class="col-xs-12 productWidgetSection">
        <div class="col-xs-12">
            {{ if (hospital && typeof hospitalCover !== 'undefined') { }}
            <div class="brochureLink">
                <img src="assets/brand/ctm/images/file-alt.png" class="productWidgetIcon_v2"/>
            	{{ if(promo.hospitalPDF.indexOf('http') === -1) { }}
                    <a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>View hospital brochure</a>
				{{ } else { }}
                    <a href="{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>View hospital brochure</a>
				{{ } }}
            </div>
            {{ } }}
            {{ if (typeof extrasCover !== 'undefined') { }}
            <div class="brochureLink">
                <img src="assets/brand/ctm/images/file-alt.png" class="productWidgetIcon_v2"/>
            {{ if(promo.extrasPDF.indexOf('http') === -1) { }}
                <a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure">View extras brochure</a>
			{{ } else { }}
                <a href="{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure">View extras brochure</a>
			{{ } }}
            </div>
            {{ } }}
            <div class="brochureLink printableBrochures">
                <img src="assets/brand/ctm/images/envelope.png" class="productWidgetIcon_v2"/>
                <a href="javascript:;" class="getPrintableBrochures">Email brochures</a>
            </div>
        </div>
    </div>
    <div class="col-xs-12 productWidgetSection hidden-xs">
        <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now <span class="icon-angle-right" /></a>
    </div>
</div>
