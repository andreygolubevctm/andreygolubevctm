<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details form detail"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<field_new:creditcard_assurance_message showCreditCards="false" />

<%-- HTML --%>
<c:set var="fieldXpath" value="${xpath}/name" />
<form_new:row fieldXpath="${fieldXpath}" label="Bank Name">
	<field_new:input xpath="${fieldXpath}" title="bank's name" required="true" className="health-bank_details-bank_name" />
</form_new:row>

<c:set var="fieldXpath" value="${xpath}/account" />
<form_new:row fieldXpath="${fieldXpath}" label="Account Name">
	<field_new:input xpath="${fieldXpath}" title="account name" required="true" className="health-bank_details-account_name" maxlength="50" />
</form_new:row>

<c:set var="fieldXpath" value="${xpath}/bsb" />
<form_new:row fieldXpath="${fieldXpath}input" label="BSB">
	<field_new:bsb_number xpath="${fieldXpath}" title="bsb number" required="true" className="health-bank_details-bsb"/>
</form_new:row>

<c:set var="fieldXpath" value="${xpath}/number" />
<form_new:row fieldXpath="${fieldXpath}" label="Account Number">
	<field_new:account_number xpath="${fieldXpath}" title="account number" minLength="5" maxLength="9" required="true" className="health-bank_details-account_number"/>
</form_new:row>


<%-- VALIDATION --%>
<go:validate selector="${go:nameFromXpath(xpath)}_name" rule="regex" parm="'[a-zA-Z ]{1,30}'" message="For bank name, please use only alphabetic characters (A-Z) and space, up to 30 characters in length." />
<go:validate selector="${go:nameFromXpath(xpath)}_account" rule="regex" parm="'[a-zA-Z ]{1,30}'" message="For account name, please use only alphabetic characters (A-Z) and space, up to 30 characters in length." />
