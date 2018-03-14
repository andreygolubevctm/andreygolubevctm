<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Your Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactName"	value="${go:nameFromXpath(xpath)}_name" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"			value="${go:nameFromXpath(xpath)}_call" />

<c:set var="val_optin"				value="Y" />
<c:set var="val_optout"				value="N" />

<%-- Calculate the year for continuous cover - changes on 1st July each year --%>
<c:set var="continuousCoverYear" value="${financialYearUtils.getContinuousCoverYear()}" />

<%-- Vars for competition --%>
<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionSecret"><content:get key="competitionSecret"/></c:set>
<c:set var="competitionEnabled" value="${false}" />
<c:if test="${competitionEnabledSetting == 'Y' && competitionSecret == 'kSdRdpu5bdM5UkKQ8gsK'}">
    <c:set var="competitionEnabled" value="${true}" />
</c:if>

<%-- Name is mandatory for both online and callcentre, other fields only mandatory for online --%>
<c:set var="required" value="${true}" />
<c:if test="${callCentre}">
    <c:set var="required" value="${false}" />
</c:if>

<%-- HTML --%>


<form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<%-- Please check the database for this content --%>
            <c:if test="${competitionEnabled == true}">
                <content:get key="healthCompetitionRightColumnPromo"/>
            </c:if>

			<health_v2_content:sidebar />
		</jsp:attribute>

    <jsp:body>

        <simples:dialogue id="52" vertical="health" />

        <c:set var="subText" value="" />
        <c:if test="${not callCentre}">
            <c:set var="subText" value="Enter your details below and we'll show you products that match your needs on the next page" />
        </c:if>

        <form_v3:fieldset id="health-contact-fieldset" legend="Your details" postLegend="${subText}" >

            <c:set var="firstNamePlaceHolder">
                <content:get key="firstNamePlaceHolder"/>
            </c:set>

            <c:set var="emailPlaceHolder">
                <content:get key="emailPlaceHolder"/>
            </c:set>

            <c:set var="fieldXpath" value="${xpath}/name" />
            <form_v3:row label="Your first name" fieldXpath="${fieldXpath}" className="clear required_input">
                <field_v1:person_name xpath="${fieldXpath}" title="name" required="true" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/flexiContactNumber" />
            <form_v3:row label="Your phone number" fieldXpath="${fieldXpath}" className="clear">
                <field_v1:flexi_contact_number xpath="${fieldXpath}" required="${required}" maxLength="20"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/email" />
            <form_v3:row label="Your email address" fieldXpath="${fieldXpath}" className="clear">
                <field_v2:email xpath="${fieldXpath}" title="your email address" required="${required}"  />
                <field_v1:hidden xpath="${xpath}/emailsecondary" />
                <field_v1:hidden xpath="${xpath}/emailhistory" />
            </form_v3:row>

            <group_v3:contact_numbers_hidden xpath="${xpath}/contactNumber" />

            <%-- Optin fields (hidden) for email and phone --%>
            <field_v1:hidden xpath="${xpath}/optInEmail" defaultValue="${val_optout}" />
            <field_v1:hidden xpath="${xpath}/call" defaultValue="${val_optout}" />

            <%-- form privacy_optin --%>
            <c:choose>
                <%-- Only render a hidden field when the checkbox has already been selected --%>
                <c:when test="${data['health/privacyoptin'] eq 'Y'}">
                    <field_v1:hidden xpath="health/privacyoptin" defaultValue="Y" constantValue="Y" />
                </c:when>
                <c:otherwise>
                    <field_v1:hidden xpath="health/privacyoptin" className="validate" />
                </c:otherwise>
            </c:choose>

            <c:set var="termsAndConditions">
                <%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
                I understand and accept the <a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a> and <form_v1:link_privacy_statement />. I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may call me during the <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">Call Centre opening hours</a>, and email or SMS me, about the services it provides.
            </c:set>

            <%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
            <form_v2:row className="health-contact-details-optin-group hidden" hideHelpIconCol="true">
                <field_v2:checkbox
                        xpath="${xpath}/optin"
                        value="Y"
                        className="validate"
                        required="true"
                        label="${true}"
                        title="${termsAndConditions}"
                        errorMsg="Please agree to the Terms &amp; Conditions"
                        customAttribute="data-attach='true' checked='checked'" />
            </form_v2:row>

            <%-- Did it this way to prevent the snapshot from pushing the fields below up/down depending on the option selected with the health_situation_healthCvr field --%>
            <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
            <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

            <c:set var="fieldXpath" value="${xpath}/primary/dob" />
            <form_v3:row label="Your date of birth" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
                <field_v2:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/cover" />
            <form_v3:row label="Do you currently hold private Hospital insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
            <form_v3:row label="Have you had continuous Hospital cover for the last 10 years/since 1st July of turning 31?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group text-danger"  helpId="239" additionalHelpAttributes="data-content-replace='{{year}},${continuousCoverYear}'">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
            </form_v3:row>

            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${xpath}/primary/lhc" />
                <form_v2:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287">
                    <field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
                </form_v2:row>
            </c:if>

        </form_v3:fieldset>

        <%--dynamic script--%>
        <%--if customer has cover--%>
        <simples:dialogue id="53" vertical="health" className="simples-dialogue-primary-current-cover hidden" />

        <form_v3:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">
            <c:set var="fieldXpath" value="${xpath}/partner/dob" />
            <form_v3:row label="Your partner's date of birth" fieldXpath="${fieldXpath}">
                <field_v2:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/cover" />
            <form_v3:row label="Does your partner currently hold private Hospital insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
            <form_v3:row label="Has your partner had continuous Hospital cover for the last 10 years/since 1st July of turning 31?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group text-danger" helpId="239" additionalHelpAttributes="data-content-replace='{{year}},${continuousCoverYear}'">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
            </form_v3:row>

            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${xpath}/partner/lhc" />
                <form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}">
                    <field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
                </form_v2:row>
            </c:if>
        </form_v3:fieldset>

        <%--dynamic script--%>
        <%--if customer has cover--%>
        <simples:dialogue id="53" vertical="health" className="simples-dialogue-partner-current-cover hidden" />
        <simples:dialogue id="26" vertical="health" mandatory="true" />

        <form_v3:fieldset id="australian-government-rebate" legend="Australian Government Rebate" postLegend="Most Australians can reduce their upfront health insurance costs by applying the Government Rebate.">
            <c:set var="mandatory" value=""/>

            <c:if test="${callCentre}">
                <c:set var="mandatory" value=" text-danger"/>
            </c:if>

            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${xpath}/incomeBasedOn" />
                <form_v3:row label="I wish to calculate my rebate based on" fieldXpath="${fieldXpath}" helpId="288" className="health_cover_details_incomeBasedOn" id="${name}_incomeBase">
                    <field_v2:array_radio items="S=Single income,H=Household income" style="group" xpath="${fieldXpath}" title="income based on" required="true"  />
                </form_v3:row>
            </c:if>

            <c:set var="fieldXpath" value="${xpath}/dependants" />
            <form_v3:row label="This is based on your taxable income and number of dependants, so can I confirm, how many dependent children do you have?" fieldXpath="${fieldXpath}" helpId="241" className="health_cover_details_dependants ${mandatory}">
                <field_v2:count_select xpath="${fieldXpath}" max="12" min="1" title="number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/income" />
            <form_v3:row label="To receive the correct rebate, please select your expected annual income?" fieldXpath="${fieldXpath}" id="${name}_tier" className="${mandatory}">
                <field_v2:array_select xpath="${fieldXpath}" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income"/>
                <span class="fieldrow_legend" id="${name}_incomeMessage"></span>
                <c:set var="income_label_xpath" value="${xpath}/incomelabel" />
                <div class="fieldrow_legend" id="health_healthCover_tier_row_legend"></div>
                <div class="hidden text-justify" id="health_healthCover_tier_row_legend_mls">
                    If you earn under $90,000 (or $180,000 total, for couples or families) in any financial year, you won’t be liable to pay the Medicare Levy Surcharge in that financial year. For help or further information call us on ${callCentreNumber}.
                </div>
                <input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/rebate" />
            <form_v3:row label="Do you want to claim the Government Rebate?" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate hidden">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="Do you want to claim the Government Rebate?" required="true" id="${name}_health_cover_rebate" className="rebate btn-group-wrap" additionalAttributes=" data-attach='true'"/>
            </form_v3:row>

            <form_v3:row label="&nbsp;" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate">
                <field_v2:checkbox xpath="${fieldXpath}/dontApplyRebate" value="N" id="${name}_health_cover_rebate_dontApplyRebate" title="Tick here if your customer doesn't want to claim the Government Rebate." required="false" label="Tick here if your customer doesn't want to claim the Government Rebate." className="rebate btn-group-wrap"/>
            </form_v3:row>

        </form_v3:fieldset>

        <%--dynamic scripts--%>
        <simples:dialogue id="37" vertical="health" mandatory="true" />

    </jsp:body>

</form_v2:fieldset_columns>

<field_v1:hidden xpath="health/altContactFormRendered" constantValue="Y" />



<%-- JAVASCRIPT --%>
<go:script marker="onready">

    var contactEmailElement = $('#health_contactDetails_email');
    var contactMobileElementInput = $('#${contactNumber}_mobileinput');
    var contactOtherElementInput = $('#${contactNumber}_otherinput');

    phoneNumberInteractFunction = function(){

    var tel = $(this).val();

    <%-- IE sees the placeholder as its value so let's clear that if necessary--%>
    if( tel.indexOf('(00') === 0 ) {
    tel = '';
    }

    <%-- Optin for callback only if phone entered AND universal optin checked --%>
    if( $('#${name}_optin').is(':checked') ) {
    $('#${optIn}').prop('checked', (tel.length ? true : false));
    } else {
    $('#${optIn}').prop('checked', false);
    }


    }

    contactMobileElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);
    contactOtherElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);

    <%-- Use both elements as the checkbox sits over the label --%>
    var universalOptinElements = [
    $('#${name}_optin'),
    $('#${name}_optin').siblings('label').first()
    ];

    <%-- Trigger blur events on phone and email elements when the
        the optin checkbox is clicked --%>
    for(var i = 0; i < universalOptinElements.length; i++) {
    universalOptinElements[i].on('click', function(){
    contactEmailElement.trigger('blur');
    contactOtherElementInput.trigger('blur');
    contactMobileElementInput.trigger('blur');
    });
    }

    <%-- COMPETITION START --%>
    $('#health_contactDetails_competition_optin').on('change', function() {
    if ($(this).is(':checked')) {
    $('#${contactName}').setRequired(true, 'Please enter your name to be eligible for the competition');
    contactEmailElement.setRequired(true, 'Please enter your email address to be eligible for the competition');
    contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please enter your phone number to be eligible for the competition');
    }
    else {
    <c:if test="${empty callCentre and required == false}">$('#${contactName}').setRequired(false);</c:if>
    <%-- This rule applies to both call center and non call center users --%>
    <c:if test="${not empty callCentre or required}">
        $('#${contactName}').setRequired(true, 'Please enter name');
    </c:if>
    <%-- These rules are separate to the callCenter one above as they only apply to non simples uers --%>
    <c:if test="${required}">
        contactEmailElement.setRequired(true, 'Please enter your email address');
        contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please include at least one phone number');
    </c:if>
    <c:if test="${required == false}">
        contactEmailElement.setRequired(false);
        contactMobileElementInput.removeRule('requireOneContactNumber');
        $('#${contactName}').valid();
        contactEmailElement.valid();
        contactMobileElementInput.valid();
        contactOtherElementInput.valid();
    </c:if>
    }
    });
    <%-- COMPETITION END --%>
</go:script>
