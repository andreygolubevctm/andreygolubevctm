<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>
<%-- NOTE: We don't use new lines in a few places here to save on extra empty text nodes needing to be created when the template renders --%>
<core_v1:js_template id="feature-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(obj.featuresStructureIndexToUse); }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ for(var i = 0; i < featureIterator.length; i++) { var ft = module.getItem(obj, featureIterator[i]); if(ft.doNotRender === true) { continue; } }}
    <div class="cell {{= ft.classString }}">
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
        <div class="labelInColumn {{= ft.classStringForInlineLabel }} " {{=ft.labelInColumnTitle }}>
            <div class="content {{= ft.labelInColumnContentClass }}" data-featureId="{{= ft.id }}">
                <div class="contentInner" data-analytics="compare BL {{= benefitGroup }}">
                    <div>
                        <span class="health-icon {{= ft.iconClass }}"></span> {{= ft.safeName }} {{ if(ft.hasChildFeatures) { }}<span class="icon expander"></span>{{ } }}
                    </div>
                    <div class="benefit-container">
                    {{ if(ft.isRestricted) { }}
                        <span class="restricted-icon margin-icon">R</span>
                    {{ } else if(ft.isNotCovered) { }}
                        <img class="margin-icon" src="brand/ctm/images/cross_lge_gray.png"></img>
                    {{ } else { }}
                        <img class="margin-icon" src="brand/ctm/images/tick.png"></img>
                    {{ } }}
                        Now
                    </div>
                     <c:set var="simplesHealthReformMessaging" scope="request"><content:get key="simplesHealthReformMessaging" /></c:set>

                    <c:choose>
                    <c:when test="${simplesHealthReformMessaging eq 'active'}">
                        <div class="benefit-container">
                            {{ if(ft.isRestrictedApril) { }}
                                <span class="restricted-icon margin-icon">R</span>
                            {{ } else if(ft.isNotCoveredApril) { }}
                                <img class="margin-icon" src="brand/ctm/images/cross_lge_gray.png"></img>
                            {{ } else { }}
                                <img class="margin-icon" src="brand/ctm/images/tick.png"></img>
                            {{ } }}
                            From April 1
                        </div>
                    </c:when>
                    </c:choose>

                </div>
            </div>
        </div>{{ } }}
        {{ if(ft.type == 'feature') { }}<div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">{{= ft.displayValue }}</div>{{ } }}
        {{ } if(ft.displayChildren) { }}
        <div class="children {{= ft.hideChildrenClass }}" data-fid="{{= ft.id }}">
            {{ if(ft.isNotCovered) { }}<div class="content noCoverContainer"><p class="noCoverLabel">NOT COVERED IN THIS PRODUCT</p></div>{{ } }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{= Results.cachedProcessedTemplates[obj.featuresTemplate](obj) }}{{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected, it  --%>
        </div>
        {{ } else { }}{{ delete obj.childFeatureDetails; }}{{ } }}
    </div>
    {{ } }}
</core_v1:js_template>
