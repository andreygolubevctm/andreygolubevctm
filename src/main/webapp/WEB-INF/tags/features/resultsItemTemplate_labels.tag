<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core:js_template id="feature-template-labels">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(); }}
    {{ var featureTemplateHtml = $('#feature-template-labels').html(); }}
    {{ var subTemplate = _.template(featureTemplateHtml); }}

    {{ for(var i = 0; i < featureIterator.length; i++) { }}

    {{ var feature = featureIterator[i]; }}
    <%-- In health, we need to do this check, as we apply a property to the child object of the initial structure,
    when copying it to the 'your selected benefits'. Doing it in this manner prevents the need to store a copy of 100kb+ structure in memory --%>
    {{ if(feature.doNotRender === true) { continue; } }}


    {{ var dataSKey = typeof feature.shortlistKey != 'undefined' && feature.shortlistKey != '' ? 'data-skey="'+feature.shortlistKey + '"' : ''; }}
    {{ var dataSKeyParent = typeof feature.shortlistKeyParent != 'undefined' && feature.shortlistKeyParent != '' ? 'data-par-skey="'+feature.shortlistKeyParent + '"' : ''; }}
    <div class="cell {{= feature.classString }}" data-index="{{= i }}"  {{= dataSKey }} {{= dataSKeyParent }}>
        <div class="labelInColumn {{= feature.classStringForInlineLabel }}{{ if (feature.name == '') { }} noLabel{{ } }}">
            <div class="content" data-featureId="{{= feature.id }}">
                <div class="contentInner">
                    {{ if(feature.helpId != '' && feature.helpId != '0') { }}
                    <field_new:help_icon helpId="{{= feature.helpId }}" position="left"/>
                    {{ } }}
                    {{= feature.safeName }}
                    {{ if(typeof feature.children !== 'undefined') { }}
                    <span class="icon expander"></span>
                    {{ } }}
                </div>
            </div>
        </div>
        <div class="h content {{= feature.contentClassString }}" data-featureId="{{= feature.id }}">

            {{ if(feature.helpId != '' && feature.helpId != '0') { }}
                <field_new:help_icon helpId="{{= feature.helpId }}" position="left"/>
            {{ } }}
            {{= feature.safeName }}
            {{ if (typeof feature.extraText !== 'undefined' && feature.extraText != '') { }}
                <span class="extraText">{{= feature.extraText }}</span>
            {{ } }}
            {{ if (typeof feature.children !== 'undefined' && feature.children.length > 0) { }}
                <span class="icon expander"></span>
            {{ } }}
        </div>
        {{ var hasFeatureChildren = typeof feature.children != 'undefined' && feature.children.length; }}
        {{ var isSelectionHolder = feature.classString && feature.classString.indexOf('selectionHolder') != -1; }}
        {{ if(hasFeatureChildren || isSelectionHolder) { }}
        <div class="children" data-fid="{{= feature.id }}">
            {{ obj.childFeatureDetails = feature.children; }}
            {{= subTemplate(obj) }}
        </div>
        {{ } else { }}
        {{ delete obj.childFeatureDetails; }}
        {{ } }}
    </div>
    {{ } }}
</core:js_template>