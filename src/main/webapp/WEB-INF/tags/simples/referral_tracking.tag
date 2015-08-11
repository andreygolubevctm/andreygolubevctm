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
			<c:set var="callInfo" value="${phoneService.saveCallInfoForTransaction(pageSettings, authenticatedData['login/user/extension'],data.current.transactionId,xpath)}" />
			<c:if test="${callInfo!=null}">
				<field:hidden xpath="${xpath}/callId" constantValue="${callInfo.getCallId()}" />
				<field:hidden xpath="${xpath}/direction" constantValue="${callInfo.getDirection()}" />
				<field:hidden xpath="${xpath}/customerPhoneNo" constantValue="${callInfo.getCustomerPhoneNo()}" />
				<field:hidden xpath="${xpath}/VDN" constantValue="${callInfo.getVdns().get(0)}" />
			</c:if>

		</c:catch>
	</c:if>

</c:if>
