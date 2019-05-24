<%@ tag description="Template Container/Renderer" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Include the Vertical Specific Templates --%>
<retrievequotes_template:car/>
<retrievequotes_template:life/>
<retrievequotes_template:ip/>
<retrievequotes_template:health/>
<retrievequotes_template:home/>
<retrievequotes_template:utilities/>

<core_v1:js_template id="retrieve-quotes-container-template">
    {{ if(typeof obj.previousQuotes !== "undefined") { }}
        {{ var actionButtonTemplate = $("#action-button-template").html(); }}
        {{ obj.actionButtonTmpl = _.template(actionButtonTemplate); }}

        {{ var quotesList = obj.previousQuotes.result; }}

        {{ if(!$.isArray(quotesList)) quotesList = [quotesList]; }}

        <%-- For each saved quote, render the template --%>
        {{ for(var i = 0; i < quotesList.length; i++) { }}
            {{ var vertical = meerkat.modules.retrievequotesListQuotes.getVerticalFromObject(quotesList[i]); }}

            {{ quotesList[i].verticalCode = vertical; }}
            {{ quotesList[i].transactionId = quotesList[i].id; }}

            {{ var quoteHTML = meerkat.modules.retrievequotesListQuotes.renderTemplate(quotesList[i].verticalCode, quotesList[i][vertical]); }}

            {{ if(quotesList[i].verticalCode && quoteHTML !== "") { }}
                {{ var current = quotesList[i]; }}
                <div class="clearfix quote-row">
                    <div class="col-xs-4 col-md-2">
                        <p class="text-center">
                            <span class="icon icon-{{= current.verticalCode }}"></span>
                        </p>

                        {{ var verticalInfo = current[current.verticalCode] }}
                        <p class="time-ago">
                            <strong>{{= meerkat.modules.utils.getTimeAgo(meerkat.modules.utils.formatUKToUSDate(verticalInfo.quoteDate) + " " + verticalInfo.quoteTime) }} ago</strong>
                            <br>{{= verticalInfo.quoteDate }}
                        </p>
                    </div>
                    <div class="col-xs-8 col-md-7">
                        {{= quoteHTML }}
                        <br>
                    </div>
                    <div class="col-xs-12 col-md-3">
                        {{= obj.actionButtonTmpl(current) }}
                    </div>
                </div>
            {{ } }}
        {{ } }}
    {{ } }}
</core_v1:js_template>

<core_v1:js_template id="action-button-template">
    {{ var verticalData = obj[obj.verticalCode]; }}
    {{ if(verticalData.pendingID && verticalData.pendingID.length) { }}
        <a href="javascript:;" data-vertical="{{= obj.verticalCode }}" data-transactionId="{{= obj.transactionId }}" data-pendingid="{{= verticalData.pendingID }}" class="btn btn-block btn-tertiary btn-pending"><span>In Processing</span></a>
    {{ } else { }}
        {{ if(obj.verticalCode !== "utilities") { }}
            {{ if(verticalData.inPast && obj.verticalCode !== "health") { }}
                <a href="javascript:;" data-vertical="{{= obj.verticalCode }}" data-transactionId="{{= obj.transactionId }}" data-inpast="{{= verticalData.inPast }}" class="btn btn-block btn-secondary btn-latest"><span>Get Latest Results</span></a>
            {{ } else if(_.isEmpty(verticalData.inPast) && obj.verticalCode === "health") { }}
                <a href="javascript:;" data-vertical="{{= obj.verticalCode }}" data-transactionId="{{= obj.transactionId }}" class="btn btn-block btn-secondary btn-latest"><span>Get Latest Results</span></a>
            {{ } }}
            {{ if(obj.verticalCode === 'home') { }}
                <a href="javascript:;" data-islandlord="{{= obj.home.isLandlord}}" data-vertical="{{= obj.verticalCode }}" data-transactionId="{{= obj.transactionId }}" class="btn btn-block btn-tertiary btn-amend"><span>Amend Quote</span></a>
            {{ } else if(obj.verticalCode !== "health") { }}
                <a href="javascript:;" data-vertical="{{= obj.verticalCode }}" data-transactionId="{{= obj.transactionId }}" class="btn btn-block btn-tertiary btn-amend"><span>Amend Quote</span></a>
            {{ } }}
        {{ } }}

        <%-- NOTE: IF UTILITIES EVER ADDS RETRIEVE QUOTES AGAIN, WE NEED TO UPDATE THIS TO USE THE PROPER BUTTONS --%>
        {{ if(obj.verticalCode === "utilities") { }}
            <a href="javascript:;" data-vertical="{{= obj.verticalCode }}" data-transactionId="{{= obj.transactionId }}" class="btn btn-block btn-tertiary btn-start-again-fresh"><span>Start Again</span></a>
        {{ } }}
    {{ } }}
</core_v1:js_template>

<core_v1:js_template id="new-commencement-date-template">
    <p>The quote you selected has a commencement date in the past.</p>
    <p>Please enter a new commencement date and click the button below to view the latest prices for this quote.</p>
    <form_v2:row label="Commencement Date" className="form-horizontal">
        <field_v2:commencement_date xpath="newCommencementDate" mode="component" includeMobile="false" />
    </form_v2:row>
</core_v1:js_template>

<div id="quote-result-list"></div>
