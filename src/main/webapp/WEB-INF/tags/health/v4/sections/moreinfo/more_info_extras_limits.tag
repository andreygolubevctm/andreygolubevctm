<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>
<%-- NOTE: We don't use new lines in a few places here to save on extra empty text nodes needing to be created when the template renders --%>
<core_v1:js_template id="extras-limits-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(5); }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ obj.featuresTemplate = '#extras-limits-template'; }}
    {{ Results.cachedProcessedTemplates[obj.featuresTemplate] = _.template($(obj.featuresTemplate).html()); }}
    {{ for(var i = 0; i < featureIterator.length; i++) { }}
    <div class="cell ">
        {{ var ft = module.getItem(obj, featureIterator[i]); }}
        {{ if(ft.displayItem) { }}
            {{ if(ft.type == 'category') { }}
                {{ var resultPath = ft.resultPath; }}
                {{ var benefitGroup = ''; }}
                {{ if(!_.isEmpty(resultPath)) { }}
                {{    if(resultPath.indexOf('hospital') === 0) { }}
                {{        benefitGroup = 'hospital'; }}
                {{ } else if (resultPath.indexOf('extras') === 0) { }}
                {{        benefitGroup = 'extras'; }}
                {{ } }}
            {{ } }}
        <div class="col-xs-12">
            <p>{{= ft.safeName }}</p>
        </div>
        {{ } }}
        {{ if(ft.type == 'feature') { }}<div class="col-xs-8">{{= ft.safeName }}</div><div class="col-xs-4">{{= ft.displayValue }}</div></div>{{ } }}
        {{ } if(ft.displayChildren) { }}
        <div class="children {{= ft.hideChildrenClass }}" data-fid="{{= ft.id }}">xxxxxxxxxxxxxxxxxxxx
            {{ obj.childFeatureDetails = ft.children; }}
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="limits-label">Limits</div> {{ } }}
            {{= Results.cachedProcessedTemplates[obj.featuresTemplate](obj) }}
            {{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected, it  --%>
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="cell featureGroupLimit text-center"><div class="content">group limits may apply<br /><a href="javascript:;" class="open-more-info">View Product <span class="icon icon-angle-right"></span></a></div></div> {{ } }}
        </div>
        {{ } else { }}{{ delete obj.childFeatureDetails; }}{{ } }}
    </div>
    {{ } }}
</core_v1:js_template>
