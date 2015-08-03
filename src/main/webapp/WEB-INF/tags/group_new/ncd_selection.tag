<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for NCD and NCD Protection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="className" value="${go:nameFromXpath(xpath)}" />

<c:set var="ncdXpath" value="${xpath}/ncd" />
<c:set var="ncdName" value="${go:nameFromXpath(ncdXpath)}" />

<%-- HTML --%>
<form_new:row label="Current No Claims Discount (NCD) or Rating Discount?" helpId="10" id="${name}Row">
	<field_new:import_select xpath="${ncdXpath}"
					url="/WEB-INF/option_data/ncd.html"
					title="the regular driver's NCD or Rating Discount"
					className="ncd"
					required="true" />
</form_new:row>

<%-- VALIDATION --%>
<go:validate selector="quote_drivers_regular_ncd" rule="ncdValid" parm="true" message="Invalid NCD Rating based on number of years driving."/>
<go:validate selector="quote_drivers_regular_ncd" rule="youngestDriverMinAge" parm="true" message="Driver age restriction invalid due to youngest driver's age."/>