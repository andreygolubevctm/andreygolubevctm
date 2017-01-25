<%@ tag description="Used to control the call centre phone recording for compliance when recording sensitive data"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- Main content --%>
<health_v4_payment:privacy xpath="${xpath}/compliance" make_private="${callCentre}">
    <health_v4_payment:credit_card_details xpath="${xpath}" />
    <health_v4_payment:bank_details xpath="${xpath}/bank" />
    <field_v1:hidden xpath="${xpath}/policyDate" className="health_details-policyDate" />
</health_v4_payment:privacy>

<health_v4_payment:payment_day_details xpath="${xpath}/bank" />
<health_v4_payment:payment_day_details xpath="${xpath}/credit" />