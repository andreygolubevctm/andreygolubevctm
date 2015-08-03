<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="true"	 rtexprvalue="true"	 description="the root xpath for the vertical" %>
<%@ attribute name="labelText" 	required="false"	 rtexprvalue="true"	 description="the root xpath for the vertical" %>

<%-- VARIABLES --%>
<c:set var="suffix"  	value="privacyoptin" />
<c:set var="xpath_name" value="${vertical}_${suffix}" />
<c:set var="xpath"  	value="${vertical}/${suffix}" />
<c:set var="privacyStatementLink"><form:link_privacy_statement /></c:set>
<c:set var="error_text" value="Please confirm you have read the privacy statement" />
<c:if test="${empty labelText}">
	<c:set var="labelText">I have read the ${privacyStatementLink}</c:set>
</c:if>
<c:set var="label_text" value='${labelText}' />

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