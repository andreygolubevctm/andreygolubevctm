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
<form_v2:fieldset legend="Your details" className="contact-details" postLegend="Enter your details below and we'll show you products that match your needs on the next page">
    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_v3:row label="First name" fieldXpath="${fieldXPath}" className="clear">
        <%--<field_v2:input xpath="${fieldXPath}" required="false"/>--%>
        <field_v1:person_name xpath="${fieldXPath}" required="${true}" title="your first name${competitionValidationText}" />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/phone"/>
    <form_v3:row label="Your phone number" fieldXpath="${fieldXPath}" className="clear">
        <field_v1:flexi_contact_number xpath="${fieldXPath}"
                maxLength="20"
                required="${true}"
                className="sessioncamexclude"
                labelName="phone number${competitionValidationText}"/>
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/email"/>
    <form_v3:row label="Your email address" fieldXpath="${fieldXPath}" className="clear">
        <field_v2:email xpath="${fieldXPath}" required="${true}" title="your email address${competitionValidationText}" />
    </form_v3:row>

    <c:if test="${competitionEnabled}">
        <utilities_v2:competition/>
    </c:if>
    <field_v1:hidden xpath="${xpath}/optinPhone" defaultValue="N"/>
    <field_v1:hidden xpath="${xpath}/optinMarketing" defaultValue="N"/>

</form_v2:fieldset>