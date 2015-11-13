<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" />

<%-- VARIABLES --%>
<c:set var="secret_key" value="Dx-DgYrR2lJlzW1pNZPohA" />
<c:set var="email"><c:out value="${param.email}" escapeXml="true" /></c:set>
<c:set var="optin"><c:out value="${param.optin}" escapeXml="true" /></c:set>
<c:set var="firstname"><c:out value="${param.firstname}" escapeXml="true" /></c:set>
<c:set var="lastname"><c:out value="${param.lastname}" escapeXml="true" /></c:set>
<c:set var="transactionId"><c:out value="${param.transactionId}" escapeXml="true" /></c:set>
<c:set var="confirmationId"><c:out value="${param.confirmationId}" escapeXml="true" /></c:set>
<c:set var="details_src"><c:out value="${param.details}" escapeXml="true" /></c:set>
<c:set var="details"><go:AESEncryptDecrypt action="decrypt" key="${secret_key}" content="${details_src}" /></c:set>

<c:set var="response">{"success":false,"message":"Sorry, we're unable to register you for news and offer emails at this time. Please try again later."}</c:set>

<c:if test="${not empty email and not empty details}">
	<c:forTokens items="${details}" delims="," var="itemValue">
		<c:set var="propertyId" value="${fn:substringBefore(itemValue,'=')}" />
		<c:set var="value" value="${fn:substringAfter(itemValue,'=')}" />

		<c:if test="${not empty propertyId}">
			<c:choose>
				<c:when test="${propertyId eq 'brand'}">
					<c:set var="brand" value="${value}" />
				</c:when>
				<c:when test="${propertyId eq 'vertical'}">
					<c:set var="vertical" value="${value}" />
				</c:when>
				<c:when test="${propertyId eq 'source'}">
					<c:set var="source" value="${value}" />
				</c:when>
			</c:choose>
		</c:if>
	</c:forTokens>

	<c:if test="${not empty brand and not empty vertical and not empty source }">
		<c:set var="optin_mktg">
			<c:choose>
				<c:when test="${not empty optin}">Y</c:when>
				<c:otherwise>N</c:otherwise>
			</c:choose>
		</c:set>
		<agg:write_email
			brand="${brand}"
			vertical="${vertical}"
			source="${source}"
			emailAddress="${email}"
			emailPassword=""
			firstName="${firstname}"
			lastName="${lastname}"
			items="marketing=${optin_mktg}" />

		<c:set var="response">{"success":true,"message":"Thank you, ${email} has been registered to receive news and offer emails."}</c:set>

		<go:setData dataVar="data" xpath="confirmationOptIn/emailAddress" value="${email}" />
		<%-- Set this here as well so it can be saved for later repopulation. Ideally not needed, but unsure how else to do it... PRJHOML-25 --%>
		<go:setData dataVar="data" xpath="${vertical}/confirmation/confirmationOptIn/emailAddress" value="${email}" />
		<c:set var="xmlData">${data[vertical].confirmation}</c:set>
		<go:setData dataVar="data" xpath="${vertical}/confirmation/confirmationOptIn" value="*DELETE" />
		<sql:setDataSource dataSource="${datasource:getDataSource()}" />
		<c:catch var="error">
			<sql:update>
				UPDATE ctm.confirmations SET XMLdata = ?
				WHERE TransID = ? AND KeyID = ?
				LIMIT 1;
				<sql:param value="${xmlData}" />
				<sql:param value="${transactionId}" />
				<sql:param value="${confirmationId}" />
			</sql:update>
		</c:catch>
		<c:if test="${not empty error}">
			<c:set var="response">{"success":false,"message":"Sorry, we're unable to register you for news and offer emails at this time. Please try again later."}</c:set>
		</c:if>
	</c:if>
</c:if>
${response}
