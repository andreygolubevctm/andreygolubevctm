<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A pair of date selectors representing a date range."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="inputClassName"		required="false" rtexprvalue="true"	 description="additional css class attribute for the input field" %>

<%-- From fields --%>
<%@ attribute name="labelFrom" 			required="true"	 rtexprvalue="true"	 description="The label of the fromDate field (e.g. 'Departure Date')"%>
<%@ attribute name="titleFrom" 			required="true"	 rtexprvalue="true"	 description="The name/function of the fromDate field (e.g. 'departure')"%>
<%@ attribute name="minDateFrom" 		required="false" rtexprvalue="true"	 description="Minimum Inclusive Date Value (rfc3339 yyyy-MM-dd)"%>
<%@ attribute name="maxDateFrom" 		required="false" rtexprvalue="true"	 description="Maximum Inclusive Date Value (rfc3339 yyyy-MM-dd)"%>
<%@ attribute name="startViewFrom" 		required="false" rtexprvalue="true"	 description="The view either 0:Month|1:Year|2:Decade|"%>
<%@ attribute name="helpIdFrom" 		required="false" rtexprvalue="true"	 description="ID for help icon from date"%>

<%@ attribute name="labelTo" 			required="true"	 rtexprvalue="true"	 description="The label of the toDate field (e.g. 'Return Date')"%>
<%@ attribute name="titleTo" 			required="true"	 rtexprvalue="true"	 description="The name/function of the toDate field (e.g. 'return')"%>
<%@ attribute name="minDateTo" 			required="false" rtexprvalue="true"	 description="Minimum Inclusive Date Value (rfc3339 yyyy-MM-dd)"%>
<%@ attribute name="maxDateTo" 			required="false" rtexprvalue="true"	 description="Maximum Inclusive Date Value (rfc3339 yyyy-MM-dd)"%>
<%@ attribute name="offsetText" 		required="false" rtexprvalue="true"	 description="Error validation text to specify if there's an upper limit already imposed. eg. 'up to 1 year'"%>
<%@ attribute name="startViewTo" 		required="false" rtexprvalue="true"	 description="The view either 0:Month|1:Year|2:Decade|"%>
<%@ attribute name="helpIdTo" 			required="false" rtexprvalue="true"	 description="ID for help icon to date"%>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="fromDateXpath" value="${xpath}/fromDate" />
<c:set var="toDateXpath" value="${xpath}/toDate" />
<c:set var="fromDate" value="${go:nameFromXpath(fromDateXpath)}" />
<c:set var="toDate" value="${go:nameFromXpath(toDateXpath)}" />

<c:set var="fromDateRule">data-rule-fromToDate='{"fromDate": "${fromDate}", "toDate":"${toDate}"}' data-msg-fromToDate='The ${titleFrom} date should be equal to, or before the ${titleTo} date.'</c:set>
<c:set var="toDateRule">data-rule-fromToDate='{"fromDate": "${fromDate}", "toDate":"${toDate}"}' data-msg-fromToDate='The ${titleTo} date should be equal to or, ${offsetText} after the ${titleFrom} date.'</c:set>
<%-- HTML --%>
<form_new:row label="${labelFrom}" helpId="${helpIdFrom}" id="${fromDate}_row">
	<field_new:calendar mode="separated" validateMinMax="true" xpath="${fromDateXpath}" required="${required}" title="${titleFrom}" minDate="${minDateFrom}" maxDate="${maxDateFrom}" startView="${startViewFrom}" calAdditionalAttributes="${fromDateRule}" />
</form_new:row>
<form_new:row label="${labelTo}" helpId="${helpIdTo}" id="${toDate}_row">
	<field_new:calendar mode="separated" validateMinMax="true" xpath="${toDateXpath}" required="${required}" title="${titleTo}" minDate="${minDateTo}" maxDate="${maxDateTo}" startView="${startViewTo}"  calAdditionalAttributes="${toDateRule}"/>
</form_new:row>