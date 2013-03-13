<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Bank account details form detail"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<%-- HTML --%>
<form:row label="Bank Name">
	<field:input xpath="${xpath}/name" title="bank's name" required="true" className="health-bank_details-bank_name" />
</form:row>

<form:row label="Account Name">
	<field:input xpath="${xpath}/account" title="account name" required="true" className="health-bank_details-account_name" maxlength="50" />
</form:row>

<form:row label="BSB">
	<field:bsb_number xpath="${xpath}/bsb" title="bsb number" required="true" className="health-bank_details-bsb"/>
</form:row>

<form:row label="Account Number">
	<field:account_number xpath="${xpath}/number" title="account number" minLength="5" maxLength="9" required="true" className="health-bank_details-account_number"/>
</form:row>
<%-- VALIDATION --%>
<go:validate selector="${go:nameFromXpath(xpath)}_name" rule="regex" parm="'[a-zA-Z]+'" message="Please only use alphabetic characters for bank name." />
<%-- JAVASCRIPT --%>
<go:script marker="js-head">
$.validator.addMethod('regex', function(value, element, param) {
	return value.match(new RegExp('^' + param + '$'));
});
</go:script>