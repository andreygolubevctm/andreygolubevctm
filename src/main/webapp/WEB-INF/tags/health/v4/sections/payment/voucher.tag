<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- HTML --%>
<div class="disableable-fields">
    <c:set var="fieldXpath" value="${xpath}/reason" />
    <form_v4:row label="Reason for voucher?"
                 fieldXpath="${fieldXpath}" className="healthVoucherReasonRow">
        <field_v2:general_select xpath="${fieldXpath}" type="healthVoucherReason" required="true" title="voucher reason" additionalAttributes="data-attach='true'" />
        <p id="healthVoucherReason" class="display-only"></p>
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/referrerref" />
    <form_v4:row label="Referring policy number?" fieldXpath="${fieldXpath}" className="healthVoucherReferrerRefRow">
        <field_v2:input xpath="${fieldXpath}" required="true" placeHolder="Policy number"  title="referring policy number" pattern="[0-9]*" integerKeyPressLimit="true" additionalAttributes="data-attach='true' data-rule-digits='true' data-msg-digits='Please enter the referring policy number'" />
        <p id="healthVoucherReferrerRef" class="display-only"></p>
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/value" />
    <form_v4:row label="Value of coupon?" fieldXpath="${fieldXpath}" className="healthVoucherValueRow">
        <field_v2:general_select xpath="${fieldXpath}" required="true" title="coupon value" additionalAttributes="data-attach='true'" />
        <p id="healthVoucherValue" class="display-only"></p>
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/email" />
    <form_v4:row label="Can I confirm your email is?" fieldXpath="${fieldXpath}" className="healthVoucherEmailRow">
        <p id="healthVoucherEmail" class="display-only"></p>
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/approvedby" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Approved By?" className="healthVoucherApprovedByRow">
        <p id="healthVoucherApprovedBy" class="display-only"></p>
        <field_v1:hidden xpath="${fieldXpath}" required="true" validationMessage="Voucher much be approved" />
    </form_v4:row>

    <c:set var="fieldXpath" value="${xpath}/authorisationcode" />
    <c:set var="wrapperClass" value="authorisation-column" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Team Leader Authorisation?" className="healthVoucherAuthorisationRow" isNestedField="${false}" smRowOverride="6">
        <div class="voucher-validation-messages"><!-- empty --></div>
        <div class="col-xs-12 col-sm-7 ${wrapperClass}">
            <field_v1:password xpath="${fieldXpath}" required="true" title="authorisation code" placeHolder="authorisation code" additionalAttributes="data-msg-required='Please enter an authorisation code' data-attach='true'" />
        </div>
        <div class="col-xs-12 col-sm-5 ${wrapperClass} buttons">
            <a href="javascript:;" class="btn btn-cta btn-authorise">AUTHORISE</a>
            <a href="javascript:;" class="btn btn-save btn-reset">RESET</a>
        </div>
    </form_v4:row>
</div>