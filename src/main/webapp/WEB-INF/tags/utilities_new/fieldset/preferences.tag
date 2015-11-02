<%@ tag description="Utilities Preferences Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Preferences">
    <c:set var="fieldXPath" value="${xpath}/solarPanels" />
    <form_new:row label="Would you like us to include conditional discounts in our comparison ranking?" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you would like to view conditional discounts." />
    </form_new:row>
    <form_new:row label="" className="account-fees-container">
        <field_new:checkbox xpath="${xpath}/displayAccountFees" value="Y" title="No Fixed Term / Exit Fees" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="payment-options-container">
        <field_new:checkbox xpath="${xpath}/displayPaymentOptions" value="Y" title="Bill smoothing / installments" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="account-management-container">
        <field_new:checkbox xpath="${xpath}/displayAccountManagement" value="Y" title="Online account management" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="monitoring-tools-container">
        <field_new:checkbox xpath="${xpath}/displayMonitoringTools" value="Y" title="Energy monitoring tools" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="membership-rewards-container">
        <field_new:checkbox xpath="${xpath}/displayMembershipRewards" value="Y" title="Membership reward programs" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="renewable-energy-container">
        <field_new:checkbox xpath="${xpath}/displayRenewableEnergy" value="Y" title="Renewable energy plans" required="false" label="true"  />
    </form_new:row>
</form_new:fieldset>
