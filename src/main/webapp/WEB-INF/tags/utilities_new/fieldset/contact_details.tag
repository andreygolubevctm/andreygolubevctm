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
    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_new:row label="First name" fieldXpath="${fieldXPath}" className="clear">
        <%--<field_new:input xpath="${fieldXPath}" required="false"/>--%>
        <field:person_name xpath="${fieldXPath}" required="${true}" title="your first name${competitionValidationText}" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/email"/>
    <form_new:row label="Your email address" fieldXpath="${fieldXPath}" className="clear">
        <field_new:email xpath="${fieldXPath}" required="${true}" title="your email address${competitionValidationText}" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/phone"/>
    <form_new:row label="Yours phone number" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_telno xpath="${fieldXPath}"
                             required="${true}"
                             className="sessioncamexclude"
                             labelName="phone number${competitionValidationText}" />
    </form_new:row>

    <c:if test="${competitionEnabled}">
        <utilities_new:competition/>
    </c:if>

    <c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>
    <c:set var="privacyOptinText">I understand ${brandedName} compares energy plans based on a standard tariff from a range of participating retailers. By providing my contact details I agree that ${brandedName} and its partner Thought World may contact me about the services they provide. I confirm that I have read the
        <form:link_privacy_statement/>.</c:set>
    <form_new:privacy_optin vertical="utilities" labelText="${privacyOptinText}"/>
    <field:hidden xpath="${xpath}/optinPhone" defaultValue="N"/>
    <field:hidden xpath="${xpath}/optinMarketing" defaultValue="N"/>
</form_new:fieldset>