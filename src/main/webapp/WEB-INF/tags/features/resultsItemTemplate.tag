<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<core:js_template id="feature-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(); }}

    {{ for(var i = 0; i < featureIterator.length; i++) { }}

    {{ var feature = featureIterator[i]; }}
    <%-- In health, we need to do this check, as we apply a property to the child object of the initial structure,
    when copying it to the 'your selected benefits'. --%>
    {{ if(feature.doNotRender === true) { continue; } }}


    {{ var dataSKey = typeof feature.shortlistKey != 'undefined' && feature.shortlistKey != '' ? 'data-skey="'+feature.shortlistKey + '"' : ''; }}
    {{ var dataSKeyParent = typeof feature.shortlistKeyParent != 'undefined' && feature.shortlistKeyParent != '' ? 'data-par-skey="'+feature.shortlistKeyParent + '"' : ''; }}
    <div class="cell {{= feature.classString }}" data-index="{{= i }}" {{= dataSKey }} {{= dataSKeyParent }}>
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

        <div class="c content {{= feature.contentClassString }}" data-featureId="{{= feature.id }}">
            {{ if(feature.resultPath != null && feature.resultPath != '') { }}
                {{ var pathValue = Object.byString( obj, feature.resultPath ); }}
                {{ var displayValue = Features.parseFeatureValue( pathValue, true ); }}
                <c:if test="${vertical eq 'car'}">
                    <jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
                    <c:set var="newWebServiceSplitTest" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 40)}" />
                    <c:set var="defaultToCarQuote"><content:get key="makeCarQuoteMainJourney" /></c:set>
                    <c:choose>
                        <c:when test="${newWebServiceSplitTest || defaultToCarQuote eq 'true'}">
                            <features:resultsItemTemplate_car_ws />
                        </c:when>
                        <c:otherwise>
                            <features:resultsItemTemplate_car />
                        </c:otherwise>
                    </c:choose>
                </c:if> <%-- Below compressed to reduce number of whitespace nodes in DOM --%>
                {{ if( pathValue ) { }}<div>{{= displayValue }}</div>{{ } else { }}{{= "&nbsp;" }}{{ } }}{{ } else { }}{{= "&nbsp;" }}
            {{ } }}
        </div>

        {{ var hasFeatureChildren = typeof feature.children != 'undefined' && feature.children.length; }}
        {{ var isSelectionHolder = feature.classString && feature.classString.indexOf('selectionHolder') != -1; }}
        {{ if(hasFeatureChildren || isSelectionHolder) { }}
        <div class="children" data-fid="{{= feature.id }}">
            {{ for(var m =0; m < feature.children.length; m++) { }}
                {{ feature.children[m].shortlistKeyParent = feature.shortlistKey; }}
            {{ } }}
            {{ obj.childFeatureDetails = feature.children; }}
            {{= Features.cachedProcessedTemplate(obj) }}
        </div>
        {{ } else { }}
            {{ delete obj.childFeatureDetails; }}
        {{ } }}

    </div>
    {{ } }}

</core:js_template>
