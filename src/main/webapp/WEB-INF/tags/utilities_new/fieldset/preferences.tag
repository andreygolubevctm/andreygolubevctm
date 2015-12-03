<%@ tag description="Utilities Preferences Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Preferences">
    <p>Show results that match to your chosen preferences only. Choose your "must-haves" from the list below. Leave unticked if optional.</p>
    <form_new:row label="" className="account-fees-container">
        <field_new:checkbox xpath="${xpath}/preferNoContract" value="Y" title="No Fixed Term or Exit Fees to avoid contract termination fees" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="account-management-container">
        <field_new:checkbox xpath="${xpath}/preferEBilling" value="Y" title="Online account management to access your account/pay bills" required="false" label="true"  />
    </form_new:row>
    <form_new:row label="" className="renewable-energy-container">
        <field_new:checkbox xpath="${xpath}/preferRenewableEnergy" value="Y" title=" Green or renewable energy plans" required="false" label="true"  />
    </form_new:row>
</form_new:fieldset>
