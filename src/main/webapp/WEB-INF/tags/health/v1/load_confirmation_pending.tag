<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Load the confirmation page info based on the key passed in the URL"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.health.load_confirmation_pending')}" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="token"><c:out value="${param.token}" escapeXml="true" /></c:set>
<c:set var="PendingTranID" value="${fn:split(token, '-')[fn:length(fn:split(token, '-'))-1]}" />

<sql:setDataSource dataSource="${datasource:getDataSource()}" />

	${logger.info('Beginning load. {},{},{}' , log:kv('token',token ), log:kv('PendingTranID',PendingTranID ), log:kv('callCentre',callCentre ))}

	<c:choose>
		<c:when test="${empty PendingTranID}">
		</c:when>
		<c:when test="${not empty callCentre}">
			<sql:query var="result">
				SELECT d2.*
				FROM aggregator.transaction_details d1
				LEFT JOIN aggregator.transaction_details d2
				ON d1.transactionId = d2.transactionId
				INNER JOIN aggregator.transaction_header h
				ON d2.transactionid = h.transactionid
				AND h.StyleCodeId = ?
				WHERE d1.transactionId = ?
				AND d1.xpath = 'pendingID'
				ORDER BY d1.transactionId DESC
				<sql:param value="${styleCodeId}" />
				<sql:param value="${PendingTranID}" />
			</sql:query>
			<c:if test="${result.rowCount == 0}">
				<sql:query var="result">
					SELECT tf2.fieldCode as 'xpath', d2.textValue
					FROM aggregator.transaction_details2_cold d1
					LEFT JOIN aggregator.transaction_details2_cold d2
					ON d1.transactionId = d2.transactionId
					INNER JOIN aggregator.transaction_header2_cold h
					ON d2.transactionid = h.transactionid
					AND h.StyleCodeId = ?

					INNER JOIN aggregator.transaction_fields tf
					ON d1.fieldId = tf.fieldId
					AND  tf.fieldCode = 'pendingID'

					INNER JOIN aggregator.transaction_fields tf2
					ON d2.fieldId = tf2.fieldId
					WHERE h.transactionid = ?
					<sql:param value="${styleCodeId}" />
					<sql:param value="${PendingTranID}" />
				</sql:query>
			</c:if>
		</c:when>
		<c:otherwise>
			<sql:query var="result">
				SELECT d2.*
				FROM aggregator.transaction_details d1
				LEFT JOIN aggregator.transaction_details d2
				ON d1.transactionId = d2.transactionId
				INNER JOIN aggregator.transaction_header h
				ON d2.transactionid = h.transactionid
				AND h.StyleCodeId = ?
				WHERE d1.transactionId = ?
				AND d1.xpath = 'pendingID'
				AND d1.textValue = ?
				ORDER BY d1.transactionId DESC
				<sql:param value="${styleCodeId}" />
				<sql:param value="${PendingTranID}" />
				<sql:param value="${token}" />
			</sql:query>
			<c:if test="${result.rowCount == 0}">
				<sql:query var="result">
					SELECT tf2.fieldCode as 'xpath', d2.textValue
					FROM aggregator.transaction_details2_cold d1
					LEFT JOIN aggregator.transaction_details2_cold d2
					ON d1.transactionId = d2.transactionId
					INNER JOIN aggregator.transaction_header2_cold h
					ON d2.transactionid = h.transactionid
					AND h.StyleCodeId = ?

					INNER JOIN aggregator.transaction_fields tf
					ON d1.fieldId = tf.fieldId
					AND  tf.fieldCode = 'pendingID'
					AND d1.textValue = ?

					INNER JOIN aggregator.transaction_fields tf2
					ON d2.fieldId = tf2.fieldId
					WHERE h.transactionid = ?
					<sql:param value="${styleCodeId}" />
					<sql:param value="${token}" />
					<sql:param value="${PendingTranID}" />
				</sql:query>
			</c:if>
		</c:otherwise>
	</c:choose>

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
		${logger.info('Load Pending Errors. {}', log:kv('PendingTranID', PendingTranID), errors)}
		<c:set var="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<data>
				<status>Error</status>
				<message><c:out value="${errors}" /></message>
			</data>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:forEach var="row" items="${result.rows}" varStatus="status">
			<c:choose>
				<c:when test="${row.xpath == 'current/encryptedOrderLineId'}">
					<c:set var="redemptionId" value="${row.textValue}" />
				</c:when>
				<c:when test="${row.xpath == 'health/application/provider'}">
					<c:set var="provider" value="${row.textValue}" />
				</c:when>
				<c:when test="${row.xpath == 'health/application/productTitle'}">
					<c:set var="productTitle" value="${row.textValue}" />
				</c:when>
				<c:when test="${row.xpath == 'health/payment/details/start'}">
					<c:set var="startDate" value="${row.textValue}" />
				</c:when>
				<c:when test="${row.xpath == 'health/payment/details/frequency'}">
					<c:set var="frequency" value="${row.textValue}" />
				</c:when>
				<c:when test="${row.xpath == 'health/application/paymentFreq'}">
					<c:set var="premium"><c:out value="${go:formatCurrency(row.textValue, true, true)}" /></c:set>
				</c:when>
				<c:when test="${row.xpath == 'health/payment/details/frequency'}">
					<c:set var="frequency"><c:out value="${row.textValue}" /></c:set>
				</c:when>
				<c:when test="${row.xpath == 'health/loadingAmt'}">
					<c:set var="lhc">
						<c:choose>
							<c:when test="${frequency eq 'W' or frequency eq 'weekly'}">
								<c:out value="${row.textValue / 52}" />
							</c:when>
							<c:when test="${frequency eq 'F' or frequency eq 'fortnightly'}">
								<c:out value="${row.textValue / 26}" />
							</c:when>
							<c:when test="${frequency eq 'M' or frequency eq 'monthly'}">
								<c:out value="${row.textValue / 12}" />
							</c:when>
							<c:when test="${frequency eq 'Q' or frequency eq 'quarterly'}">
								<c:out value="${row.textValue / 4}" />
							</c:when>
							<c:when test="${frequency eq 'H' or frequency eq 'halfyearly'}">
								<c:out value="${row.textValue / 2}" />
							</c:when>
							<c:otherwise><c:out value="${row.textValue}" /></c:otherwise>
						</c:choose>
					</c:set>
					<c:set var="lhc" value=">${go:formatCurrency(lhc, true, true)}" />
				</c:when>
				<c:when test="${row.xpath == 'health/rebateAmt'}">
					<c:set var="rebateAmount"><c:out value="${go:formatCurrency(row.textValue, true, true)}" /></c:set>
				</c:when>
				<c:when test="${row.xpath == 'health/voucher/value'}">
					<c:set var="voucherValue" value="${row.textValue}" />
				</c:when>
			</c:choose>
		</c:forEach>



		<c:set var="xmlData">
			<data>
				<status>OK</status>
				<info>
					<provider><c:out value="${provider}" /></provider>
					<providerName><c:out value="${provider}" /></providerName>
					<name><c:out value="${productTitle}" /></name>
				</info>
				<startDate><c:out value="${startDate}" /></startDate>
				<frequency><c:out value="${frequency}" /></frequency>
				<premium>
					<weekly>
						<text><c:out value="${premium}" /></text>
						<lhcAmount><c:out value="${lhc}" /></lhcAmount>
						<rebateAmount><c:out value="${rebateAmount}" /></rebateAmount>
					</weekly>
					<fortnightly>
						<text><c:out value="${premium}" /></text>
						<lhcAmount><c:out value="${lhc}" /></lhcAmount>
						<rebateAmount><c:out value="${rebateAmount}" /></rebateAmount>
					</fortnightly>
					<monthly>
						<text><c:out value="${premium}" /></text>
						<lhcAmount><c:out value="${lhc}" /></lhcAmount>
						<rebateAmount><c:out value="${rebateAmount}" /></rebateAmount>
					</monthly>
					<quarterly>
						<text><c:out value="${premium}" /></text>
						<lhcAmount><c:out value="${lhc}" /></lhcAmount>
						<rebateAmount><c:out value="${rebateAmount}" /></rebateAmount>
					</quarterly>
					<halfyearly>
						<text><c:out value="${premium}" /></text>
						<lhcAmount><c:out value="${lhc}" /></lhcAmount>
						<rebateAmount><c:out value="${rebateAmount}" /></rebateAmount>
					</halfyearly>
					<annually>
						<text><c:out value="${premium}" /></text>
						<lhcAmount><c:out value="${lhc}" /></lhcAmount>
						<rebateAmount><c:out value="${rebateAmount}" /></rebateAmount>
					</annually>
				</premium>
				<promo>
					<promoText></promoText>
					<extrasPDF></extrasPDF>
					<hospitalPDF></hospitalPDF>
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
				<transID><c:out value="${PendingTranID}" /></transID>
				<whatsNext></whatsNext>
				<about></about>
				<redemptionId><c:out value="${redemptionId}" /></redemptionId>
				<voucherValue><c:out value="${voucherValue}" /></voucherValue>
			</data>
		</c:set>

	</c:otherwise>
</c:choose>

${xmlData}