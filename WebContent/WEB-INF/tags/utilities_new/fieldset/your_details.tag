<%@ tag description="Utilities Your Details Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Your Details">
    <c:set var="fieldXPath" value="${xpath}/title" />
    <form_new:row label="Title" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_select xpath="${fieldXPath}" required="true" title="your title" items="=Please choose...,Mr=Mr,Mrs=Mrs,Miss=Miss,Ms=Ms,Dr=Dr,Prof=Prof" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/firstName" />
    <form_new:row label="First name" fieldXpath="${fieldXPath}" className="clear">
        <field_new:input xpath="${fieldXPath}" required="true" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/lastName" />
    <form_new:row label="Last name" fieldXpath="${fieldXPath}" className="clear">
        <field_new:input xpath="${fieldXPath}" required="true" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/dob" />
    <form_new:row label="Date of birth" fieldXpath="${fieldXPath}" className="clear date-of-birth">
        <field_new:person_dob xpath="${fieldXPath}"
                              required="true"
                              ageMin="17"
                              ageMax="99"
                              title="date of birth" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/mobileNumber" />
    <form_new:row label="Mobile number" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_mobile xpath="${fieldXPath}"
                             required="false"
                             className="sessioncamexclude"
                             placeHolder="04XX XXX XXX"
                             placeHolderUnfocused="04XX XXX XXX"
                             labelName="mobile phone number." />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/otherPhoneNumber" />
    <form_new:row label="Other phone number" fieldXpath="${fieldXPath}" className="clear">
        <field:contact_telno xpath="${fieldXPath}"
                             required="false"
                             className="sessioncamexclude"
                             isLandline="true"
                             placeHolder="(0X) XXXX XXXX"
                             placeHolderUnfocused="(0X) XXXX XXXX"
                             labelName="other phone number." />
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
    <group_new:elastic_address xpath="${fieldXPath}" type="R" />

    <h5 class="col-lg-9 col-lg-offset-3 col-sm-8 col-sm-offset-4 col-xs-12 row-content">Postal Address</h5>
    <form_new:row>
        <field_new:checkbox xpath="${xpath}/postalMatch" required="false" title="My postal address is the same" label="true" value="Y" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/postal" />
    <group_new:elastic_address xpath="${fieldXPath}" type="P" />

    <c:set var="fieldXPath" value="${xpath}/movingDate" />
    <form_new:row label="Move in date" fieldXpath="${fieldXPath}" id="enquiry_move_in_date_container" className="clear">
        <field_new:basic_date xpath="${fieldXPath}"
                              required="true"
                              title="moving in date" />
    </form_new:row>
</form_new:fieldset>

<go:script marker="js-head">
    $.validator.addMethod('validateSelectedResidentialPostCode', function(value, element) {
        var $element = $(element),
            startPostCode = $("#utilities_householdDetails_postcode").val(),
            enquiryPostCode = $element.val(),
            isValid = (startPostCode === enquiryPostCode),
            $errorFieldContainer = $("#utilities_application_details_address_error_container .error-field");

        // We only need to show one error if the suburb name has already complained, so let's only show that:
        if($errorFieldContainer.find("label[for='utilities_application_details_address_suburbName']").length)
            isValid = true;

        if(isValid)
            $errorFieldContainer.find("label[for='" + $element.attr("name") + "']").remove();

        return isValid;
    });

    $.validator.addMethod('validateSelectedResidentialSuburb', function(value, element) {
        var $element = $(element),
            startSuburb = $("#utilities_householdDetails_suburb").val(),
            enquirySuburb = $element.find("option:selected").length ? $element.find("option:selected").text() : $element.val(),
            isValid = (startSuburb === enquirySuburb),
            $errorFieldContainer = $("#utilities_application_details_address_error_container .error-field");

        if(isValid)
            $errorFieldContainer.find("label[for='" + $element.attr("name") + "']").remove();

        return isValid;
    });

    $.validator.addMethod('validateEnteredPhoneNumber', function(value, element) {
        var mobileInput = $("#utilities_application_details_mobileNumberinput").val(),
            otherInput = $("#utilities_application_details_otherPhoneNumberinput").val();

        return !(!mobileInput && !otherInput);
    });
</go:script>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<go:validate selector="${name}_address_suburbName" rule="validateSelectedResidentialSuburb" parm="true" message="Your address does not match the original suburb provided." />
<go:validate selector="${name}_address_suburb" rule="validateSelectedResidentialSuburb" parm="true" message="The selected suburb does not match the original suburb selected." />

<go:validate selector="${name}_address_postCode" rule="validateSelectedResidentialPostCode" parm="true" message="Your address does not match the original postcode provided." />
<go:validate selector="${name}_address_nonStdPostCode" rule="validateSelectedResidentialPostCode" parm="true" message="The entered postcode does not match the original postcode provided." />

<c:set var="phoneErrorMessage" value="Please enter your mobile phone number or other number." />
<go:validate selector="${name}_mobileNumberinput" rule="validateEnteredPhoneNumber" parm="true" message="${phoneErrorMessage}" />
<go:validate selector="${name}_otherNumberinput" rule="validateEnteredPhoneNumber" parm="true" message="${phoneErrorMessage}" />