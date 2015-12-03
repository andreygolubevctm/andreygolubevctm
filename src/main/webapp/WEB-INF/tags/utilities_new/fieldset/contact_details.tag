<%@ tag description="Utilities Contact Details" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionEnabled" scope="request" value="${competitionEnabledSetting == 'Y'}"/>
<c:if test="${competitionEnabled eq true}">
    <c:set var="competitionValidationText" value=" to be eligible for the competition" />
</c:if>

<%-- The email and phone are required on load to set the proper validation rules, and on initialise, have their required attribute removed --%>
<form_new:fieldset legend="Your Contact Details" className="contact-details">
    <p>Let us help you find the best energy plan for you. Supply your details below</p>
    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_new:row label="First name *" fieldXpath="${fieldXPath}" className="clear">
        <%--<field_new:input xpath="${fieldXPath}" required="false"/>--%>
        <field:person_name xpath="${fieldXPath}" required="${true}" title="your first name${competitionValidationText}" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/phone"/>
    <form_new:row label="Your phone number *" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_telno xpath="${fieldXPath}"
                             required="${true}"
                             className="sessioncamexclude"
                             labelName="phone number${competitionValidationText}" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/email"/>
    <form_new:row label="Your email address *" fieldXpath="${fieldXPath}" className="clear">
        <field_new:email xpath="${fieldXPath}" required="${true}" title="your email address${competitionValidationText}" />
    </form_new:row>

    <c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>
    <c:set var="privacyOptinText">* I agree that Thought World, partner of ${brandedName}, may contact me about energy plans from a range of retailers.  I confirm that I have read the <form:link_privacy_statement/>.</c:set>
    <c:set var="optinMarketingText">Yes, keep me updated about news and special offers from ${brandedName}</c:set>
    <form_new:privacy_optin vertical="utilities" labelText="${privacyOptinText}"/>
    <form_new:row className="${vertical}-contact-details-optin-group" hideHelpIconCol="true">
        <field_new:checkbox
                xpath="${xpath}/optinMarketing"
                value="Y"
                className="validate"
                required="false"
                label="${true}"
                title="${optinMarketingText}"
                errorMsg="${error_text}" />
    </form_new:row>
    <c:if test="${competitionEnabled}">
        <utilities_new:competition/>
    </c:if>
    <field:hidden xpath="${xpath}/optinPhone" defaultValue="N"/>

</form_new:fieldset>