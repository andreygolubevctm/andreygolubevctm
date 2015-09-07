<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="How customer heard about us"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="phoneService" class="com.ctm.services.PhoneService" scope="application" />
<jsp:useBean id="quoteService" class="com.ctm.services.QuoteService" scope="application" />

<%@ attribute name="vertical"	required="true"	 	rtexprvalue="true" 	description="Vertical to associate this tracking with e.g. health" %>
<%@ attribute name="required" 	required="false"	rtexprvalue="true"	description="Is this field required?" %>
<%@ attribute name="className" 	required="false"	rtexprvalue="true"	description="Additional css class" %>
<%@ attribute name="title" 		required="false"	rtexprvalue="true"	description="Title for the form element" %>

<c:set var="xpath" value="${vertical}/tracking" />

<%--
	Callcentre-only section
--%>
<c:if test="${callCentre}">
	<c:if test="${empty required}"><c:set var="required" value="${false}" /></c:if>

	<%-- If operator has an extension, get their phone call details. --%>
	<%-- NOTE: This is not ideal, as the phone details should be available from session and not specially pinged at this point. --%>
	<c:if test="${not empty authenticatedData['login/user/extension']}">
		<c:catch>
			<c:set var="callInfo" value="${phoneService.saveCallInfoForTransaction(pageSettings, authenticatedData['login/user/extension'], data.current.transactionId,xpath)}" />
			<c:if test="${callInfo != null && callInfo.getCallId() != '0'}">
				<c:set var="callId" value="${callInfo.getCallId()}" />
				<c:set var="direction" value="${callInfo.getDirection()}" />
				<c:set var="customerPhoneNo" value="${callInfo.getCustomerPhoneNo()}" />
				<c:if test='${!callInfo.getVdns().isEmpty() && callInfo.getVdns().get(0) != null && !callInfo.getVdns().get(0).equals("")}'>
					<c:set var="vdn" value="${callInfo.getVdns().get(0)}" />
				</c:if>
			</c:if>
		</c:catch>
	</c:if>

	<%-- add input for call centre when it is inbound call --%>
	<c:set var="fieldXpath" value="${xpath}/vdnInput" />
	<form_new:row label="VDN" fieldXpath="${fieldXpath}" className="hidden" helpId="540">
		<field:input_numeric xpath="${fieldXpath}" minValue="1000" maxValue="9999" title="Inbound VDN" required="true" id="${go:nameFromXpath(fieldXpath)}" maxLength="4" validationMessage="Please enter VDN correctly (4 digits)" className="form-control" />
		<span class="fieldrow_legend" id="${name}_emailMessage">Enter "1000" if no VDN is displayed</span>
	</form_new:row>

	<field:hidden xpath="${xpath}/callId" defaultValue="${callId}" />
	<field:hidden xpath="${xpath}/direction" defaultValue="${direction}" />
	<field:hidden xpath="${xpath}/customerPhoneNo" defaultValue="${customerPhoneNo}" />
	<field:hidden xpath="${xpath}/VDN" defaultValue="${vdn}" />
</c:if>
