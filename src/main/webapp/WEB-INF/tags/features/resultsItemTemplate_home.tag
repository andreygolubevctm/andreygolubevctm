<%@ tag language="java" pageEncoding="UTF-8" %>

{{ var parsedValue = '' }}

<%-- pathValue is defined in features/resultsItemTemplate.tag --%>

<%-- Regex to format money values; thousands separator --%>
{{ var r = /\B(?=(\d{3})+(?!\d))/g; }}

<%-- Home Cover --%>
{{ if (ft.resultPath == 'homeExcess.insuredValue') { }}
    {{ pathValue = true }}
    {{ if (!_.isEmpty(obj.homeExcess.insuredValue) || obj.homeExcess.insuredValue !== null) { }}
        {{ displayValue = '$'+obj.homeExcess.insuredValue.toString().replace(r, ","); }}
    {{ } }}
{{ } }}

<%-- Contents Cover --%>
{{ if (ft.resultPath == 'contentsExcess.insuredValue') { }}
    {{ pathValue = true }}
    {{ if (!_.isEmpty(obj.contentsExcess.insuredValue) || obj.contentsExcess.insuredValue !== null) { }}
        {{ displayValue = '$'+obj.contentsExcess.insuredValue.toString().replace(r, ","); }}
        {{ var contentsCost = parseInt($('#home_coverAmounts_replaceContentsCost').val()); }}

        {{ if (contentsCost !== parseInt(obj.contentsExcess.insuredValue)) { }}
            {{ displayValue += '<div class="insuredAmountMinimum">minimum insurable value for this provider</div>'; }}
        {{ } }}
    {{ } }}
{{ } }}

<%-- Additional Excess --%>
{{ if (ft.resultPath == 'additionalExcesses.value') { }}
    {{ pathValue = true }}
    {{ if (_.isEmpty(obj.additionalExcesses) || obj.additionalExcesses.value == 'N') { }}
        {{ displayValue = 'Refer to the PDS'; }}
    {{ } else { }}
        {{ displayValue = obj.additionalExcesses.value; }}
    {{ } }}
{{ } }}

<%-- PDS buttons --%>
{{ if (ft.resultPath == 'action.pds') { }}
    {{ pathValue = true }}

    {{ var pdsA = '' }}
    {{ var pdsB = '' }}
    {{ var pdsC = '' }}
    {{ var width = '25' }}

    {{ if(obj.productDisclosures != null) { }}
        {{ if(typeof obj.productDisclosures.pdsc != 'undefined') { }}
            {{ if(obj.productDisclosures.pdsc.url != '') { }}
                {{ pdsC = '<a href="'+obj.productDisclosures.pdsc.url+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part C</a>' }}
             {{ } else { }}
                {{ width = '45' }}
            {{ } }}
        {{ } else { }}
            {{ width = '45' }}
        {{ } }}

        {{ if(typeof obj.productDisclosures.pdsb != 'undefined') { }}
            {{ pdsB = '<a href="'+obj.productDisclosures.pdsb.url+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part B</a>' }}
        {{ } else { }}
            {{ width = '70' }}
        {{ } }}

        {{ pdsA = '<a href="'+obj.productDisclosures.pdsa.url+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part A</a>' }}
    {{ } }}

    {{ displayValue = '<div class="btnContainer">'+pdsA+pdsB+pdsC+'</div>' }}
{{ } }}