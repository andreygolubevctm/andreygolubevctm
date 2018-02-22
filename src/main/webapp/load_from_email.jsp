<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.load_from_email')}" />

<c:choose>
	<c:when test="${not empty param.token}">
		<jsp:useBean id="tokenServiceFactory" class="com.ctm.web.core.email.services.token.EmailTokenServiceFactory"/>
		<c:set var="tokenService" value="${tokenServiceFactory.getEmailTokenServiceInstanceAlt(pageContext.getRequest())}" />

		<c:set var="parametersMap" value="${tokenService.decryptToken(param.token)}"/>
		<c:set var="emailData" value="${tokenService.getIncomingEmailDetails(param.token)}"/>

		<c:if test="${empty emailData}">
			<c:set var="hasLogin" value="${tokenService.hasLogin(param.token)}"/>
			<c:choose>
				<c:when test="${hasLogin}">
					${logger.info('Token has expired and user can login. Redirecting to retrieve_quotes.jsp {}', log:kv('parameters', parametersMap))}
					<c:redirect url="${pageSettings.getBaseUrl()}retrieve_quotes.jsp"/>
				</c:when>
				<c:otherwise>
					${logger.info('Token has expired and user cannot login. Redirecting to start_quote.jsp {}', log:kv('parameters', parametersMap))}
					<c:redirect url="${pageSettings.getBaseUrl()}start_quote.jsp"/>
				</c:otherwise>
			</c:choose>

		</c:if>

		<c:set var="vertical"><c:out value="${parametersMap.vertical}" escapeXml="true"/></c:set>
		<c:set var="id"><c:out value="${parametersMap.transactionId}" escapeXml="true"/></c:set>
		<c:set var="hash"><c:out value="${parametersMap.hashedEmail}" escapeXml="true"/></c:set>
		<c:set var="productId"><c:out value="${parametersMap.productId}" escapeXml="true"/></c:set>
		<c:set var="email"><c:out value="${parametersMap.emailAddress}" escapeXml="true"/></c:set>
		<c:set var="type"><c:out value="${parametersMap.emailTokenType}" escapeXml="true"/></c:set>

		<c:set var="expired"><c:out value="${parametersMap.expired}" escapeXml="true"/></c:set>
		<c:set var="campaignId"><c:out value="${parametersMap.cid}" escapeXml="true"/></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="vertical"><c:out value="${param.vertical}" escapeXml="true"/></c:set>
		<c:set var="id"><c:out value="${param.id}" escapeXml="true"/></c:set>
		<c:set var="hash"><c:out value="${param.hash}" escapeXml="true"/></c:set>
		<c:set var="productId"><c:out value="${param.productId}" escapeXml="true"/></c:set>
		<c:set var="email"><c:out value="${param.email}" escapeXml="true"/></c:set>
		<c:set var="type"><c:out value="${param.type}" escapeXml="true"/></c:set>
		<c:set var="expired"><c:out value="${param.expired}" escapeXml="true"/></c:set>
		<c:set var="campaignId"><c:out value="${param.cid}" escapeXml="true"/></c:set>
	</c:otherwise>
</c:choose>

<c:set var="cid"><c:out value="${param.cid}" escapeXml="true"/></c:set>
<c:set var="etRid"><c:out value="${param.et_rid}" escapeXml="true"/></c:set>
<c:set var="utmSource"><c:out value="${param.utm_source}" escapeXml="true"/></c:set>
<c:set var="utmMedium"><c:out value="${param.utm_medium}" escapeXml="true"/></c:set>
<c:set var="utmCampaign"><c:out value="${param.utm_campaign}" escapeXml="true"/></c:set>

<c:set var="productCode">
	<c:if test="${not empty param.productCode}">&productCode=<c:out value="${param.productCode}" escapeXml="false"/></c:if>
</c:set>

<c:if test="${not empty cid and not empty etRid and not empty utmSource and not empty utmMedium and not empty utmCampaign}">
	<c:set var="trackingParams" value="&cid=${cid}&etRid=${etRid}&utmSource=${utmSource}&utmMedium=${utmMedium}&utmCampaign=${utmCampaign}" />
</c:if>

<c:set var="coupon">
	<c:if test="${not empty param.couponid}">
		&couponid=<c:out value="${param.couponid}" escapeXml="false" />
	</c:if>
</c:set>

<settings:setVertical verticalCode="${fn:toUpperCase(vertical)}" />

<%-- 1. Attempt to load quote into session and get JSON object containing load details --%>
<c:set var="loadQuoteURL" value="/ajax/json/remote_load_quote.jsp?action=load&vertical=${vertical}&transactionId=${id}&hash=${hash}&type=${type}&productId=${productId}&email=${email}&expired=${expired}&campaignId=${campaignId}${trackingParams}${productCode}${coupon}" />
<c:import var="loadQuoteJSON" url="${loadQuoteURL}" />

<%-- 2. Check JSON contains destination URL --%>
<c:set var="loadQuoteXML">${go:JSONtoXML(loadQuoteJSON)}</c:set>
<x:parse doc="${loadQuoteXML}" var="loadQuote" />
<c:set var="redirect">
	<x:out select="$loadQuote/result/destUrl" />
</c:set>
<c:set var="error">
	<x:out select="$loadQuote/result/error" />
</c:set>

<%-- 3. Redirect to destination URL or Retrieve Quotes page on failure --%>
<c:choose>
	<c:when test="${empty error and not empty redirect}">
		<c:redirect url="${pageSettings.getBaseUrl()}${go:replaceAll(redirect, '&amp;' ,'&')}" />
	</c:when>
	<c:otherwise>
		<c:if test="${not empty error}">
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="transactionId" value="${data.current.transactionId}" />
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="Failed to load transaction from email link." />
				<c:param name="description" value="${error}" />
				<c:param name="data" value="action=load&vertical=${vertical}&transactionId=${id}&hash=${hash}" />
			</c:import>
		</c:if>
		<c:redirect url="${pageSettings.getBaseUrl()}retrieve_quotes.jsp" />
	</c:otherwise>
</c:choose>