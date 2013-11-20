<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator" />

<go:log>Load PendingID:${param.PendingID}, PendingTranID:${param.PendingTranID}, CallCentre:${callCentre}</go:log>

	<sql:query var="result">
		SELECT d2.*
		FROM aggregator.transaction_details d1
		LEFT JOIN aggregator.transaction_details d2 ON d1.transactionId = d2.transactionId
		WHERE d1.transactionId = ? AND d1.xpath = 'pendingID' AND d1.textValue = ?
		ORDER BY d1.transactionId DESC
		<sql:param value="${param.PendingTranID}" />
		<sql:param value="${param.PendingID}" />
	</sql:query>


<%-- Validate the items for the vertical --%>
<c:set var="errors" value="" />
<c:choose>
	<c:when test="${empty result}">
		<c:set var="errors" value="No pending application can be loaded" />
	</c:when>
	<c:when test="${result.rowCount == 0}">
		<c:set var="errors" value="Pending application is invalid and can not be loaded" />
	</c:when>
</c:choose>

<c:choose>
	<c:when test="${not empty errors}">
		<go:log>Load Pending Errors = ${errors}</go:log>
		<c:set var="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<data>
				<status>Error</status>
				<message>${errors}</message>
			</data>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:forEach var="row" items="${result.rows}" varStatus="status">
			<c:choose>
				<c:when test="${row.xpath == 'health/application/provider'}"><go:setData dataVar="data" xpath="tempPending/provider" value="${row.textValue}" /></c:when>
				<c:when test="${row.xpath == 'health/application/productTitle'}"><go:setData dataVar="data" xpath="tempPending/productTitle" value="${row.textValue}" /></c:when>
				<c:when test="${row.xpath == 'health/payment/details/start'}"><go:setData dataVar="data" xpath="tempPending/startDate" value="${row.textValue}" /></c:when>
				<c:when test="${row.xpath == 'health/payment/details/frequency'}"><go:setData dataVar="data" xpath="tempPending/frequency" value="${row.textValue}" /></c:when>
				<c:when test="${row.xpath == 'health/application/paymentFreq'}"><go:setData dataVar="data" xpath="tempPending/premium" value="${row.textValue}" /></c:when>
			</c:choose>
		</c:forEach>

		<c:set var="premium"><fmt:formatNumber type="currency" value="${data['tempPending/premium']}" maxFractionDigits="2" groupingUsed="true" currencySymbol="$" /></c:set>

		<c:set var="xmlData">
			<data>
				<info>
					<provider><c:out value="${data['tempPending/provider']}" /></provider>
					<name><c:out value="${data['tempPending/productTitle']}" /></name>
				</info>
				<startDate><c:out value="${data['tempPending/startDate']}" /></startDate>
				<frequency><c:out value="${data['tempPending/frequency']}" /></frequency>
				<premium>
					<weekly>
						<text><c:out value="${premium}" /></text>
						<pricing></pricing>
					</weekly>
					<fortnightly>
						<text><c:out value="${premium}" /></text>
						<pricing></pricing>
					</fortnightly>
					<monthly>
						<text><c:out value="${premium}" /></text>
						<pricing></pricing>
					</monthly>
					<quarterly>
						<text><c:out value="${premium}" /></text>
						<pricing></pricing>
					</quarterly>
					<halfyearly>
						<text><c:out value="${premium}" /></text>
						<pricing></pricing>
					</halfyearly>
					<annually>
						<text><c:out value="${premium}" /></text>
						<pricing></pricing>
					</annually>
				</premium>
				<promo>
					<promoText></promoText>
					<extrasPDF></extrasPDF>
				</promo>
				<hospital>
					<inclusions>
						<excess></excess>
						<waivers></waivers>
						<copayment></copayment>
					</inclusions>
					<benefits>
						<exclusions></exclusions>
					</benefits>
				</hospital>
				<extras>
					<DentalGeneral>
						<benefits></benefits>
					</DentalGeneral>
				</extras>
			</data>
		</c:set>

		<go:setData dataVar="data" xpath="tempPending" value="*DELETE" />
	</c:otherwise>
</c:choose>

${go:XMLtoJSON(xmlData)}