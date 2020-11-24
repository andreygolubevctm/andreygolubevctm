<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details form detail"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="isClaimAccount" value="${fn:contains(xpath,'claim')}" />
<c:set var="rowClass">
	<c:choose>
		<c:when test="${isClaimAccount}"></c:when>
		<c:otherwise>bank-row</c:otherwise>
	</c:choose>
</c:set>


<%-- HTML --%>
<field_v3:creditcard_assurance_message showCreditCards="false" />
<div id="bank-account-fields-group">
	<c:if test="${not empty callCentre and not isClaimAccount}">
		<health_v2:bank_account_details_numbers xpath="${xpath}" className="${rowClass}" useValidator="${true}" />
	</c:if>

	<c:set var="fieldXpath" value="${xpath}/name" />
	<form_v3:row fieldXpath="${fieldXpath}" label="Bank Name" className="${rowClass}" renderLabelAsSimplesDialog="true">
		<field_v2:input xpath="${fieldXpath}" title="bank's name" required="true" className="health-bank_details-bank_name sessioncamexclude" additionalAttributes=" data-rule-regex='[a-zA-Z ]{1,30}' data-msg-regex='For bank name, please use only alphabetic characters (A-Z) and space, up to 30 characters in length.' " placeHolder="Bank Name"/>
	</form_v3:row>

	<c:set var="fieldXpath" value="${xpath}/account" />
	<form_v3:row fieldXpath="${fieldXpath}" label="Account Name" className="${rowClass}" renderLabelAsSimplesDialog="true">
		<field_v2:input xpath="${fieldXpath}" title="account name" required="true" className="health-bank_details-account_name sessioncamexclude" maxlength="50" additionalAttributes=" data-rule-regex='[a-zA-Z ]{1,30}' data-msg-regex='For account name, please use only alphabetic characters (A-Z) and space, up to 30 characters in length.' " placeHolder="Account Name"/>
	</form_v3:row>

	<c:if test="${empty callCentre or isClaimAccount}">
		<health_v2:bank_account_details_numbers xpath="${xpath}" forceNoNesting="true" useValidator="${false}" />
	</c:if>
</div>