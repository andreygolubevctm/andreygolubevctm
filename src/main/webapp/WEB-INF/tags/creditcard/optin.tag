<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Opt In Checkbox"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="competition"		required="false" 	rtexprvalue="true"	description="To show competition optin or not" %>


<c:if test="${competition eq true}">
    <form_v2:row hideHelpIconCol="true" className="optin-group">
        <c:set var="label">
            <content:get key="competitionCheckboxText"/>
        </c:set>
        <field_v2:checkbox
                xpath="${xpath}/competition/optIn"
                value="Y"
                className="validate"
                required="true"
                label="${true}"
                title="${label}"
                errorMsg="Please confirm you agree to the terms and conditions of the promotion" />
    </form_v2:row>
</c:if>

<form_v2:row hideHelpIconCol="true" className="optin-group">
    <c:set var="label">
        I understand <content:get key="boldedBrandDisplayName" /> compares credit card products from a range of suppliers. By providing my contact details I agree that <content:get key="boldedBrandDisplayName" /> may contact me about the services they provide. I confirm that I have read the <form_v1:link_privacy_statement overrideLabel="Privacy Statement" /> and have read, understood and accept the <a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>.
    </c:set>
    <field_v2:checkbox
            xpath="${xpath}/privacyoptin"
            value="Y"
            className="validate"
            required="true"
            label="${true}"
            title="${label}"
            errorMsg="Please confirm you have read the privacy statement and website terms of use" />
    <field_v1:hidden xpath="${xpath}/terms" defaultValue="N" />
    <field_v1:hidden xpath="${xpath}/marketing" defaultValue="N" />
</form_v2:row>