<%@ tag description="Utilities Preferences Form (Enquire)"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_v2:fieldset legend="Preferences" className="preferences" postLegend="Show results that match to your chosen preferences only. Choose your 'must-haves' below.">
    <div class="has-icons">
        <form_v3:row label="" className="account-fees-container">
            <field_v2:checkbox xpath="${xpath}/preferNoContract"  value="Y" title="<span>No lock in contracts or exit fees<br><br></span>" required="false" label="true"  />
        </form_v3:row>
        <form_v3:row label="" className="account-management-container">
            <field_v2:checkbox xpath="${xpath}/preferEBilling" value="Y" title="<span>Online website/portal for<br /> managing your account</span>" required="false" label="true"  />
        </form_v3:row>
        <form_v3:row label="" className="renewable-energy-container">
            <field_v2:checkbox xpath="${xpath}/preferRenewableEnergy" value="Y" title="<span>Green or renewable energy plans<br><br></span>" required="false" label="true"  />
        </form_v3:row>
    </div>
</form_v2:fieldset>
