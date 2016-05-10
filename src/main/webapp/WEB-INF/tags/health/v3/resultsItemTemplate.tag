<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />

<core_v1:js_template id="feature-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(obj.featuresStructureIndexToUse); }}
    {{ for(var i = 0; i < featureIterator.length; i++) { }}
    {{ var ft = featureIterator[i]; }}
    <%-- In health, we need to do this check, as we apply a property to the child object of the initial structure,
    when copying it to the 'your selected benefits'. --%>
    {{ if(ft.doNotRender === true) { continue; } }}

    {{ var hasResult = ft.resultPath != null && ft.resultPath != ''; }}
    {{ var pathValue = hasResult ? Object.byString( obj, ft.resultPath ) : false; }}
    <div class="cell {{= ft.classString }}">
        {{ if(ft.type != 'section') { }}<%-- section headers are not rendered anymore --%>
            <div class="labelInColumn {{= ft.classStringForInlineLabel }}{{ if (ft.name == '') { }} noLabel{{ } }}"{{ if(pathValue == "N") { }} title='Not covered' {{ } }}>
                <div class="content{{ if(pathValue == 'N') { }} noCover{{ } }}" data-featureId="{{= ft.id }}">
                    <div class="contentInner">
                        {{ var iconClassSet = ft.classString.match(/(HLTicon-[^\s]+)/); }}
                        {{ var iconClass = iconClassSet && iconClassSet.length && iconClassSet[0].indexOf('HLTicon') != -1 ? iconClassSet[0] : "" }}
                        <span class="health-icon {{= iconClass }}"></span> {{= ft.safeName }} {{ if(pathValue == "R") { }}<sup title="Restricted">#</sup>{{ } }}
                        {{ if(typeof ft.children !== 'undefined' && ft.children.length) { }}
                        <span class="icon expander"></span>
                        {{ } }}
                    </div>
                </div>
            </div>
            {{ if(ft.type != 'category') { }}<%--  category no longer has content like a tick/cross. --%>
            <div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
                {{ if(hasResult) { }}
                {{ var displayValue = Features.parseFeatureValue( pathValue, true ); }}<%-- Below compressed to reduce number of whitespace nodes in DOM --%>
                {{ if( pathValue ) { }}<div><strong>{{= displayValue }}</strong> {{= ft.safeName.toLowerCase() }}</div>{{ } else { }}{{= "-" }}{{ } }}{{ } else { }}{{= "-" }}
                {{ } }}
            </div>
            {{ } }}
        {{ } }}
        {{ var hasFeatureChildren = typeof ft.children != 'undefined' && ft.children.length; }}
        {{ var isSelectionHolder = ft.classString && ft.classString.indexOf('selectionHolder') != -1; }}
        {{ if(hasFeatureChildren || isSelectionHolder) { }}
        <div class="children" data-fid="{{= ft.id }}">
            {{ for(var m =0; m < ft.children.length; m++) { }}
            {{ ft.children[m].shortlistKeyParent = ft.shortlistKey; }}
            {{ } }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{= Features.cachedProcessedTemplates[obj.featuresTemplate](obj) }}
        </div>
        {{ } else { }}
        {{ delete obj.childFeatureDetails; }}
        {{ } }}
    </div>
    {{ } }}
</core_v1:js_template>
