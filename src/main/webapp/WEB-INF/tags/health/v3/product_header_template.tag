<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="result">
    <div class="resultInsert">
        <div class="result-header-utility-bar">
            {{ if( info.restrictedFund === 'Y' ) { }}
            <div class="restrictedFund" data-title="This is a Restricted Fund" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                 data-at="bottom center" data-content="#restrictedFundText" data-class="restrictedTooltips">Restricted Fund (?)
            </div>
            {{ } else { }}
            <div class="utility-bar-blank">&nbsp;</div>
            {{ } }}
            <div class="filter-component remove-result hidden-xs">
                <span class="icon icon-cross" title="Remove this product"></span>
            </div>
        </div>
        <div class="results-header-inner-container">
            <div class="productSummary vertical results">
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
                {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
                {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                {{= logoTemplate(obj) }}
                {{= priceTemplate(obj) }}
            </div>

            <a class="btn btn-cta btn-block btn-more-info more-info-showapply" href="javascript:;" data-productId="{{= productId }}">
                <div class="more-info-text">More Info</div>
            </a>
            {{ var brochureTemplate = meerkat.modules.templateCache.getTemplate($("#brochure-download-template")); }}
            {{= brochureTemplate(obj) }}

            {{ var specialOffer = Features.getPageStructure()[0]; }}
            {{ var pathValue = Object.byString( obj, specialOffer.resultPath ); }}
            {{ var displayValue = Features.parseFeatureValue( pathValue, true ); }}

            <fieldset class="hide-on-affix result-special-offer {{ if (!pathValue) { }}invisible{{ } }}">
                <legend>Special Offer</legend>
                {{= displayValue }}
            </fieldset>
        </div>
    </div>
</div>
