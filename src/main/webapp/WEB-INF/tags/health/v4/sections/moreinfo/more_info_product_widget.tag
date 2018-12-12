<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="moreInfoProductWidget" id="moreInfoProductWidget">
    <div class="col-xs-12 productWidgetSection productWidgetHeader"></div>
    <div class="col-xs-12 productWidgetSection flex">
        <div class="companyLogo {{= info.provider }}"></div>
    </div>
    <div class="col-xs-12 productWidgetSection">
        <h3 class="productWidgetName">{{= info.productTitle }}</h3>
    </div>
    <c:if test="${onlineHealthReformMessaging eq true}">
        <div class="col-xs-12 productWidgetSection">
            {{ var classification = meerkat.modules.healthResultsTemplate.getClassification(obj); }}
            <div class="more-info-classification-icon {{= classification.icon}}" />
        </div>
    </c:if>
    <div class="col-xs-12 productWidgetSection">
        <div class="col-md-2 col-md-offset-0 col-xs-2 col-xs-offset-1 productWidgetIconWrapper">
            <img src="assets/brand/ctm/images/brochure_icon.svg" class="productWidgetIcon"/>
        </div>
        <div class="col-md-10 col-xs-9">
            {{ if (typeof hospitalCover !== 'undefined') { }}
            <div class="brochureLink">
                <a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="download-hospital-brochure" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />>View hospital brochure</a>
            </div>
            {{ } }}
            {{ if (typeof extrasCover !== 'undefined') { }}
            <div class="brochureLink">
                <a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="download-extras-brochure">View extras brochure</a>
            </div>
            {{ } }}
            <div class="brochureLink printableBrochures">
                <a href="javascript:;" class="getPrintableBrochures">Email brochures</a>
            </div>
        </div>
    </div>
    <div class="col-xs-12 productWidgetSection hidden-xs">
        <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now <span class="icon-angle-right" /></a>
    </div>
</div>
