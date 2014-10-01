<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />


<c:choose>
	<c:when test="${not empty unsubscribe && empty param.unsubscribe_email and not empty unsubscribe.getEmailDetails()}">
		<jsp:useBean id="unsubscribe" class="com.ctm.model.Unsubscribe" scope="session" />
		<c:set var="customerName" ><c:out escapeXml="true" value="${unsubscribe.getCustomerName()}" /></c:set>
		<c:set var="emailAddress" ><c:out escapeXml="true" value="${unsubscribe.getCustomerEmail()}" /></c:set>
		<c:set var="verticalCode" ><c:out escapeXml="true" value="${unsubscribe.getVertical()}" /></c:set>

<c:choose>
			<c:when test="${unsubscribe.isMeerkat()}">
				<%-- #WHITELABEL TODO: support meerkat brand--%>
				<meerkat:unsubscribe />
	</c:when>
	<c:otherwise>
				<core:unsubscribe />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:when test="${not empty param.unsubscribe_email || not empty param.email}">
		<c:set var="isDisc" value="${param.DISC eq 'true'}" />

		<jsp:useBean id="unsubscribeService" class="com.ctm.services.UnsubscribeService" scope="request" />
		<c:catch var="error">
			<c:set var="unsubscribe" value="${unsubscribeService.getUnsubscribeDetails(param.vertical , fn:substring(param.unsubscribe_email, 0, 256),param.email, isDisc, pageSettings, pageContext.getRequest())}" scope="session" />
			<c:if test="${isDisc}">
				<security:insecure_hashed_email email="${param.unsubscribe_email}" unsubscribe="${unsubscribe}" />
			</c:if>
		
			<%-- #WHITELABEL TODO: support meerkat brand--%>
			<c:if test="${fn:toUpperCase(param.brand) == 'MEER'}">
				<c:set var="ignore">
				${unsubscribe.setMeerkat(true)}
				<c:if test="${empty param.vertical}">
					${unsubscribe.setVertical('competition')}
				</c:if>
		</c:set>
			</c:if>
		</c:catch>
		<c:if test="${not empty error}">
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="Failed to check email" />
				<c:param name="description" value="${error}" />
			</c:import>
		</c:if>
		<%-- Redirect --%>
		<go:log level="DEBUG">redirect to ${pageSettings.getBaseUrl()}unsubscribe.jsp"</go:log>
		<c:redirect url="${pageSettings.getBaseUrl()}unsubscribe.jsp" />
	</c:when>
	<c:otherwise>
		<go:log level="ERROR" source="unsubscribe.jsp">invalid params</go:log>
	</c:otherwise>
</c:choose>
