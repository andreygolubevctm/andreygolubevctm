<%@ tag description="Utilities Preferences Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Preferences">
    <p>How would you like to sort your results?</p>
    <c:set var="fieldXPath" value="${xpath}/solarPanels" />
    <form_new:row label="Include discounts in the results page algorithm" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you would like to view conditional discounts." />
    </form_new:row>
    <p>Choose your "must-haves" from the list below. Energy results will match with your chosen preferences.</p>
    <form_new:row label="" className="account-fees-container">
        <field_new:checkbox xpath="${xpath}/preferNoContract" value="Y" title="No Fixed Term or Exit Fees to avoid contract termination penalties" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="payment-options-container">
        <field_new:checkbox xpath="${xpath}/preferPayOntime" value="Y" title="Pay your bill in regular instalments (e.g. monthly) rather than a larger bill every quarter" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="account-management-container">
        <field_new:checkbox xpath="${xpath}/preferEBilling" value="Y" title="Online account management to access your account and pay bills" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="renewable-energy-container">
        <field_new:checkbox xpath="${xpath}/preferRenewableEnergy" value="Y" title=" Green or renewable energy plans" required="false" label="true"  />
    </form_new:row>
</form_new:fieldset>
