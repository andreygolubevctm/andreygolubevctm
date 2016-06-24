<%@ tag description="Utilities Terms and Conditions"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_v2:fieldset legend="Next Steps">

    <div>
        <p>If you apply for an energy plan, Thought World (our trusted energy partner) will contact you to discuss your energy needs and finalise your application.</p>
    </div>


    <field_v1:hidden xpath="${xpath}/hidden/productId" />
    <field_v1:hidden xpath="${xpath}/hidden/retailerName" />
    <field_v1:hidden xpath="${xpath}/hidden/planName" />
    <field_v1:hidden xpath="${xpath}/receiveInfo" defaultValue="N" />

</form_v2:fieldset>