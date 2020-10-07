<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="Class Name for Fieldset" %>
<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection">
	<c:set var="fieldXpath" value="${xpath}/rebateForm" />
	<form_v3:row fieldXpath="${fieldXpath}" label="Australian Government Rebate Form" className="ausgovtrebateform" hideHelpIconCol="true">
		<field_v2:checkbox xpath="${fieldXpath}"
						   value="Y" title="Do you authorise <em class='AHM'>ahm Health Insurance</em> to lodge the rebate form on your behalf?" required="false" label="true"/>
	</form_v3:row>

    <c:set var="fieldXpath" value="${xpath}" />
	<simples:dialogue id="223" vertical="health" mandatory="true" checkboxXPath="${fieldXpath}" className="declaration" />
</div>