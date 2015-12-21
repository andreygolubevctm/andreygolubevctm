<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details form detail"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<field_new:creditcard_assurance_message showCreditCards="false" />

<%-- HTML --%>
<c:set var="fieldXpath" value="${xpath}/name" />
<form_v2:row fieldXpath="${fieldXpath}" label="Bank Name">
	<field_new:input xpath="${fieldXpath}" title="bank's name" required="true" className="health-bank_details-bank_name sessioncamexclude" additionalAttributes=" data-rule-regex='[a-zA-Z ]{1,30}' data-msg-regex='For bank name, please use only alphabetic characters (A-Z) and space, up to 30 characters in length.' "/>
</form_v2:row>

<c:set var="fieldXpath" value="${xpath}/account" />
<form_v2:row fieldXpath="${fieldXpath}" label="Account Name">
	<field_new:input xpath="${fieldXpath}" title="account name" required="true" className="health-bank_details-account_name sessioncamexclude" maxlength="50" additionalAttributes=" data-rule-regex='[a-zA-Z ]{1,30}' data-msg-regex='For account name, please use only alphabetic characters (A-Z) and space, up to 30 characters in length.' "/>
</form_v2:row>

<c:set var="fieldXpath" value="${xpath}/bsb" />
<form_v2:row fieldXpath="${fieldXpath}input" label="BSB">
	<field_new:bsb_number xpath="${fieldXpath}" title="bsb number" required="true" className="health-bank_details-bsb sessioncamexclude" />
</form_v2:row>

<c:set var="fieldXpath" value="${xpath}/number" />
<form_v2:row fieldXpath="${fieldXpath}" label="Account Number">
	<field_new:account_number xpath="${fieldXpath}" title="account number" minLength="5" maxLength="9" required="true" className="health-bank_details-account_number sessioncamexclude" />
</form_v2:row>
