<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="navBtnAnalAttribute"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>

{{ var parsedValue = '' }}

<%-- pathValue is defined in features/resultsItemTemplate.tag --%>

<%-- Special Conditions --%>
{{ if (ft.resultPath == 'specialConditions.description') { }}
{{ pathValue = true }}
{{ if (_.isEmpty(obj.specialConditions) || obj.specialConditions == null) { }}
{{ displayValue = 'Refer to the PDS'; }}
{{ } else { }}
{{ displayValue = obj.specialConditions.description; }}
{{ } }}
{{ } }}

<%-- Call insurer direct button --%>
{{ if (ft.resultPath == 'action.callInsurer') { }}
<%-- Default pathValue to N so we get the crosses as default. --%>
{{ pathValue = 'N' }}
{{ parsedValue = Features.parseFeatureValue( pathValue ) }}
{{ displayValue = '<div class="btnContainerNoBtn">'+parsedValue+'</div>' }}

{{ if(obj.contact.allowCallDirect === true) { }}
{{ displayValue = '<div class="btnContainer"><a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="'+obj.productId+'" ${navBtnAnalAttribute}>Call Insurer Direct</a></div>' }}
{{ } }}
{{ } }}

<%-- Get a call back button --%>
{{ if (ft.resultPath == 'action.callBack') { }}
<%-- Default pathValue to N so we get the crosses as default. --%>
{{ pathValue = 'N' }}
{{ parsedValue = Features.parseFeatureValue( pathValue ) }}
{{ displayValue = '<div class="btnContainerNoBtn">'+parsedValue+'</div>' }}

{{ if(obj.contact.allowCallMeBack === true) { }}
{{ displayValue = '<div class="btnContainer"><a class="btn btn-back btn-block btn-call-actions btn-callback" data-callback-toggle="callback" href="javascript:;" data-productId="'+obj.productId+'" ${navBtnAnalAttribute}>Get a Call Back</a></div>' }}
{{ } }}
{{ } }}

<%-- PDS buttons --%>
{{ if (ft.resultPath == 'action.pds') { }}
{{ pathValue = true }}

{{ var pdsA = '' }}
{{ var pdsB = '' }}
{{ var ped = '' }}
{{ var width = '25' }}

{{ if(obj.productDisclosures != null) { }}
{{ if(typeof obj.productDisclosures.ped != 'undefined') { }}
{{ if(obj.productDisclosures.ped.url != '') { }}
{{ ped = '<a href="'+obj.productDisclosures.ped.url+'" target="_blank" class="showDoc btn btn-sm btn-download" ${navBtnAnalAttribute} style="width: '+width+'%">PED</a>' }}
{{ } else { }}
{{ width = '45' }}
{{ } }}
{{ } else { }}
{{ width = '45' }}
{{ } }}


{{ if(typeof obj.productDisclosures.pdsb != 'undefined') { }}
{{ pdsB = '<a href="'+obj.productDisclosures.pdsb.url+'" target="_blank" class="showDoc btn btn-sm btn-download" ${navBtnAnalAttribute} style="width: '+width+'%">Part B</a>' }}
{{ } else { }}
{{ width = '70' }}
{{ } }}


{{ pdsA = '<a href="'+obj.productDisclosures.pdsa.url+'" target="_blank" class="showDoc btn btn-sm btn-download" ${navBtnAnalAttribute} style="width: '+width+'%">Part A</a>' }}
{{ } }}

{{ displayValue = '<div class="btnContainer">'+pdsA+pdsB+ped+'</div>' }}
{{ } }}

<%-- View more info --%>
{{ if (ft.resultPath == 'action.moreInfo') { }}
{{ pathValue = true }}
{{  displayValue = '<div class="btnContainer"><a class="btn-more-info" href="javascript:;" data-productId="'+obj.productId+'" ${navBtnAnalAttribute}>view more info</a></div>' }}
{{ } }}
