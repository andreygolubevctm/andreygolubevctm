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
        {{ if(ft.type == 'category') { }}<div class="labelInColumn {{= ft.classStringForInlineLabel }} " {{=ft.labelInColumnTitle }}>
            <div class="content {{= ft.labelInColumnContentClass }}" data-featureId="{{= ft.id }}">
                <div class="contentInner" <field_v1:analytics_attr analVal="compare BL {{= ft.shortlistKey }}" quoteChar="\"" />>
                    <span class="health-icon {{= ft.iconClass }}"></span> {{= ft.safeName }} {{ if(ft.isRestricted) { }}<sup title="Restricted">#</sup>{{ } }} {{ if(ft.hasChildFeatures) { }}<span class="icon expander"></span>{{ } }}
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
