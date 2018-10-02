<%@ tag description="The Health Application template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<%-- HTML --%>
<div id="${name}" class="health_application">
    <form_v4:fieldset legend="Your Details">

        <health_v4_application:person_details xpath="${xpath}/primary" title="Your" id="primary" />
        <health_v4_application:contact_details xpath="${pageSettings.getVerticalCode()}/application" />

        <health_v4_application_primary:currently_own_any_cover xpath="${xpath}" />
        <health_v4_application_primary:ever_owned_hospital_cover xpath="${xpath}" variant="PrivateHospital1" />

        <c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
        <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
        <div id="${name}">

            <div id="yourpreviousfund" legend="Previous Fund Details" class="health-previous_fund">

                <c:set var="fieldXpath" value="${xpath}/primary/fundName" />
                <form_v4:row fieldXpath="${fieldXpath}" label="Your Current Health Fund" id="clientFund" className="changes-premium">
                    <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="your health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
                </form_v4:row>

                    <%-- Optional Membership ID's --%>
                <div id="clientMemberID" class="membership">
                    <c:set var="fieldXpath" value="${xpath}/primary/memberID" />
                    <form_v4:row fieldXpath="${fieldXpath}" label="Membership Number" className="clientMemberID" smRowOverride="3">
                        <field_v2:input xpath="${fieldXpath}" title="your member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${false}" placeHolder="Membership No." maxlength="10" />
                    </form_v4:row>

                    <c:set var="fieldXpath" value="${xpath}/primary/authority" />
                    <form_v4:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden">
                        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I authorise <span>the fund</span> to contact my previous fund to obtain a clearance certificate" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " helpId="522" />
                    </form_v4:row>
                </div>
            </div>
        </div>

        <%-- reset xpath to the same as used on About You page --%>
        <c:set var="xpath" 			value="${pageSettings.getVerticalCode()}/healthCover" />
        <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
        <health_v4_application_primary:continuous_hospital_cover xpath="${xpath}" />

        <%-- reset xpath back to application --%>
        <c:set var="xpath" 			value="${pageSettings.getVerticalCode()}/application" />
        <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
        <health_v4_application_primary:ever_owned_hospital_cover xpath="${xpath}" variant="PrivateHospital2" />

        <c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
        <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
        <div>
            <div>
                <c:set var="fieldXpath" value="${xpath}/primary/fundHistory" />
                <form_v4:row fieldXpath="${fieldXpath}" label="Based on your answers it looks like you may be affected by the Government Lifetime Health Cover loading, please enter the approximate date ranges you have held <span class='text-bold'>private hospital</span> cover so we can estimate the impact on your premiums." id="primaryFundHistory" className="changes-premium hidden-toggle" rowContentClass="row">
                    <field_v2:coverage_dates_input xpath="${fieldXpath}" footerText="Based on your answers, you may be affected by LHC. The LHC amount will be shown in the premium on the next page, if applicable." />
                </form_v4:row>
                <%-- I don't know my LHC history - apply full LHC --%>
                <div id="primaryLhcDatesUnsureApplyFullLHC" class="applyFullLHC">
                    <c:set var="fieldXpath" value="${xpath}/primary/fundHistory/dates/unsure" />
                    <form_v4:row fieldXpath="${fieldXpath}">
                        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I don&apos;t know the date ranges for the periods that I have held private hospital insurance in the past" label="I don&apos;t know my date ranges" required="false" helpId="586" />
                        <div class="applyFullLHCAdditionalText matchCheckboxLabelStyles hidden">Full applicable LHC will be applied to your policy until your new fund receives a transfer certificate from your previous fund, it will then be adjusted from the start date of your policy and you will be credited any amount you have overpaid.</div>
                    </form_v4:row>
                </div>
            </div>
        </div>

        <%-- reset xpath to payment --%>
        <c:set var="xpath" value="${pageSettings.getVerticalCode()}/payment" />
        <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
        <div class="health-payment ${className}" id="${id}">
            <health_v4_application:medicare_details xpath="${xpath}/medicare" />
        </div>
    </form_v4:fieldset>
</div>