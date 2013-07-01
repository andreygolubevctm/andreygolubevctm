<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="life" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="life" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />
		
		<go:setData dataVar="data" xpath="life/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="life/clientUserAgent" value="${clientUserAgent}" />

		<%-- Save client data --%>
		<agg:write_quote productType="LIFE" rootPath="life"/>

		<%-- Save Email Data --%>		
		<c:set var="marketing">
			<c:choose>
				<c:when test="${empty data.ip.contactDetails.optIn}">N</c:when>
				<c:otherwise>${data.ip.contactDetails.optIn}</c:otherwise>
			</c:choose>
		</c:set>
		<c:if test="${not empty data.ip.contactDetails.email}">
			<agg:write_email
				brand="CTM"
				vertical="IP"
				source="QUOTE"
				emailAddress="${data.ip.contactDetails.email}"
				firstName="${data.ip.details.primary.firstName}"
				lastName="${data.ip.details.primary.lastname}"
				items="marketing=${marketing},okToCall=${data.ip.contactDetails.call}" />
		</c:if>
	</c:when>
	<c:otherwise><%-- IGNORE GRACEFULLY --%></c:otherwise>
</c:choose>