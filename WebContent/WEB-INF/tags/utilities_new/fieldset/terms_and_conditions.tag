<%@ tag description="Utilities Terms and Conditions"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Terms and Conditions">

    <c:set var="termsText">
        <p>To process the offer and apply the discounts to your account you should read and should ensure you understand and agree to the following information:</p>
        <div id="terms-text-container"></div>
    </c:set>

    <field_new:checkbox xpath="${xpath}/termsAndConditions" required="true" title="${termsText}" label="true" value="Y" errorMsg="Please agree to the terms and conditions." />

    <field:hidden xpath="${xpath}/hidden/productId" />
    <field:hidden xpath="${xpath}/hidden/retailerName" />
    <field:hidden xpath="${xpath}/hidden/planName" />
    <field:hidden xpath="${xpath}/receiveInfo" defaultValue="N" />

</form_new:fieldset>

<core:js_template id="terms-text-template">
    <p>You have the right to a 10 day cooling off period (COP). This cooling off period begins on the date your agreement commences. You may cancel your agreement by contacting us at any time during the COP without penalty. Your Agreement commences with {{= data.retailerName }} when you give your verbal acceptance and receive the Confirmation Pack, which will include the full terms and conditions of the Energy Agreement.</p>
    <p>{{= data.retailerName }} will send you a Welcome Pack containing written confirmation of the energy offer accepted, the Energy Agreement and Customer Charter. You may terminate the agreement at any time by contacting {{= data.retailerName }}. You may be liable for termination fees with your existing provider if you are under contract with them.</p>
    <p>By accepting the Energy Offer from {{= data.retailerName }}, you authorise us to create a new account and collect, maintain, use and disclose personal information as set out in the Privacy Statement detailed in the Energy Agreement we will send you. You give your explicit informed consent that your tariff and or discount can change from time to time, in line with the relevant code or guideline, including government price increases. If the tariff and or discount do change you will be notified on your next bill or as required by the code or guideline for your area. You give your explicit informed consent that we may bill you quarterly for electricity and bi-monthly for gas unless you have chosen a monthly billed product.</p>
    <p>You accept the terms and conditions mentioned above and you consent to entering into an agreement with {{= data.retailerName }} on those terms and conditions. You understand and accept that you are accepting an agreement for: {{= data.planName }}</p>
</core:js_template>