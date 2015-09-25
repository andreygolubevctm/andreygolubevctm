<%@ tag description="Used to control the call centre phone recording for compliance when recording sensitive data"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- Main content --%>
<health:privacy xpath="${xpath}/compliance" make_private="${callCentre}">
	<health:credit_card_details xpath="${xpath}" />
	<health:bank_details xpath="${xpath}/bank" />
	<field:hidden xpath="${xpath}/policyDate" className="health_details-policyDate" />
</health:privacy>

<simples:dialogue id="29" vertical="health" mandatory="true" />
<simples:dialogue id="40" vertical="health" mandatory="true" className="hidden new-quote-only" />