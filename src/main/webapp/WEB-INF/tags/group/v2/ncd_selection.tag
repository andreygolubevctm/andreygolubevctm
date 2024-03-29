<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for NCD and NCD Protection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="className" value="${go:nameFromXpath(xpath)}" />
<c:set var="analAttribute"><field_v1:analytics_attr analVal="NCD" quoteChar="\"" /></c:set>
<c:set var="ncdXpath" value="${xpath}/ncd" />
<c:set var="ncdName" value="${go:nameFromXpath(ncdXpath)}" />

<%-- HTML --%>
<form_v2:row label="Current No Claims Discount (NCD) or Rating Discount?" helpId="10" id="${name}Row">
	<field_v2:import_select xpath="${ncdXpath}"
					url="/WEB-INF/option_data/ncd.html"
					title="the regular driver's NCD or Rating Discount"
					className="ncd"
					required="true" additionalAttributes=" data-rule-ncdValid='true' data-rule-youngestDriverMinAge='true' ${analAttribute}" />
</form_v2:row>