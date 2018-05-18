<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<form_v4:fieldset legend="Your Partner's Details" id="partnerContainer">
    <div id="${name}" class="health_application">
        <health_v4_application:person_details xpath="${xpath}/partner" title="Your Partner's" id="partner" />
    </div>

    <health_v4_insuranceprefs:partner_cover_ever_owned xpath="${xpath}" />

    <%-- HTML --%>
    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
    <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

    <c:set var="fieldXpath" value="${xpath}/partner/fundHistory" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Tell us the periods in the past where your partner has held private hospital cover, and we will calculate any Lifetime Health Cover that may that may be applied to your premium" id="partnerFundHistory" className="changes-premium" rowContentClass="row">
        <field_v1:coverage_dates_input xpath="${fieldXpath}" />
    </form_v4:row>

    <div id="${name}">
        <div id="partnerpreviousfund" legend="Previous Fund Details" class="health-previous_fund">
            <c:set var="fieldXpath" value="${xpath}/partner/fundName" />
            <form_v4:row fieldXpath="${fieldXpath}" label="Partner's Current Health Fund" id="partnerFund" className="changes-premium">
                <field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="partner's health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
            </form_v4:row>

            <div id="partnerMemberID" class="membership">
                <c:set var="fieldXpath" value="${xpath}/partner/memberID" />
                <form_v4:row fieldXpath="${fieldXpath}" label="Membership Number" className="partnerMemberID" smRowOverride="3">
                    <field_v2:input xpath="${fieldXpath}" title="partner's member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" placeHolder="Membership No." maxlength="10" />
                </form_v4:row>

                <c:set var="fieldXpath" value="${xpath}/partner/authority" />
                <form_v4:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden">
                    <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="My partner authorises <span>the fund</span> to contact their previous fund to obtain a clearance certificate" label="My partner authorises <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " helpId="522" />
                </form_v4:row>
            </div>
        </div>
    </div>
</form_v4:fieldset>