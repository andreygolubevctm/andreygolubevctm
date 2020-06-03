<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>
<%-- NOTE: We don't use new lines in a few places here to save on extra empty text nodes needing to be created when the template renders --%>
<script id="benefitLimitsTemplate" type="text/html">
    {{ obj.featuresTemplate = '#benefitLimitsTemplate'; }}

    {{ if ( _.isUndefined(Results.cachedProcessedTemplates[obj.featuresTemplate])) { }}
        {{ Results.cachedProcessedTemplates[obj.featuresTemplate] = _.template($(obj.featuresTemplate).html()); }}
    {{ } }}

    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(obj.structureIndex); }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}

    {{ for(var i = 0; i < featureIterator.length; i++) { }}
        {{ var ft = module.getItem(obj, featureIterator[i]); }}
        {{ var renderRow = ft.displayItem && ft.type == 'category' && ft.isNotCovered == obj.showNotCoveredBenefits && ft.isRestricted == false; }}

        {{ if (renderRow) { }} <div class="row benefitRow"><div class="benefitContent">{{ } }}
        {{ if(ft.displayItem && ft.isNotCovered == obj.showNotCoveredBenefits && ft.isRestricted == false) { }}
            {{ if (ft.type == 'category') { }}
            <div class="col-xs-7 benefitTitle">
                <p>{{= ft.safeName }}</p>
            </div>
            {{ } }}
        {{ if(ft.type == 'feature') { }}
                <div class="col-xs-2 limitTitle">&nbsp;</div>
                <div class="col-xs-3 limitValue">{{= ft.displayValue }}</div>
        {{ } }}
        {{ } if(ft.displayChildren && (ft.isNotCovered == obj.showNotCoveredBenefits || obj.ignoreLimits) && ft.isRestricted == false) { }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="limits-label">Limits</div> {{ } }}
            {{= Results.cachedProcessedTemplates[obj.featuresTemplate](obj) }}
            {{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected, it  --%>
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="cell featureGroupLimit text-center"><div class="content">group limits may apply<br /><a href="javascript:;" class="open-more-info" data-productId="{{= obj.productId }}" data-available="{{= obj.available }}">View Product <span class="icon icon-angle-right"></span></a></div></div> {{ } }}

        {{ } else {  delete obj.childFeatureDetails;  } }}
        {{ if (renderRow) { }}</div></div>{{ } }}
    {{ } }}
</script>