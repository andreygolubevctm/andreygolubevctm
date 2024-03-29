<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="How customer heard about us"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.simples.referral_tracking')}" />

<jsp:useBean id="phoneService" class="com.ctm.web.simples.phone.verint.CtiPhoneService" scope="application" />
<jsp:useBean id="quoteService" class="com.ctm.web.core.services.QuoteService" scope="application" />

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
	<c:set var="extension" value="${authenticatedData['login/user/extension']}" />
	<c:if test="${not empty extension}">
		<c:catch var="error">
			<c:set var="callInfo" value="${phoneService.saveCallInfoForTransaction(pageSettings, extension, data.current.transactionId,xpath)}" />
			<c:if test="${callInfo != null && callInfo.getCallId() != '0'}">
				<c:set var="callId" value="${callInfo.getCallId()}" />
				<c:set var="direction" value="${callInfo.getDirection()}" />
				<c:set var="customerPhoneNo" value="${callInfo.getCustomerPhoneNo()}" />
				<c:if test='${!callInfo.getVdns().isEmpty() && callInfo.getVdns().get(0) != null && !callInfo.getVdns().get(0).equals("")}'>
					<c:set var="vdn" value="${callInfo.getVdns().get(0)}" />
				</c:if>
			</c:if>
		</c:catch>
		<c:if test="${error}">
			${logger.warn('Exception calling saveCallInfoForTransaction. {}', log:kv('extension' , extension), error)}
		</c:if>

	</c:if>

	<%-- add input for call centre when it is inbound call --%>
	<c:set var="fieldXpath" value="${xpath}/vdnInput" />
	<form_v2:row label="VDN" fieldXpath="${fieldXpath}" className="hidden" helpId="540">
		<field_v1:input_numeric xpath="${fieldXpath}" minValue="1000" maxValue="9999" title="Inbound VDN" required="true" id="${go:nameFromXpath(fieldXpath)}" maxLength="4" validationMessage="Please enter VDN correctly (4 digits)" className="form-control" />
		<span class="fieldrow_legend" id="${name}_emailMessage">Enter "1000" if no VDN is displayed</span>
	</form_v2:row>

	<field_v1:hidden xpath="${xpath}/callId" defaultValue="${callId}" />
	<field_v1:hidden xpath="${xpath}/direction" defaultValue="${direction}" />
	<field_v1:hidden xpath="${xpath}/customerPhoneNo" defaultValue="${customerPhoneNo}" />
	<field_v1:hidden xpath="${xpath}/VDN" defaultValue="${vdn}" />
</c:if>
