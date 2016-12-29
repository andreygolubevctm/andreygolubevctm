<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>
<%-- NOTE: We don't use new lines in a few places here to save on extra empty text nodes needing to be created when the template renders --%>
<script id="extrasLimitsTemplate" type="text/html">
    {{ if (_.isUndefined(Results.cachedProcessedTemplates['#extrasLimitsTemplate'])) { }}
        {{ Results.cachedProcessedTemplates['#extrasLimitsTemplate'] = _.template($('#extrasLimitsTemplate').html()); }}
    {{ } }}
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(5); }}
    {{ var isRenderingChild = _.isUndefined(obj.childFeatureDetails); }}
{{ console.log("CHILD: ", obj.childFeatureDetails); }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ obj.featuresTemplate = '#extrasLimitsTemplate'; }}
    {{ for(var i = 0; i < featureIterator.length; i++) { }}
        {{ var ft = module.getItem(obj, featureIterator[i]); }}
        {{ if (!isRenderingChild && ft.displayItem && ft.type == 'category') { }} <div class="row ">{{ } }}
        {{ if(ft.displayItem && ft.isNotCovered == showNotCoveredBenefits ) { }}
            {{ if (ft.type == 'category') { }}
            <div class="col-xs-12">
                <p>{{= ft.safeName }} {{= isRenderingChild }}</p>
            </div>
            {{ } }}
        {{ if(ft.type == 'feature') { }}<div class="col-xs-8">{{= ft.safeName }} xxxx {{= isRenderingChild }} {{= ft.displayItem }}</div><div class="col-xs-4">{{= ft.displayValue }}</div></div>{{ } }}
        {{ } if(ft.displayChildren) { }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="limits-label">Limits</div> {{ } }}
            {{= Results.cachedProcessedTemplates[obj.featuresTemplate](obj) }}
            {{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected, it  --%>
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="cell featureGroupLimit text-center"><div class="content">group limits may apply<br /><a href="javascript:;" class="open-more-info">View Product <span class="icon icon-angle-right"></span></a></div></div> {{ } }}

        {{ } else { }}{{ delete obj.childFeatureDetails; }}{{ } }}
        {{ if (!isRenderingChild && ft.displayItem && ft.type == 'category') { }} </div>{{ } }}
    {{ } }}
</script>

<script id="extrasLimitsChildrenTemplate" type="text/html">
    {{ var featureIterator = obj.childFeatureDetails; }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ obj.featuresTemplate = '#extrasLimitsChildrenTemplate'; }}
    {{ for(var i = 0; i < featureIterator.length; i++) { }}
    <div class="row ">
        {{ var ft = module.getItem(obj, featureIterator[i]); }}
        {{ if(ft.displayItem && ft.isNotCovered == showNotCoveredBenefits ) { }}
        {{ if (ft.type == 'category') { }}
        <div class="col-xs-12">
            <p>{{= ft.safeName }} - isnotcovered: {{= ft.isNotCovered }} </p>
        </div>
        {{ } }}
        {{ if(ft.type == 'feature') { }}<div class="col-xs-8">{{= ft.safeName }} xxxx {{= ft.type }}</div><div class="col-xs-4">{{= ft.displayValue }}</div></div>{{ } }}
    {{ } if(ft.displayChildren) { }}

    {{ obj.childFeatureDetails = ft.children; }}
    {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="limits-label">Limits</div> {{ } }}
        {{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected, it  --%>
    {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="cell featureGroupLimit text-center"><div class="content">group limits may apply<br /><a href="javascript:;" class="open-more-info">View Product <span class="icon icon-angle-right"></span></a></div></div> {{ } }}

    {{ } else { }}{{ delete obj.childFeatureDetails; }}{{ } }}
    </div>
    {{ } }}
</script>