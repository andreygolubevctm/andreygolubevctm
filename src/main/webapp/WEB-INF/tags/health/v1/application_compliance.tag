<%@ tag description="Used to control the call centre phone recording for compliance when recording sensitive data"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- Main content --%>

<health_v1:privacy xpath="${xpath}/compliance" make_private="${callCentre}">
	<health_v1:credit_card_details xpath="${xpath}" />
	<health_v1:bank_details xpath="${xpath}/bank" />
	<field_v1:hidden xpath="${xpath}/policyDate" className="health_details-policyDate" />
</health_v1:privacy>

<simples:dialogue id="236" vertical="health" mandatory="true" />
<health_v1:payment_day_details xpath="${xpath}/bank" />
<health_v1:payment_day_details xpath="${xpath}/credit" />

<simples:dialogue id="29" vertical="health" mandatory="true" />
<simples:dialogue id="38" vertical="health" mandatory="true" />
<simples:dialogue id="40" vertical="health" mandatory="true" />
