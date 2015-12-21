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
<form_v2:fieldset legend="Your Contact Details" className="contact-details">
    <p>Let us help you find the best energy plan for you. Supply your details below</p>
    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_v2:row label="First name *" fieldXpath="${fieldXPath}" className="clear">
        <%--<field_new:input xpath="${fieldXPath}" required="false"/>--%>
        <field:person_name xpath="${fieldXPath}" required="${true}" title="your first name${competitionValidationText}" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/phone"/>
    <form_v2:row label="Your phone number *" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_telno xpath="${fieldXPath}"
                             required="${true}"
                             className="sessioncamexclude"
                             labelName="phone number${competitionValidationText}" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/email"/>
    <form_v2:row label="Your email address *" fieldXpath="${fieldXPath}" className="clear">
        <field_new:email xpath="${fieldXPath}" required="${true}" title="your email address${competitionValidationText}" />
    </form_v2:row>

    <c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>
    <c:set var="privacyOptinText">I understand ${brandedName} compares energy plans based on a standard tariff from a range of participating retailers. By providing my contact details I agree that ${brandedName} and its partner Thought World may contact me about the services they provide. I confirm that I have read the
        <form_v1:link_privacy_statement/>.</c:set>
    <form_v2:privacy_optin vertical="utilities" labelText="${privacyOptinText}"/>
    <c:if test="${competitionEnabled}">
        <utilities_new:competition/>
    </c:if>
    <field:hidden xpath="${xpath}/optinPhone" defaultValue="N"/>
    <field:hidden xpath="${xpath}/optinMarketing" defaultValue="N"/>

</form_v2:fieldset>