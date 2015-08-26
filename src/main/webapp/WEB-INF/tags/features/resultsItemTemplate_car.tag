<%@ tag language="java" pageEncoding="UTF-8" %>

{{ var parsedValue = '' }}

<%-- Replace or overwrite certain values, i.e value comes from the soap response instead of the database. --%>
<%-- Get the annual kilometers for Pay as you drive products --%>
{{ if (obj.productId == "WOOL-01-01" || obj.productId == "REIN-01-01") { }}
    {{ if (feature.resultPath == 'features.annKilo.extra') { }}
        {{ displayValue = obj.feature }}
    {{ } }}
{{ } }}

<%-- Additional excess rendering --%>
{{ if (feature.resultPath == 'excess.excess.value') { }}
    <%-- Default pathValue to N so we get the crosses as default. --%>
    {{ pathValue = 'N' }}
    {{ displayValue = Features.parseFeatureValue( pathValue ) }}
    {{ if(typeof excess.excess != 'undefined') { }}
        {{ displayValue = 'Additional Excess Applies' }}
    {{ } }}
{{ } }}

{{ if (feature.resultPath == 'excess.excess.extra') { }}
    {{ pathValue = true }}
    {{ displayValue += '<ul>' }}
    <%-- Loop through the excess, put them in an li and put that in the displayValue --%>
    {{ if(excess.excess.hasOwnProperty("description")) { }}
        {{ displayValue += '<li>'+ excess.excess.description + (excess.excess.hasOwnProperty('amount') ? ' ' + excess.excess.amount : '') + '</li>' }}
    {{ } else { }}
        {{for(var index in excess.excess) { }}
            {{ displayValue += '<li>'+ excess.excess[index].description + ' ' + excess.excess[index].amount + '</li>' }}
        {{ } }}
    {{ } }}
    {{ displayValue += '</ul>' }}
{{ } }}

<%-- Call insurer direct button --%>
{{ if (feature.resultPath == 'action.callInsurer') { }}
    <%-- Default pathValue to N so we get the crosses as default. --%>
    {{ pathValue = 'N' }}
    {{ parsedValue = Features.parseFeatureValue( pathValue ) }}
    {{ displayValue = '<div class="btnContainerNoBtn">'+parsedValue+'</div>' }}

    {{ obj.isOfflineAvailable = obj.offlineAvailable == "Y" }}
    {{ if(obj.isOfflineAvailable === true) { }}
        {{ displayValue = '<div class="btnContainer"><a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="'+obj.productId+'">Call Insurer Direct</a></div>' }}
    {{ } }}
{{ } }}

<%-- Get a call back button --%>
{{ if (feature.resultPath == 'action.callBack') { }}
    <%-- Default pathValue to N so we get the crosses as default. --%>
    {{ pathValue = 'N' }}
    {{ parsedValue = Features.parseFeatureValue( pathValue ) }}
    {{ displayValue = '<div class="btnContainerNoBtn">'+parsedValue+'</div>' }}

    {{ obj.isOfflineAvailable = obj.offlineAvailable == "Y" }}
    {{ if(obj.isOfflineAvailable === true) { }}
        {{ obj.isCallbackAvailable = obj.callbackAvailable == "Y" }}
    {{ if(obj.isCallbackAvailable === true) { }}
        {{ displayValue = '<div class="btnContainer"><a class="btn btn-back btn-block btn-call-actions btn-callback" data-callback-toggle="callback" href="javascript:;" data-productId="'+obj.productId+'">Get a Call Back</a></div>' }}
    {{ } }}
{{ } }}

{{ } }}

<%-- PDS buttons --%>
{{ if (feature.resultPath == 'action.pds') { }}
{{ pathValue = true }}

{{ var pdsA = '' }}
{{ var pdsB = '' }}
{{ var pdsC = '' }}
{{ var width = '25' }}

{{ if(typeof obj.pdscUrl != 'undefined') { }}
{{ if(obj.pdscUrl != '') { }}
{{ pdsC = '<a href="'+obj.pdscUrl+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part C</a>' }}
{{ } else { }}
{{ width = '45' }}
{{ } }}
{{ } else { }}
{{ width = '45' }}
{{ } }}

{{ if(obj.pdsbUrl != '') { }}
{{ pdsB = '<a href="'+obj.pdsbUrl+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part B</a>' }}
{{ } else { }}
{{ width = '70' }}
{{ } }}

{{ pdsA = '<a href="'+obj.pdsaUrl+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part A</a>' }}

{{ displayValue = '<div class="btnContainer">'+pdsA+pdsB+pdsC+'</div>' }}
{{ } }}

<%-- View more info --%>
{{ if (feature.resultPath == 'action.moreInfo') { }}
{{ pathValue = true }}
{{ displayValue = '<div class="btnContainer"><a class="btn-more-info" href="javascript:;" data-productId="'+obj.productId+'">view more info</a></div>' }}
{{ } }}