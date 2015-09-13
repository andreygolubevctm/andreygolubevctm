<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<core:js_template id="feature-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(); }}

    {{ for(var i = 0; i < featureIterator.length; i++) { }}

    {{ var ft = featureIterator[i]; }}
    <%-- In health, we need to do this check, as we apply a property to the child object of the initial structure,
    when copying it to the 'your selected benefits'. --%>
    {{ if(ft.doNotRender === true) { continue; } }}


    {{ var dataSKey = typeof ft.shortlistKey != 'undefined' && ft.shortlistKey != '' ? 'data-skey="'+ft.shortlistKey + '"' : ''; }}
    {{ var dataSKeyParent = typeof ft.shortlistKeyParent != 'undefined' && ft.shortlistKeyParent != '' ? 'data-par-skey="'+ft.shortlistKeyParent + '"' : ''; }}
    <div class="cell {{= ft.classString }}" data-index="{{= i }}" {{= dataSKey }} {{= dataSKeyParent }}>
        <div class="labelInColumn {{= ft.classStringForInlineLabel }}{{ if (ft.name == '') { }} noLabel{{ } }}">
            <div class="content" data-featureId="{{= ft.id }}">
                <div class="contentInner">
                    {{ if(ft.helpId != '' && ft.helpId != '0') { }}
                        <field_new:help_icon helpId="{{= ft.helpId }}" position="left"/>
                    {{ } }}
                    {{= ft.safeName }}
                    {{ if(typeof ft.children !== 'undefined') { }}
                    <span class="icon expander"></span>
                    {{ } }}
                </div>
            </div>
        </div>

        <div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">
            {{ if(ft.resultPath != null && ft.resultPath != '') { }}
                {{ var pathValue = Object.byString( obj, ft.resultPath ); }}
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

        {{ var hasFeatureChildren = typeof ft.children != 'undefined' && ft.children.length; }}
        {{ var isSelectionHolder = ft.classString && ft.classString.indexOf('selectionHolder') != -1; }}
        {{ if(hasFeatureChildren || isSelectionHolder) { }}
        <div class="children" data-fid="{{= ft.id }}">
            {{ for(var m =0; m < ft.children.length; m++) { }}
                {{ ft.children[m].shortlistKeyParent = ft.shortlistKey; }}
            {{ } }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{= Features.cachedProcessedTemplate(obj) }}
        </div>
        {{ } else { }}
            {{ delete obj.childFeatureDetails; }}
        {{ } }}

    </div>
    {{ } }}

</core:js_template>
