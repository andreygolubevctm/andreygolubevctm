<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm" />
<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="request" />

<%-- This query only runs on Life for now as IP sends the lead directly. --%>
<c:set var="vertical" value="life" />

<c:catch var="error">
	<sql:query var="transactionIds">
		SELECT th.transactionId as transaction_id
		FROM ctm.touches t
		JOIN aggregator.transaction_header th ON th.transactionId = t.transaction_id
		WHERE th.rootId NOT IN (
			SELECT th.rootId
			FROM aggregator.transaction_header th
			JOIN ctm.touches t ON th.transactionId = t.transaction_id
			WHERE th.ProductType IN ("LIFE")
			AND StartDate = CURDATE()
			AND (type = "LF" OR type = "R")
			GROUP BY th.rootId
		)
		AND type = "CDC"
		AND StartDate = CURDATE()
		AND time < TIME(NOW() - INTERVAL 15 MINUTE)
		AND th.ProductType = "LIFE"
		GROUP BY th.rootId;
	</sql:query>
</c:catch>

<c:choose>
	<%-- if error connecting to the db --%>
	<c:when test="${not empty error}">
		<c:set var="errorPool">The CTM life_lead_feed cron job could not connect to the database - ${error.rootCause}</c:set>
	</c:when>

	<%-- if there are some results --%>
	<c:when test="${not empty transactionIds and transactionIds.rowCount > 0}">
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
					<settings:setVertical verticalCode="${fn:toUpperCase(vertical)}" />

					<go:setData dataVar="data" xpath="${vertical}" value="*DELETE" />

					<go:setData dataVar="data" xpath="${vertical}/quoteAction" value="start" />

					<c:forEach var="transactionDatum" items="${transactionData.rows}">
						<go:setData dataVar="data" xpath="${transactionDatum.xpath}" value="${transactionDatum.textValue}" />
					</c:forEach>

					<%-- Load the config for the contact lead sender --%>
					<c:import var="config" url="/WEB-INF/aggregator/life/config_contact_lead.xml" />

					<c:set var="touchResponse">${accessTouchService.recordTouchWithComment(result.transaction_id, "LF", "lifebroker")}</c:set>

					<go:soapAggregator 	config = "${config}"
										transactionId = "${result.transaction_id}"
										xml = "${go:getEscapedXml(data[fn:toLowerCase(vertical)])}"
										var = "resultXml"
										debugVar="debugXml"
										verticalCode="${fn:toUpperCase(vertical)}"
										configDbKey="quoteService"
										styleCodeId="${pageSettings.getBrandId()}"
										/>
				</c:when>
			</c:choose>
		</c:forEach>
	</c:when>
</c:choose>