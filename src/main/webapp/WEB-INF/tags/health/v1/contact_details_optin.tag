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

        <simples:dialogue id="52"  vertical="health" />
        <simples:dialogue id="120" vertical="health" className="simples-dialog-nextgenoutbound" />
	    <simples:dialogue id="124" vertical="health" className="simples-dialog-nextgencli" />

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
            <form_v3:row label="Can I please have your first Name?" fieldXpath="${fieldXpath}" className="clear required_input" renderLabelAsSimplesDialog="blue">
                <field_v1:person_name xpath="${fieldXpath}" title="name" required="true" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/flexiContactNumber" />
            <form_v3:row label="Your Best contact Number?" fieldXpath="${fieldXpath}" className="clear" renderLabelAsSimplesDialog="blue">
                <field_v1:flexi_contact_number xpath="${fieldXpath}" required="${required}" maxLength="20"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/email" />
            <form_v3:row label="Your email address" fieldXpath="${fieldXpath}" className="clear" renderLabelAsSimplesDialog="blue">
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
            <c:set var="name" value="${go:nameFromXpath(xpath)}" />

            <c:set var="fieldXpath" value="${xpath}/primary/dob" />
            <form_v3:row label="What's your Date of Birth?" fieldXpath="${fieldXpath}" className="health-your_details-dob-group" renderLabelAsSimplesDialog="blue">
                <field_v2:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
            </form_v3:row>

            <%-- Medicare card question --%>
            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/cover" />
                <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                <c:set var="medicareQuestionLabel"><content:get key="medicareQuestionLabel" /></c:set>

                <form_v3:row label="To confirm your Medicare eligibility, are all people to be covered on this policy Australian citizens or permanent residents?" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare text-danger" helpId="564" renderLabelAsSimplesDialog="red">
                    <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                          title="your Medicare card cover" required="true" className="health-medicare_details-card"
                                          id="${name}_cover" />
                </form_v3:row>

                <div id="medicare-questions-nzcitizen" class="hidden">
                    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/nzcitzen" />
                    <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                    <c:set var="nzMedicareRulesLabel">Are all people to be covered on this policy New Zealand Citizens?</c:set>
                    <form_v3:row label="${nzMedicareRulesLabel}" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_nz" renderLabelAsSimplesDialog="blue">
                        <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                              title="${nzMedicareRulesLabel}r" required="true" />
                    </form_v3:row>

                    <div id="medicare-questions-hasmedicarecard" class="hidden">
                        <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/hasmedicarecard" />
                        <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                        <form_v3:row label="Do you currently have a medicare card or details?" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_hasmedicarecard" renderLabelAsSimplesDialog="blue">
                            <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                                  title="Do you currently have a medicare card or details?" required="true" />
                        </form_v3:row>

                        <simples:dialogue id="190" vertical="health" className="hidden" />

                        <div id="medicare-questions-medicarelevysurcharge" class="hidden">
                            <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/medicarelevysurcharge" />
                            <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                            <form_v3:row label="Do you need a policy for Medicare Levy Surcharge?" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_medicarelevysurcharge" renderLabelAsSimplesDialog="blue" helpId="651">
                                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                                      title="Do you need a policy for Medicare Levy Surcharge?" required="true" />
                            </form_v3:row>

                            <simples:dialogue id="196" vertical="health" className="simples_surcharge_dialogue_196 hidden" />

                            <simples:dialogue id="200" vertical="health" className="hidden" />

                            <div id="medicare-questions-internationalstudent" class="hidden">
                                <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/internationalstudent" />
                                <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                                <form_v3:row label="Are you on a student Visa?" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_internationalstudent" renderLabelAsSimplesDialog="blue">
                                    <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                                          title="Are you on a student Visa?" required="true" />
                                </form_v3:row>

                                <simples:dialogue id="198" vertical="health" className="simples_nomccard_dialogue_198 hidden" />

                                <simples:dialogue id="199" vertical="health" className="simples_nomccard_dialogue_199 hidden" />
                            </div>
                        </div>

                        <div id="medicare-questions-isreciprocalorinterim" class="hidden">
                            <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/isreciprocalorinterim" />
                            <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                            <form_v3:row label="Can I confirm what it says on the top left-hand corner of your Medicare card?<br><span class='black'>For more info on the different Medicare cards:</span><br><a href='https://ctm.livepro.com.au/goto/medicare' target='_blank'>https://ctm.livepro.com.au/goto/medicare</a>" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_isreciprocalorinterim" renderLabelAsSimplesDialog="blue" helpId="650">
                                <field_v2:array_radio items="I=Interim,R=Reciprocal/Unsure" style="group" xpath="${fieldXpath}"
                                                      title="Is Interim or Reciprocal/Unsure?" required="true" />
                            </form_v3:row>

                            <div id="medicare-questions-medicarelevysurchargereci" class="hidden">
                                <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/medicarelevysurchargereci" />
                                <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                                <form_v3:row label="Do you need a policy to avoid paying the Medicare Levy Surcharge?" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_medicarelevysurchargereci" renderLabelAsSimplesDialog="blue" helpId="651">
                                    <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                                          title="Do you need a policy for Medicare Levy Surcharge? (for reciprocal)" required="true" />
                                </form_v3:row>

                                <simples:dialogue id="196" vertical="health" className=" simples_reciprocal_dialogue_196 hidden" />

                                <simples:dialogue id="200" vertical="health" className="hidden" />

                                <div id="medicare-questions-internationalstudentreci" class="hidden">
                                    <c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/situation/internationalstudentreci" />
                                    <c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}_wrapper" />
                                    <form_v3:row label="Are you on a student Visa?" fieldXpath="${fieldXpath}" id="${fieldXpathName}" className="health_situation_medicare_internationalstudentreci" renderLabelAsSimplesDialog="blue">
                                        <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}"
                                                              title="Are you on a student Visa? for reciprocal" required="true" />
                                    </form_v3:row>

                                    <simples:dialogue id="198" vertical="health" className=" simples_reciprocal_dialogue_198 hidden" />

                                    <simples:dialogue id="199" vertical="health" className=" simples_reciprocal_dialogue_199 hidden" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </c:if>

            <%--
            Please note the purpose of this question is to capture if the user currently has any form of private health cover ('Y' == (Private Hospital || Extras Only), 'N'= (None))
            this is done for marketing purposes and so that the information can be passed on to the new provider.

            unfortunatly this field is mislabeled and does not map to the field with the same label in the v4 journey
            --%>

            <c:set var="fieldXpath" value="${xpath}/primary/cover" />
            <form_v3:row label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover" renderLabelAsSimplesDialog="blue">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="health/application/primary/cover/type" />
            <form_v3:row label="What type of cover do you currently hold?" fieldXpath="${fieldXpath}" id="health-current-cover-primary" className="health-your_details-opt-group text-danger" renderLabelAsSimplesDialog="blue">
                <field_v2:array_radio items="C=Hospital & Extras,H=Hospital Only,E=Extras Only" style="group" xpath="${fieldXpath}" title="your current health cover" required="true" id="${name}_health_current_cover" className="loading"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/healthCoverLoading" />
            <form_v3:row label="Have you had continuous Hospital cover for the last 10 years/since 1st July of turning 31?" fieldXpath="${fieldXpath}" id="health-continuous-cover-primary" className="health-your_details-opt-group text-danger"  helpId="239" additionalHelpAttributes="data-content-replace='{{year}},${continuousCoverYear}'" renderLabelAsSimplesDialog="red">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/healthEverHeld" />
            <form_v3:row label="Have you ever held Hospital cover?" fieldXpath="${fieldXpath}" id="health-ever-held-cover-primary" className="health-your_details-opt-group text-danger" renderLabelAsSimplesDialog="blue">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your previous health cover" required="true" id="${name}_health_ever_held_cover" className="loading"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/previousFundName" />
			<form_v3:row fieldXpath="${fieldXpath}" label="Your Previous Hospital Fund" id="clientPreviousFund" className="hidden" renderLabelAsSimplesDialog="true">
				<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your previous health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" className="combobox" placeHolder="Start typing to search or select from list" requiredErrorMessage="No provider selected."/>
			</form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/fundHistory" />
            <form_v3:row fieldXpath="${fieldXpath}" label="Based on your answers it looks like you may be affected by the Government Lifetime Health Cover loading, please enter the approximate date ranges you have held <span class='text-bold'>private hospital</span> cover so we can estimate the impact on your premiums." id="health-primary-fund-history" className="changes-premium text-danger hidden" renderLabelAsSimplesDialog="true">
                <field_v2:coverage_dates_input xpath="${fieldXpath}" footerText="Based on your answers, you may be affected by LHC. The LHC amount will be shown in the premium on the next page, if applicable." />
            </form_v3:row>
            <%-- I don't know my LHC history - apply full LHC --%>
            <div id="primaryLhcDatesUnsureApplyFullLHC" class="applyFullLHC hidden">
                <c:set var="fieldXpath" value="${xpath}/primary/fundHistory/dates/unsure" />
                <form_v3:row fieldXpath="${fieldXpath}">
                    <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I don&apos;t know the date ranges for the periods that I have held private hospital insurance in the past" label="I don&apos;t know my date ranges" required="false" helpId="586" />
                    <div class="applyFullLHCAdditionalText matchCheckboxLabelStyles hidden">Full applicable LHC will be applied to your policy until your new fund receives a transfer certificate from your previous fund, it will then be adjusted from the start date of your policy and you will be credited any amount you have overpaid.</div>
                </form_v3:row>
            </div>

            <c:set var="fieldXpath" value="${xpath}/primary/abd" />
            <form_v3:row label="Do you currently hold a policy which has an Age Based Discount?" fieldXpath="${fieldXpath}" id="primary_abd" className="lhcRebateCalcTrigger primary_currentPolicyAbd-group hidden" renderLabelAsSimplesDialog="red">
	            <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Do you currently hold a policy which has an Age Based Discount?" required="true" className="health-cover_detailsAbd" id="primary_abd_health_cover" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/primary/abdPolicyStart" />
            <form_v3:row fieldXpath="${fieldXpath}" label="What was the policy start date?" id="primary_abd_start_date" className="changes-premium hidden" renderLabelAsSimplesDialog="blue">
                <field_v2:calendar xpath="${fieldXpath}" required="true" title="- What was the policy start date?" className="health-payment_details-start" mode="separated" disableRowHack="${true}" showCalendarOnXS="${true}" />
            </form_v3:row>

            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${xpath}/primary/lhc" />
                <form_v2:row label="Applicant's LHC" fieldXpath="${fieldXpath}" helpId="287">
                    <health_v3:even_lhc_value_message />
                    <field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
                </form_v2:row>
            </c:if>

        </form_v3:fieldset>

        <%--dynamic script--%>
        <%--if customer has cover--%>
        <simples:dialogue id="53" vertical="health" className="simples-dialogue-primary-current-cover hidden" />

        <form_v3:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">

            <c:set var="fieldXpath" value="${xpath}/partner/dob" />
            <form_v3:row label="What is your Partner&apos;s Date of Birth?" fieldXpath="${fieldXpath}" renderLabelAsSimplesDialog="blue">
                <field_v2:person_dob xpath="${fieldXpath}" title="partner's" required="true" ageMin="16" ageMax="120" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/cover" />
            <form_v3:row label="Does your partner currently hold private health insurance?" fieldXpath="${fieldXpath}"  id="${name}_partnerCover" renderLabelAsSimplesDialog="blue">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="health/application/partner/cover/type" />
            <form_v3:row label="What type of cover does your partner currently hold?" fieldXpath="${fieldXpath}" id="health-current-cover-partner" className="health-your_details-opt-group text-danger" renderLabelAsSimplesDialog="blue">
                <field_v2:array_radio items="C=Hospital & Extras,H=Hospital Only,E=Extras Only" style="group" xpath="${fieldXpath}" title="your partners current health cover" required="true" id="${name}_health_current_cover" className="loading"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/healthCoverLoading" />
            <form_v3:row label="Has your partner had continuous Hospital cover for the last 10 years/since 1st July of turning 31?" fieldXpath="${fieldXpath}" id="health-continuous-cover-partner" className="health-your_details-opt-group" helpId="239" additionalHelpAttributes="data-content-replace='{{year}},${continuousCoverYear}'" renderLabelAsSimplesDialog="red">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/healthEverHeld" />
            <form_v3:row label="Has your partner ever held Hospital cover?" fieldXpath="${fieldXpath}" id="health-ever-held-cover-partner" className="health-your_details-opt-group text-danger" renderLabelAsSimplesDialog="blue">
                <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your partner's previous health cover" required="true" id="${name}_health_ever_held_cover" className="loading"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/previousFundName" />
			<form_v3:row fieldXpath="${fieldXpath}" label="Partner's Previous Hospital Fund" id="partnerPreviousFund" className="hidden" renderLabelAsSimplesDialog="true">
				<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your partner's health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" className="combobox" placeHolder="Start typing to search or select from list" requiredErrorMessage="No provider selected."/>
			</form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/fundHistory" />
            <form_v3:row fieldXpath="${fieldXpath}" label="Based on your answers it looks like your partner may be affected by the Government Lifetime Health Cover loading, please enter the approximate date ranges your partner has held <span class='text-bold'>private hospital</span> cover so we can estimate the impact on your premiums." id="health-partner-fund-history" className="changes-premium hidden" renderLabelAsSimplesDialog="blue">
                <field_v2:coverage_dates_input xpath="${fieldXpath}" footerText="Based on your answers, your partner may be affected by LHC. The LHC amount will be shown in the premium on the next page, if applicable." />
            </form_v3:row>

            <%-- I don't know my LHC history - apply full LHC --%>
            <div id="partnerLhcDatesUnsureApplyFullLHC" class="applyFullLHC hidden">
                <c:set var="fieldXpath" value="${xpath}/partner/fundHistory/dates/unsure" />
                <form_v3:row fieldXpath="${fieldXpath}">
                    <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I don&apos;t know the date ranges for the periods that my partner has held private hospital insurance in the past" label="I don&apos;t know my partner&apos;s date ranges" required="false" helpId="586" />
                    <div class="applyFullLHCAdditionalText matchCheckboxLabelStyles hidden">Full applicable LHC will be applied to your policy until your new fund receives a transfer certificate from your partner&apos;s previous fund, it will then be adjusted from the start date of your policy and you will be credited any amount you have overpaid.</div>
                </form_v3:row>
            </div>

            <c:set var="fieldXpath" value="${xpath}/partner/abd" />
            <form_v3:row label="Does your partner currently hold a policy which has an Age Based Discount?" fieldXpath="${fieldXpath}" id="partner_abd" className="lhcRebateCalcTrigger partner_currentPolicyAbd-group hidden" renderLabelAsSimplesDialog="red">
              <field_v2:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="- Does your partner currently hold a policy which has an Age Based Discount?" required="true" className="health-cover_detailsAbdPartner" id="partner_abd_health_cover" />
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/partner/abdPolicyStart" />
            <form_v3:row fieldXpath="${fieldXpath}" label="What was the policy start date?" id="partner_abd_start_date" className="changes-premium hidden" renderLabelAsSimplesDialog="blue">
                <field_v2:calendar xpath="${fieldXpath}" required="true" title="- What was the policy start date?" className="health-payment_details-start" mode="separated" disableRowHack="${true}" showCalendarOnXS="${true}" />
            </form_v3:row>

            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${xpath}/partner/lhc" />
                <form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}">
                    <health_v3:even_lhc_value_message />
                    <field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
                </form_v2:row>
            </c:if>
        </form_v3:fieldset>

        <form_v3:fieldset id="abd_filter" legend="ABD Filtering" className="hidden">
            <div class="hidden abdFilterModalContent">
                <div class="simples-dialogue abd-filter-dialogue">
                    <p class="blue">Private Health Insurers can offer discounts on hospital cover for people under 30. The discount applies from the age you were when you purchased your policy. If you switch policies you can keep your discount as long as you switch to a policy that allows you to retain your age-based discount.</p>
                    <p class='red'>If you choose to retain your discount you will remain eligible. However, if you move to a policy that does not have a retained age based discount you will lose the discount you are currently eligible for.</p>
                    <div style="display: flex;">
                        <p class="blue">With that in mind, when comparing policies, do you want us to only look at policies that allow you to retain your age-based discount.</p>
                        <div class="btn-group btn-group-justified" data-toggle="radio">
                            <label class="btn btn-form-inverse">
                                <input type="radio" name="health_healthCover_filter_abd_final" id="health_healthCover_filter_abd_final_Y" value="Y" data-msg-required="Please choose - Choose whether you " required="required" aria-required="true">
                                Yes
                            </label>
                            <label class="btn btn-form-inverse">
                                <input type="radio" name="health_healthCover_filter_abd_final" id="health_healthCover_filter_abd_final_N" value="N" data-msg-required="Please choose - Choose whether you " required="required" aria-required="true">
                                No
                            </label>
                        </div>
                    </div>
                    <p class="hidden filter-no-response-scripting">I’ve noted that down, so we will have a look at all the options on our panel.</p>
                </div>
            </div>

            <simples:dialogue id="209" vertical="health" />
            <c:set var="fieldXpath" value="${xpath}/filter/abd" />
            <form_v3:row label="When comparing policies, do you want us to only look at policies that allow you to retain your Age-Based discount?" fieldXpath="${fieldXpath}" id="abd_filter" className="no-label">
                <field_v2:array_radio xpath="${fieldXpath}" required="true" title="- Choose whether you " items="Y=Yes,N=No,U=Unsure" style="group" />
            </form_v3:row>
            <simples:dialogue id="138" className="hidden" vertical="health" mandatory="true" />
        </form_v3:fieldset>

        <%--dynamic script--%>
        <%--if customer has cover--%>
        <simples:dialogue id="191" vertical="health" className="simples-dialogue-partner-current-cover hidden" />

        <simples:dialogue id="26" vertical="health" mandatory="true" />

        <form_v3:fieldset id="australian-government-rebate" legend="Australian Government Rebate" className="no-label">

            <simples:dialogue id="210" vertical="health" />

            <c:set var="mandatory" value=""/>

            <c:if test="${callCentre}">
                <c:set var="mandatory" value=" text-danger"/>
            </c:if>

            <c:if test="${callCentre}">
                <c:set var="fieldXpath" value="${xpath}/incomeBasedOn" />
                <form_v3:row label="I wish to calculate my rebate based on" fieldXpath="${fieldXpath}" helpId="288" className="health_cover_details_incomeBasedOn no-label" id="${name}_incomeBase">
                    <field_v2:array_radio items="S=Single income,H=Household" style="group" xpath="${fieldXpath}" title="income based on" required="true"  />
                </form_v3:row>
            </c:if>

            <c:set var="fieldXpath" value="${xpath}/dependants" />
            <form_v3:row label="This is based on your taxable income and number of dependants, so can I confirm, how many dependent children do you have?" fieldXpath="${fieldXpath}" helpId="241" className="health_cover_details_dependants ${mandatory} no-label">
                <field_v2:count_select xpath="${fieldXpath}" max="12" min="1" title="number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
            </form_v3:row>

            <c:set var="fieldXpath" value="${xpath}/income" />
            <form_v3:row label="Default income copy" fieldXpath="${fieldXpath}" id="${name}_tier" className="${mandatory} " renderLabelAsSimplesDialog="red">
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

            <form_v3:row label="&nbsp;" fieldXpath="${fieldXpath}" helpId="240" className="health_cover_details_rebate health_cover_details_rebate_chkbx">
                <field_v2:checkbox xpath="${fieldXpath}/dontApplyRebate" value="N" id="${name}_health_cover_rebate_dontApplyRebate" title="Tick here if your customer doesn't want to claim the Government Rebate." required="false" label="Tick here if your customer doesn't want to claim the Government Rebate." className="rebate btn-group-wrap" customAttribute=" data-attach='true'"/>
            </form_v3:row>

        </form_v3:fieldset>

        <simples:dialogue id="37" vertical="health" mandatory="true" className="hidden" />

        <%--dynamic scripts--%>
        <simples:dialogue id="143" vertical="health" mandatory="true" className=" simples_dialogue_medicare_143 hidden"/>
        <simples:dialogue id="144" vertical="health" mandatory="true" className="hidden"/>


        <%-- Compliance Copy --%>
        <simples:dialogue id="62" vertical="health" className="hidden" />
        <simples:dialogue id="226" vertical="health" className="hidden" />
        <simples:dialogue id="212" vertical="health" className="hidden" />
        <simples:dialogue id="213" vertical="health" className="hidden" />
        <simples:dialogue id="214" vertical="health" className="hidden" />
        <simples:dialogue id="215" vertical="health" className="hidden" />


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
