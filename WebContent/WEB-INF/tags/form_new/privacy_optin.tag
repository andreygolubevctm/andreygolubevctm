<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="true"	 rtexprvalue="true"	 description="the root xpath for the vertical" %>

<%-- VARIABLES --%>
<c:set var="suffix"  value="privacyoptin" />
<c:set var="xpath_name"  value="${vertical}_${suffix}" />
<c:set var="xpath"  value="${vertical}/${suffix}" />
<c:set var="label_text" value='I have read the <a data-toggle="dialog" data-content="legal/privacy_statement.jsp" data-cache="true" data-dialog-hash-id="privacystatement" href="legal/privacy_statement.jsp" target="_blank">privacy statement</a>' />
<c:set var="error_text" value="Please confirm you have read the privacy statement" />

<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
<form_new:row className="${vertical}-contact-details-optin-group" hideHelpIconCol="true">
	<field_new:checkbox
		xpath="${xpath}"
		value="Y"
		className="validate"
		required="true"
		label="${true}"
		title="${label_text}"
		errorMsg="${error_text}" />
</form_new:row>

<%-- VALIDATION --%>
<go:validate selector="${xpath_name}" rule="required" parm="true" message="${error_text}" />