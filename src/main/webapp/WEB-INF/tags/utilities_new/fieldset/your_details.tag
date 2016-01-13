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

<form_new:fieldset legend="Your Details">
    <c:set var="fieldXPath" value="${xpath}/title" />
    <form_new:row label="Title" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_select xpath="${fieldXPath}" required="true" title="your title" items="=Please choose...,Mr=Mr,Mrs=Mrs,Miss=Miss,Ms=Ms,Dr=Dr,Prof=Prof" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_new:row label="First name" fieldXpath="${fieldXPath}" className="clear">
        <field:person_name xpath="${fieldXPath}" required="true" title="First Name"/>
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/lastName" />
    <form_new:row label="Last name" fieldXpath="${fieldXPath}" className="clear">
        <field:person_name xpath="${fieldXPath}" required="true" title="Last Name"/>
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/dob" />
    <form_new:row label="Date of birth" fieldXpath="${fieldXPath}" className="clear date-of-birth">
        <field_new:person_dob xpath="${fieldXPath}"
                              required="true"
                              ageMin="17"
                              ageMax="99"
                              title="date of birth" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/mobile" />
    <form_new:row label="Mobile number" fieldXpath="${fieldXPath}" className="clear">
        <field:flexi_contact_number xpath="${fieldXPath}"
                                    maxLength="20"
                                    required="false"
                                    className="contactField sessioncamexclude"
                                    labelName="mobile number"
                                    phoneType="Mobile"
                                    requireOnePlusNumber="true"/>
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/other" />
    <form_new:row label="Other phone number" fieldXpath="${fieldXPath}" className="clear">
        <field:flexi_contact_number xpath="${fieldXPath}"
                                    maxLength="20"
                                    required="false"
                                    className="contactField sessioncamexclude"
                                    labelName="other number"
                                    phoneType="LandLine"
                                    requireOnePlusNumber="true"/>
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/email" />
    <form_new:row label="Email address" fieldXpath="${fieldXPath}" className="clear">
        <field_new:email xpath="${fieldXPath}" required="true" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/receiveInfoCheck" />
    <form_new:row label="" fieldXpath="${fieldXPath}" id="receiveInfoCheckContainer" className="clear">
        <c:set var="receiveCommunicationText">I would like to receive electronic communication from <content:get key="boldedBrandDisplayName" /></c:set>
        <field_new:checkbox xpath="${fieldXPath}" required="false" title="${receiveCommunicationText}" label="true" value="Y" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/address" />
    <h5 class="col-lg-9 col-lg-offset-3 col-sm-8 col-sm-offset-4 col-xs-12 row-content">Residential Address</h5>
    <%-- autocomplete set to false due to chrome bug https://code.google.com/p/chromium/issues/detail?id=468153 --%>
    <group_new:elastic_address xpath="${fieldXPath}"
                               type="R"
                               suburbAdditionalAttributes=" data-rule-validateSelectedResidentialSuburb='true' data-msg-validateSelectedResidentialSuburb='Your address does not match the original suburb provided.' autocomplete='false'"
                               suburbNameAdditionalAttributes=" data-rule-validateSelectedResidentialSuburb='true' data-msg-validateSelectedResidentialSuburb='The selected suburb does not match the original suburb selected.' autocomplete='false'"
                               postCodeAdditionalAttributes=" data-rule-validateSelectedResidentialPostCode='true' data-msg-validateSelectedResidentialPostCode='Your address does not match the original postcode provided.' autocomplete='false'"
                               postCodeNameAdditionalAttributes=" data-rule-validateSelectedResidentialPostCode='true' data-msg-validateSelectedResidentialPostCode='The entered postcode does not match the original postcode provided.' autocomplete='false'" />

    <h5 class="col-lg-9 col-lg-offset-3 col-sm-8 col-sm-offset-4 col-xs-12 row-content">Postal Address</h5>
    <form_new:row>
        <field_new:checkbox xpath="${xpath}/postalMatch" required="false" title="My postal address is the same" label="true" value="Y" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/postal" />
    <%-- autocomplete set to false due to chrome bug https://code.google.com/p/chromium/issues/detail?id=468153 --%>
    <group_new:elastic_address xpath="${fieldXPath}"
                               type="P"
                               postCodeAdditionalAttributes="autocomplete='false'"
                               postCodeNameAdditionalAttributes="autocomplete='false'"
                               suburbAdditionalAttributes="autocomplete='false'"
                               suburbNameAdditionalAttributes="autocomplete='false'"
                               />

    <c:set var="fieldXPath" value="${xpath}/movingDate" />
    <form_new:row label="Move in date" fieldXpath="${fieldXPath}" id="enquiry_move_in_date_container" className="clear">
        <field_new:basic_date xpath="${fieldXPath}"
                              required="true"
                              maxDate="${nowPlusYears_Date}"
                              minDate="${nowPlusDay_Date}"
                              title="moving in date" />
    </form_new:row>
</form_new:fieldset>