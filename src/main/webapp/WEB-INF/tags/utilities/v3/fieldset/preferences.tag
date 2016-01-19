<%@ tag description="Utilities Preferences Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_v2:fieldset legend="Preferences">
    <p>Show results that match to your chosen preferences only. Choose your "must-haves" from the list below. Leave unticked if optional.</p>
    <form_v3:row label="" className="account-fees-container">
        <field_v2:checkbox xpath="${xpath}/preferNoContract" value="Y" title="No Fixed Term or Exit Fees to avoid contract termination fees" required="false" label="true"  />
    </form_v3:row>
    <form_v3:row label="" className="account-management-container">
        <field_v2:checkbox xpath="${xpath}/preferEBilling" value="Y" title="Online account management to access your account/pay bills" required="false" label="true"  />
    </form_v3:row>
    <form_v3:row label="" className="renewable-energy-container">
        <field_v2:checkbox xpath="${xpath}/preferRenewableEnergy" value="Y" title=" Green or renewable energy plans" required="false" label="true"  />
    </form_v3:row>
</form_v2:fieldset>
