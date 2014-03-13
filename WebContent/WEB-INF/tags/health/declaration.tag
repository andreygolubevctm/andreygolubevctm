<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health_declaration">

	<form_new:fieldset legend="Declaration">

		<c:set var="fieldXpath" value="${xpath}/rebateForm" />
		<form_new:row fieldXpath="${fieldXpath}" label="Australian Government Rebate Form" className="ausgovtrebateform" hideHelpIconCol="true">
			<field_new:checkbox xpath="${fieldXpath}" value="Y" title="Do you authorise <em class='AHM'>ahm Health Insurance</em> to lodge the rebate form on your behalf?" required="false" label="true"/>
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}" />
		<form_new:row fieldXpath="${fieldXpath}" label='Join <a id="jointDeclarationDialog_link" title="Join Declaration" href="javascript:;">declaration</a> for <span>Provider</span>' hideHelpIconCol="true">
			<field_new:checkbox xpath="${fieldXpath}" value="Y" title="I confirm that I have read and understood the attached declaration and the information relating to my product choice. I declare that the information I have provided is true and correct." required="true" errorMsg="Please read the declaration in order to proceed" label="true" />
		</form_new:row>
	</form_new:fieldset>

</div>