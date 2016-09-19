<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- HTML --%>
<c:set var="fieldXpath" value="${xpath}/reason" />
<form_v3:row label="Reason for voucher?" fieldXpath="${fieldXpath}" className="healthVoucherReasonRow">
	<field_v2:general_select xpath="${fieldXpath}" type="healthVoucherReason" required="true" title="the voucher reason" />
</form_v3:row>

<c:set var="fieldXpath" value="${xpath}/refererref" />
<form_v3:row label="Referring policy?" fieldXpath="${fieldXpath}" className="healthVoucherRefererRefRow hidden">
	<field_v2:input xpath="${fieldXpath}" required="true" placeHolder="Referer Reference"  title="the referer reference" />
</form_v3:row>

<c:set var="fieldXpath" value="${xpath}/value" />
<form_v3:row label="Value of coupon?" fieldXpath="${fieldXpath}" className="healthVoucherValueRow">
	<field_v2:general_select xpath="${fieldXpath}input" required="true" title="the coupon value" />
	<field_v1:hidden xpath="${fieldXpath}" required="true" />
</form_v3:row>

<c:set var="fieldXpath" value="${xpath}/email" />
<form_v3:row label="Can I confirm your email is?" fieldXpath="${fieldXpath}" className="healthVoucherEmailRow">
	<field_v2:email xpath="${fieldXpath}" required="true" title="email confirmation" />
</form_v3:row>

<c:set var="fieldXpath" value="${xpath}/approvedby" />
<form_v3:row fieldXpath="${fieldXpath}" label="Approved By?" className="healthVoucherApprovedByRow hidden">
	<field_v2:input xpath="${fieldXpath}" required="true" title="approved by" readOnly="true" />
</form_v3:row>

<c:set var="fieldXpath" value="${xpath}/authorisationcode" />
<form_v3:row fieldXpath="${fieldXpath}" label="Team Leader Authorisation?" className="healthVoucherAuthorisationRow" isNestedField="${true}" hideHelpIconCol="${true}" smRowOverride="6">
	<field_v2:input xpath="${xpath}/authorisationcode" required="true" title="authorisation code" placeHolder="authorisation code" />
	<div class="col-xs-12 col-sm-6 ${wrapperClass}">
		<a href="javascript:;" class="btn btn-cta btn-authorise">AUTHORISE</a>
	</div>
</form_v3:row>

<div class="voucherDialogue">
	<div class="dialogue">
		<simples:dialogue id="65" vertical="health" mandatory="true" />
	</div>
	<div class="dialogue">
		<simples:dialogue id="66" vertical="health" mandatory="true" />
	</div>
</div>