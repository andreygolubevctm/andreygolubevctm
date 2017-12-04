<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-bank_details ${name}-selection">

    <health_v4_payment:bank_account_details xpath="${xpath}" />

    <c:set var="fieldXpath" value="${xpath}/claims" />
    <form_v4:row fieldXpath="${fieldXpath}" label="Would you like your claim refunds paid into the same account?" className="health_bank-details_claims_group">
        <field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="would you like your claim refunds paid into the same account" required="true" className="health-bank_details-claims" id="${name}_claims" additionalAttributes="data-attach='true'"/>
    </form_v4:row>


</div>

<div id="${name}_claim-selection" class="health-bank_claim_details">
    <h3>Please nominate a bank account for future claim payments</h3>
    <health_v4_payment:bank_account_details xpath="${xpath}/claim" />
</div>
