<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.cron.life.best_price_lead')}" />

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<sql:setDataSource dataSource="jdbc/ctm" />
<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="request" />

<c:catch var="error">
	<sql:query var="transactionIds">
		SELECT SQL_NO_CACHE MAX(transaction_header.transactionId) as transaction_id, ProductType
		FROM ctm.touches
		JOIN aggregator.transaction_header ON transaction_header.transactionId = touches.transaction_id
		WHERE (
			StartDate = CURDATE() - INTERVAL 1 DAY
			OR (
				StartDate = CURDATE()
				AND time < TIME(NOW() - INTERVAL 1 MINUTE)
			)
		)
		AND ProductType IN ("LIFE", "IP")
		AND type = "R"
		AND rootId NOT IN (
			SELECT th.rootId
			FROM aggregator.transaction_header th
			JOIN ctm.touches t ON th.transactionId = t.transaction_id
			WHERE th.ProductType IN ("LIFE", "IP")
			AND t.type IN ("C", "CB", "LF")
			GROUP BY th.rootId
		)
		GROUP BY transaction_header.rootId;
	</sql:query>
</c:catch>

<c:choose>
	<%-- if error connecting to the db --%>
	<c:when test="${not empty error}">
		<c:set var="errorMessage">The CTM life_best_price_lead cron job could not connect to the database - ${error.rootCause}</c:set>
	</c:when>

	<%-- if there are some results --%>
	<c:when test="${not empty transactionIds and transactionIds.rowCount > 0}">
		<c:forEach var="result" items="${transactionIds.rows}">
			<settings:setVertical verticalCode="${result.ProductType}" />
			<c:set var="vertical" value="${fn:toLowerCase(result.ProductType)}" />
		
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
			
			<c:catch var="getRankingDataError">
				<sql:query var="rankingData">
					SELECT Property, Value
					FROM aggregator.ranking_details
					WHERE transactionId = ?
					AND RankPosition = 0
					AND CalcSequence = 1;
					<sql:param value="${result.transaction_id}" />
				</sql:query>
			</c:catch>

			<c:choose>
				<c:when test="${not empty getTransactionDataError or not empty getRankingDataError}">
					<c:set var="errorMessage">The CTM life_best_price_lead cron job could not get a transaction's details - ${getTransactionDataError.rootCause}</c:set>
				</c:when>
				<%-- if there are some results --%>
				<c:when test="${not empty transactionData and transactionData.rowCount > 0}">
					<c:set var="company" value="lifebroker" />
					<c:if test="${not empty rankingData and rankingData.rowCount > 0}">
						<c:forEach var="rankingDatum" items="${rankingData.rows}">
							<c:if test="${rankingDatum.Property eq 'company'}">
								<c:set var="company" value="${rankingDatum.Value}" />
							</c:if>
						</c:forEach>
					</c:if>
				
					<go:setData dataVar="data" xpath="${fn:toLowerCase(result.ProductType)}" value="*DELETE" />
				
					<c:forEach var="transactionDatum" items="${transactionData.rows}">
						<go:setData dataVar="data" xpath="${transactionDatum.xpath}" value="${transactionDatum.textValue}" />
					</c:forEach>
					
					<go:setData dataVar="data" xpath="transactionId" value="${result.transaction_id}" />

					<c:choose>
						<c:when test="${company eq 'ozicare'}">
							<%-- SEND AGIS LEAD --%>
							<jsp:useBean id="AGISLeadFromCronJob" class="com.ctm.services.life.AGISLeadFromCronJob" scope="page" />
							<c:set var="leadResultStatus" value="${AGISLeadFromCronJob.newLeadFeed(result.transaction_id, transactionData, rankingData, pageSettings)}" />

							<c:if test="${leadResultStatus eq 'OK'}">
								<%-- SEND AGIS EMAIL --%>
								<jsp:useBean id="emailService" class="com.ctm.services.email.EmailService" scope="page" />
								
								<%-- enums are not will handled in jsp --%>
								<% request.setAttribute("BEST_PRICE", com.ctm.model.email.EmailMode.BEST_PRICE); %>
								<c:catch var="error">
									${emailService.send(pageContext.request, BEST_PRICE, data.life.contactDetails.email, result.transaction_id)}
								</c:catch>
							</c:if>

							<%--
							This will either be a RuntimeException or SendEmailException
							If this fails it is not a show stopper so log and keep calm and carry on
							--%>
							<c:if test="${not empty error}">
								${logger.error('failed to send best price for result. {},{}', log:kv('transaction_id',result.transaction_id ), log:kv('email',data.life.contactDetails.email ))}
								${fatalErrorService.logFatalError(error, pageSettings.getBrandId(), pageContext.request.servletPath , pageContext.session.id, false, result.transaction_id)}
							</c:if>
						</c:when>
						<c:otherwise>
							<%-- Load the config for the contact lead sender --%>
							<jsp:useBean id="configResolver" class="com.ctm.utils.ConfigResolver" scope="application" />
							<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/life/config_contact_lead.xml')}" />

							<go:setData dataVar="data" xpath="${vertical}/quoteAction" value="delay" />

							<%-- SEND LIFEBROKER LEAD --%>
							<go:soapAggregator  config = "${config}"
												transactionId = "${result.transaction_id}"
												xml = "${go:getEscapedXml(data[fn:toLowerCase(vertical)])}"
												var = "resultXml"
												debugVar="debugXml"
												verticalCode="${fn:toUpperCase(vertical)}"
												configDbKey="leadfeedService"
												styleCodeId="${pageSettings.getBrandId()}"
												/>

							<c:set var="leadSentTo" value="${company eq 'ozicare' ? 'ozicare' : 'lifebroker'}" />
							<c:set var="touchResponse">${accessTouchService.recordTouchWithComment(result.transaction_id, "LF", leadSentTo)}</c:set>
						</c:otherwise>
					</c:choose>

					<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/emailSentBy" value="${leadSentTo}" />
					<go:setData dataVar="data" xpath="current/transactionId" value="${result.transaction_id}" />
					<agg:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${vertical}" source="REQUEST-CALL" dataObject="${data}" />
				</c:when>
			</c:choose>
		</c:forEach>
	</c:when>
</c:choose>

<c:if test="${not empty errorMessage}">
	<c:import url="../../ajax/write/register_fatal_error.jsp">
		<c:param name="page" value="ajax/write/life_best_price_lead.jsp" />
		<c:param name="message" value="${errorMessage}" />
		<c:param name="description" value="${errorMessage}" />
		<c:param name="isFatal" value="1" />
	</c:import>
</c:if>