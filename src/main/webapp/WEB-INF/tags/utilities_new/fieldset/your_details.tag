<%@ tag import="java.util.GregorianCalendar" %>
<%@ tag description="Utilities Your Details Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<fmt:setLocale value="en_AU" scope="session" />

<jsp:useBean id="nowPlusDay" class="java.util.GregorianCalendar" />
<% nowPlusDay.add(GregorianCalendar.DAY_OF_YEAR, 1); %>
<fmt:formatDate var="nowPlusDay_Date" pattern="yyyy-MM-dd" value="${nowPlusDay.time}" />

<% nowPlusDay.add(GregorianCalendar.YEAR, 5); %>
<fmt:formatDate var="nowPlusYears_Date" pattern="yyyy-MM-dd" value="${nowPlusDay.time}" />

<form_v2:fieldset legend="Your Details">
    <c:set var="fieldXPath" value="${xpath}/title" />
    <form_v2:row label="Title" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_select xpath="${fieldXPath}" required="true" title="your title" items="=Please choose...,Mr=Mr,Mrs=Mrs,Miss=Miss,Ms=Ms,Dr=Dr,Prof=Prof" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_v2:row label="First name" fieldXpath="${fieldXPath}" className="clear">
        <field:person_name xpath="${fieldXPath}" required="true" title="First Name"/>
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/lastName" />
    <form_v2:row label="Last name" fieldXpath="${fieldXPath}" className="clear">
        <field:person_name xpath="${fieldXPath}" required="true" title="Last Name"/>
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/dob" />
    <form_v2:row label="Date of birth" fieldXpath="${fieldXPath}" className="clear date-of-birth">
        <field_new:person_dob xpath="${fieldXPath}"
                              required="true"
                              ageMin="17"
                              ageMax="99"
                              title="date of birth" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/mobileNumber" />
    <form_v2:row label="Mobile number" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_mobile xpath="${fieldXPath}"
                             required="false"
                             className="sessioncamexclude"
                             placeHolder="04XX XXX XXX"
                             placeHolderUnfocused="04XX XXX XXX"
                             labelName="mobile phone number." additionalAttributes=" data-rule-validateEnteredPhoneNumber='true' data-msg-validateEnteredPhoneNumber='Please enter your mobile phone number or other number.'" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/otherPhoneNumber" />
    <form_v2:row label="Other phone number" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_telno xpath="${fieldXPath}"
                             required="false"
                             className="sessioncamexclude"
                             isLandline="true"
                             placeHolder="(0X) XXXX XXXX"
                             placeHolderUnfocused="(0X) XXXX XXXX"
                             labelName="other phone number." />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/email" />
    <form_v2:row label="Email address" fieldXpath="${fieldXPath}" className="clear">
        <field_new:email xpath="${fieldXPath}" required="true" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/receiveInfoCheck" />
    <form_v2:row label="" fieldXpath="${fieldXPath}" id="receiveInfoCheckContainer" className="clear">
        <c:set var="receiveCommunicationText">I would like to receive electronic communication from <content:get key="boldedBrandDisplayName" /></c:set>
        <field_new:checkbox xpath="${fieldXPath}" required="false" title="${receiveCommunicationText}" label="true" value="Y" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/address" />
    <h5 class="col-lg-9 col-lg-offset-3 col-sm-8 col-sm-offset-4 col-xs-12 row-content">Residential Address</h5>
    <group_v2:elastic_address xpath="${fieldXPath}" type="R" suburbAdditionalAttributes=" data-rule-validateSelectedResidentialSuburb='true' data-msg-validateSelectedResidentialSuburb='Your address does not match the original suburb provided.'" suburbNameAdditionalAttributes=" data-rule-validateSelectedResidentialSuburb='true' data-msg-validateSelectedResidentialSuburb='The selected suburb does not match the original suburb selected.'" postCodeAdditionalAttributes=" data-rule-validateSelectedResidentialPostCode='true' data-msg-validateSelectedResidentialPostCode='Your address does not match the original postcode provided.'" postCodeNameAdditionalAttributes=" data-rule-validateSelectedResidentialPostCode='true' data-msg-validateSelectedResidentialPostCode='The entered postcode does not match the original postcode provided.'" />

    <h5 class="col-lg-9 col-lg-offset-3 col-sm-8 col-sm-offset-4 col-xs-12 row-content">Postal Address</h5>
    <form_v2:row>
        <field_new:checkbox xpath="${xpath}/postalMatch" required="false" title="My postal address is the same" label="true" value="Y" />
    </form_v2:row>

    <c:set var="fieldXPath" value="${xpath}/postal" />
    <group_v2:elastic_address xpath="${fieldXPath}" type="P" />

    <c:set var="fieldXPath" value="${xpath}/movingDate" />
    <form_v2:row label="Move in date" fieldXpath="${fieldXPath}" id="enquiry_move_in_date_container" className="clear">
        <field_new:basic_date xpath="${fieldXPath}"
                              required="true"
                              maxDate="${nowPlusYears_Date}"
                              minDate="${nowPlusDay_Date}"
                              title="moving in date" />
    </form_v2:row>
</form_v2:fieldset>