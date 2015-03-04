<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm" />
<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="request" />

<c:catch var="error">
	<sql:query var="transactionIds">
		SELECT touches.transaction_id
		FROM ctm.touches
		JOIN aggregator.transaction_header ON transaction_header.transactionId = touches.transaction_id
		WHERE transaction_id NOT IN (
			SELECT transaction_id
			FROM ctm.touches
			WHERE date = CURDATE()
			AND (type = "LF" OR type = "R")
		)
		AND type = "CDC"
		AND date = CURDATE()
		AND time < TIME(NOW() - INTERVAL 15 MINUTE)
		AND ProductType = "LIFE"
		GROUP BY transaction_id;
	</sql:query>
</c:catch>

<c:choose>
	<%-- if error connecting to the db --%>
	<c:when test="${not empty error}">
		<c:set var="errorPool">The CTM life_lead_feed cron job could not connect to the database - ${error.rootCause}</c:set>
	</c:when>

	<%-- if there are some results --%>
	<c:when test="${not empty transactionIds and transactionIds.rowCount > 0}">
		<%-- Load the config for the contact lead sender --%>
		<c:import var="config" url="/WEB-INF/aggregator/life/config_contact_lead.xml" />
		
		<c:forEach var="result" items="${transactionIds.rows}">
			<%--
				- Take each transaction ID
				- Get user information stored in transaction_details
				- Post information to life_contact_lead.jsp and send lead to Lifebroker
			--%>
			<c:catch var="getTransactionDataError">
				<sql:query var="transactionData">
					SELECT xpath, textValue
					FROM aggregator.transaction_details
					WHERE transactionId = ?;
					<sql:param value="${result.transaction_id}" />
				</sql:query>
			</c:catch>
			
			<c:choose>
				<c:when test="${not empty getTransactionDataError}">
					<c:set var="errorPool">The CTM life_lead_feed cron job could not get a transaction's details - ${getTransactionDataError.rootCause}</c:set>
					<go:log>${errorPool}</go:log>
				</c:when>
				<%-- if there are some results --%>
				<c:when test="${not empty transactionData and transactionData.rowCount > 0}">
					<go:setData dataVar="data" xpath="life" value="*DELETE" />
					
					<c:forEach var="transactionDatum" items="${transactionData.rows}">
						<go:setData dataVar="data" xpath="${transactionDatum.xpath}" value="${transactionDatum.textValue}" />
					</c:forEach>
					
					<go:soapAggregator 	config = "${config}"
										transactionId = "${result.transaction_id}"
										xml = "${go:getEscapedXml(data[fn:toLowerCase(vertical)])}"
										var = "resultXml"
										debugVar="debugXml"
										verticalCode="${fn:toUpperCase(vertical)}"
										configDbKey="quoteService"
										styleCodeId="${pageSettings.getBrandId()}"
										/>
										
					<%-- Set the touch response as a variable so that we don't output to screen --%>
					<c:set var="recordTouchResponse">${accessTouchService.recordTouch(result.transaction_id, "LF")}</c:set>
				</c:when>
			</c:choose>
		</c:forEach>
	</c:when>
</c:choose>