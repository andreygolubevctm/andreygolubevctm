<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<form_v4:fieldset legend="Your Partner&apos;s Details" id="partnerContainer">
    <div id="${name}" class="health_application">
        <health_v4_application:person_details xpath="${xpath}/partner" title="Your Partner's" id="partner" />
    </div>

    <health_v4_application_partner:currently_own_any_cover xpath="${xpath}" />

    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
    <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
    <div id="${name}">
        <div id="partnerpreviousfund" legend="Previous Fund Details" class="health-previous_fund">
            <c:set var="fieldXpath" value="${xpath}/partner/fundName" />
            <form_v4:row fieldXpath="${fieldXpath}" label="Partner&apos;s Current Health Fund" id="partnerFund" className="changes-premium">
                <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="partner&apos;s health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
            </form_v4:row>

            <div id="partnerMemberID" class="membership">
                <c:set var="fieldXpath" value="${xpath}/partner/memberID" />
                <form_v4:row fieldXpath="${fieldXpath}" label="Membership Number" className="partnerMemberID" smRowOverride="3">
                    <field_v2:input xpath="${fieldXpath}" title="partner&apos;s member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" placeHolder="Membership No." maxlength="10" />
                </form_v4:row>

                <c:set var="fieldXpath" value="${xpath}/partner/authority" />
                <form_v4:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden">
                    <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="My partner authorises <span>the fund</span> to contact their previous fund to obtain a clearance certificate" label="My partner authorises <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " helpId="522" />
                </form_v4:row>
            </div>
        </div>
    </div>

    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
    <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

    <health_v4_application_partner:ever_owned_hospital_cover xpath="${xpath}" />
    <health_v4_application_partner:continuous_hospital_cover xpath="${xpath}" />

    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
    <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

    <health_v4_application_partner:ever_owned_hospital_cover xpath="${xpath}" />

    <%-- HTML --%>
    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
    <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
    <div>
        <div>
            <c:set var="fieldXpath" value="${xpath}/partner/fundHistory" />
            <form_v4:row fieldXpath="${fieldXpath}" label="Based on your answers it looks like your partner may be affected by the Government Lifetime Health Cover loading, please enter the approximate date ranges your partner has held <span class='text-bold'>private hospital</span> cover so we can estimate the impact on your premiums." id="partnerFundHistory" className="changes-premium hidden-toggle" rowContentClass="row">
                <field_v2:coverage_dates_input xpath="${fieldXpath}" footerText="Based on your answers, your partner may be affected by LHC. The LHC amount will be shown in the premium on the next page, if applicable." />
            </form_v4:row>

            <%-- I don't know my LHC history - apply full LHC --%>
            <div id="partnerLhcDatesUnsureApplyFullLHC" class="applyFullLHC">
                <c:set var="fieldXpath" value="${xpath}/partner/fundHistory/dates/unsure" />
                <form_v4:row fieldXpath="${fieldXpath}">
                    <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I don&apos;t know the date ranges for the periods that my partner has held private hospital insurance in the past" label="I don&apos;t know my partner&apos;s date ranges" required="false" helpId="586" />
                    <div class="applyFullLHCAdditionalText hidden">Full applicable LHC will be applied to your policy until your new fund receives a transfer certificate from your partner&apos;s previous fund. It will then be adjusted from the start date of your policy and you will be credited any amount you have overpaid.</div>
                </form_v4:row>
            </div>
	    </div>
	</div>

</form_v4:fieldset>