<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var hasCustomHeaderContent = custom.info && custom.info.content && custom.info.content.results && custom.info.content.results.header; }}

<div class="result">
    <div class="resultInsert">
        {{ if (!_.isEmpty(obj.promo) && !_.isEmpty(obj.promo.discountText)) { }}
        <div class="discountPanel">
            <span class="text">Discount<br />Available</span>
        </div>
        {{ } }}
        <div class="result-header-utility-bar">
            {{ if( hasCustomHeaderContent ) { }}
            <div class="customHeaderContent" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                 data-at="bottom center" data-content="{{= custom.info.content.results.header.text}}" data-class="resultHeaderTooltips">{{= custom.info.content.results.header.label}} (?)
            </div>
            {{ } else { }}
            <div class="utility-bar-blank">&nbsp;</div>
            {{ } }}
            <div class="filter-component display-on-hover small remove-result hidden-xs {{= hasCustomHeaderContent ? 'hasCustomHeaderContent' : ''}}" data-productId="{{= obj.productId }}">
                <a href="javascript:;" title="Hide this product" <field_v1:analytics_attr analVal="remove {{= obj.info.provider }}" quoteChar="\"" />>Hide product</a>
            </div>
            <div class="filter-component display-on-hover small pin-result pin-result-label hidden-xs" data-productId="{{= obj.productId }}">
                <a href="javascript:;" title="Pin this result" <field_v1:analytics_attr analVal="pin {{= obj.info.provider }}" quoteChar="\"" />>Pin as favourite</a>
            </div>
            <div class="filter-component display-on-hover small pin-result pin-result-icon hidden-xs" data-productId="{{= obj.productId }}">
                <span class="icon icon-pin" title="Pin this result" <field_v1:analytics_attr analVal="pin {{= obj.info.provider }}" quoteChar="\"" />></span>
            </div>
        </div>
        <div class="results-header-inner-container">
            <div class="productSummary vertical results">
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
                {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
                {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                <div class="open-more-info more-info-showapply">
                    {{= priceTemplate(obj) }}
                </div>
                {{= logoTemplate(obj) }}
            </div>

            <a class="btn btn-cta btn-block btn-more-info more-info-showapply" href="javascript:;" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>
                <div class="more-info-text">View Product <span class="icon icon-angle-right"></span></div>
            </a>
            {{ var brochureTemplate = meerkat.modules.templateCache.getTemplate($("#brochure-download-template")); }}
            <div class="brochure-container text-center">
                {{= brochureTemplate(obj) }}
            </div>

            <%--{{ var result = meerkat.modules.healthResultsTemplate.getSpecialOffer(obj); }}
                {{= result.displayValue }}--%>
        </div>
    </div>
</div>
