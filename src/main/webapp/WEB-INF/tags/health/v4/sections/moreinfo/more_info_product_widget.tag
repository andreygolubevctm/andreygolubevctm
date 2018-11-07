<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="moreInfoProductWidget" id="moreInfoProductWidget">
    <div class="col-xs-12 productWidgetHeader">&nbsp;</div>
    <div class="col-xs-12">
        <div class="companyLogo {{= info.provider }}"></div>
        <h3 class="productWidgetName">{{= info.productTitle }}</h3>
        <div class="row">
            <div class="col-xs-3">
                <img src="assets/brand/ctm/images/{{= custom.reform.tier.toLowerCase()}}_classification.svg" class="productWidgetIcon"/>
            </div>
            <div class="col-xs-9">
                <span class="classification">Government classification</span>
                <span class="classification">{{= custom.reform.tier }} April 1</span>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-3">
                <img src="assets/brand/ctm/images/brochure_icon.svg" class="productWidgetIcon"/>
            </div>
            <div class="col-xs-9">
                {{ if (typeof hospitalCover !== 'undefined') { }}
                <div>
                    <a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>View hospital brochure</a>
                </div>
                {{ } }}
                {{ if (typeof extrasCover !== 'undefined') { }}
                <div>
                    <a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure">View extras brochure</a>
                </div>
                {{ } }}
                <div>
                    <a href="javascript:;">Email brochures</a>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="productWidgetApply">
                <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
            </div>
        </div>
    </div>
</div>
