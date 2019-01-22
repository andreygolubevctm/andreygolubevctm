<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>
<%-- NOTE: We don't use new lines in a few places here to save on extra empty text nodes needing to be created when the template renders --%>
<core_v1:js_template id="feature-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(obj.featuresStructureIndexToUse); }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var coverDate = module.getCoverDate(obj); }}
    {{ for(var i = 0; i < featureIterator.length; i++) { var ft = module.getItem(obj, featureIterator[i]); }}
    {{ if(ft.classStringForInlineLabel.indexOf('more-info-only') != -1) { continue; } }}
    <div class="cell {{= ft.classString }}" title="Click on each benefit to learn about what level of cover this policy offers.">
        {{ if(ft.displayItem) { }}
        {{ if(ft.type == 'category') { }}
        {{ var resultPath = ft.resultPath; }}
        {{ var benefitGroup = ''; }}
        {{ if(!_.isEmpty(resultPath)) { }}
        {{      if(resultPath.indexOf('hospital') === 0) { }}
        {{          benefitGroup = 'hospital'; }}
        {{      } else if (resultPath.indexOf('extras') === 0) { }}
        {{          benefitGroup = 'extras'; }}
        {{      } }}
        {{ } }}
        <div class="labelInColumn {{= ft.classStringForInlineLabel }} {{= ft.classStringForInlineLabelCover }}">
            <div class="content" data-featureId="{{= ft.id }}">
                <div class="contentInner" data-analytics="compare BL {{= benefitGroup }}">
                    <div class="cover-title">
                        <span class="health-icon {{= ft.iconClass }}"></span> {{= ft.safeName }} {{ if(ft.hasChildFeatures) { }}<span class="icon expander"></span>{{ } }}
                    </div>
                    <div class="benefit-container">
                        <div class="benefit-container-item {{= ft.labelInColumnContentClass }}">
                            <span {{= ft.labelInColumnContentClassApril }}>Now</span>
                            <span class="benefit-icon" />
                        </div>
                        <div class="benefit-container-item april {{= ft.labelInColumnContentClassApril }}">
                            <span class="benefit-container-item-date">{{= coverDate}}</span>
                            <span class="benefit-icon" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {{ } }}
        {{ if(ft.type == 'feature') { }}<div class="content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}"><div class="featureLabel">{{= ft.safeName }}</div><div class="featureValue">{{= ft.displayValue }}</div></div>{{ } }}
        {{ } if(ft.displayChildren) { }}
        <div class="children {{= ft.hideChildrenClass }}" data-fid="{{= ft.id }}">
            {{ if(ft.isNotCovered) { }}
            <div class="content noCoverContainer"><h5 class="noCoverLabel">Not Covered</h5></div>
            {{ } }}
            {{ if(ft.type == 'category' && obj.featureType == 'hospital') { }}
            <h5 class="restrictedLabel{{ if(!ft.isRestricted) { }} invisible{{ } }}">Restricted Benefit</h5>
            {{ } }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }} <div class="limits-label{{ if(ft.isNotCovered) { }} invisible{{ } }}">Limits</div> {{ } }}
            {{= Results.cachedProcessedTemplates[obj.featuresTemplate](obj) }}{{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected  --%>
            {{ if(ft.type == 'category' && obj.featureType == 'extras') { }}
            <div class="cell featureGroupLimit text-center">
                <div class="content">
                    <span class="{{ if(ft.isNotCovered) { }}invisible{{ } }}">group limits may apply</span><br />
                    <a href="javascript:;" class="open-more-info" data-productId="{{= obj.productId }}" data-available="{{= obj.available }}">
                        View Product <span class="icon icon-angle-right"></span>
                    </a>
                </div>
            </div>
            {{ } }}
        </div>
        {{ } else { }}{{ delete obj.childFeatureDetails; }}{{ } }}
    </div>
    {{ } }}
</core_v1:js_template>
