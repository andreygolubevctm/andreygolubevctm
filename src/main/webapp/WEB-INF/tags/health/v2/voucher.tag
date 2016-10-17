<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- HTML --%>
<div class="disableable-fields">
	<c:set var="fieldXpath" value="${xpath}/reason" />
	<form_v3:row label="Reason for voucher?" fieldXpath="${fieldXpath}" className="healthVoucherReasonRow">
		<field_v2:general_select xpath="${fieldXpath}" type="healthVoucherReason" required="true" title="the voucher reason" />
	</form_v3:row>

	<c:set var="fieldXpath" value="${xpath}/referrerref" />
	<form_v3:row label="Referring policy?" fieldXpath="${fieldXpath}" className="healthVoucherReferrerRefRow">
		<field_v2:input xpath="${fieldXpath}" required="true" placeHolder="Referrer Reference"  title="the referrer reference" />
	</form_v3:row>

	<c:set var="fieldXpath" value="${xpath}/value" />
	<form_v3:row label="Value of coupon?" fieldXpath="${fieldXpath}" className="healthVoucherValueRow">
		<field_v2:general_select xpath="${fieldXpath}" required="true" title="the coupon value" />
	</form_v3:row>

	<c:set var="fieldXpath" value="${xpath}/email" />
	<form_v3:row label="Can I confirm your email is?" fieldXpath="${fieldXpath}" className="healthVoucherEmailRow">
		<p id="healthVoucherEmail"></p>
	</form_v3:row>

	<c:set var="fieldXpath" value="${xpath}/approvedby" />
	<form_v3:row fieldXpath="${fieldXpath}" label="Approved By?" className="healthVoucherApprovedByRow">
		<p id="healthVoucherApprovedBy"></p>
		<field_v1:hidden xpath="${fieldXpath}" required="true" validationMessage="Voucher much be approved" />
	</form_v3:row>

	<c:set var="fieldXpath" value="${xpath}/authorisationcode" />
	<c:set var="wrapperClass" value="authorisation-column" />
	<form_v3:row fieldXpath="${fieldXpath}" label="Team Leader Authorisation?" className="healthVoucherAuthorisationRow" isNestedField="${false}" hideHelpIconCol="${true}" smRowOverride="6">
		<div class="voucher-validation-messages"><!-- empty --></div>
		<div class="col-xs-12 col-sm-7 ${wrapperClass}">
			<field_v1:password xpath="${fieldXpath}" required="true" title="authorisation code" placeHolder="authorisation code" />
		</div>
		<div class="col-xs-12 col-sm-5 ${wrapperClass} buttons">
			<a href="javascript:;" class="btn btn-cta btn-authorise">AUTHORISE</a>
			<a href="javascript:;" class="btn btn-save btn-reset">RESET</a>
		</div>
	</form_v3:row>
</div>

<div class="voucherDialogue">
	<div class="dialogue others">
		<simples:dialogue id="65" vertical="health" mandatory="true" />
	</div>
	<div class="dialogue referral">
		<simples:dialogue id="66" vertical="health" mandatory="true" />
	</div>
</div>