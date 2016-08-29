<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="credit card group" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<form_v3:row label="Credit Card Expiry" isNestedStyleGroup="${true}">
    <c:set var="fieldXpath" value="${xpath}/expiry" />
    <form_v3:row fieldXpath="${fieldXpath}_cardExpiryMonth" label="Credit Card Expiry" id="${name}_expiry" className="clearfix health_credit-card-details_expiry_group" smRowOverride="12" isNestedField="${true}" hideHelpIconCol="${true}">
        <field_v1:cards_expiry rule="ccExp" xpath="${fieldXpath}" title="Credit card expiry date" required="true" className="health-credit_card_details-expiry sessioncamexclude" maxYears="7" disableErrorContainer="${true}" />
    </form_v3:row>

    <c:set var="fieldXpath" value="${xpath}/ccv" />
    <form_v3:row fieldXpath="${fieldXpath}" label="CCV number" helpId="402" className="clearfix health_credit-card-details_ccv" smRowOverride="7" isNestedField="${true}" hideHelpIconCol="${true}">
        <field_v2:creditcard_ccv xpath="${fieldXpath}" required="true" placeHolder="CCV" disableErrorContainer="${true}"  />
    </form_v3:row>
</form_v3:row>