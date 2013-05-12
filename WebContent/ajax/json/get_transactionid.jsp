<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Fetch and store the transaction id --%>
<go:log>get_transactionid params: ${param}</go:log>

<c:choose>
	<%-- AGG-818: add car, fuel and roadside --%>
	<c:when test="${not empty param.quoteType and fn:contains('travel,health,life,ip,utilities', param.quoteType)}">
		<c:choose>
			<%-- Only preserve the transaction ID if loading an existing transaction --%>
			<c:when test="${(not empty data.current.transactionId or not empty param.transactionId) and ((empty param.id_handler and not empty param.action and (param.action eq 'amend' or param.action eq 'latest' or param.action eq 'confirmation')) or (not empty param.id_handler && param.id_handler eq 'preserve_tranId'))}">
				<go:log>===== Preserving the original transaction id</go:log>
				<c:set var="transactionId">
					<c:choose>
						<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
						<c:otherwise>${data.current.transactionId}</c:otherwise>
					</c:choose>
				</c:set>
			</c:when>
			<%-- Increment the ID if requested --%>
			<c:when test="${(not empty data.current.transactionId or not empty param.transactionId) and not empty param.id_handler and param.id_handler eq 'increment_tranId'}">
				<go:log>===== Incrementing the transaction id</go:log>

				<c:set var="requestedTransaction">
					<c:choose>
						<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
						<c:otherwise>${data.current.transactionId}</c:otherwise>
					</c:choose>
				</c:set>

				<sql:setDataSource dataSource="jdbc/aggregator"/>

				<%-- Start by getting the transaction in question
				--%>
				<sql:query var="getTransaction">
					SELECT * FROM aggregator.transaction_header
					WHERE TransactionId = ?;
					<sql:param value="${requestedTransaction}" />
				</sql:query>

				<%-- Proceed if Operator doesn't own the quote - we need to duplicate it and assign to the operator --%>
				<c:if test="${not empty getTransaction and getTransaction.rowCount > 0}">

					<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
					<c:set var="sessionId" 		value="${pageContext.session.id}" />
					<c:set var="status" 		value="" />

					<go:log>IDs for Get TransactionID = ipAddress: ${pageContext.request.remoteAddr}, sessionID = ${pageContext.session.id}</go:log>

					<%-- Ok, now to duplicate the transaction header record --%>
					<c:catch var="error">
						<sql:update var="ownerCheck">
							INSERT INTO aggregator.transaction_header
							(TransactionId,rootId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status)
							values (
								0,
								'${getTransaction.rows[0].rootId}',
								?,
								'${getTransaction.rows[0].ProductType}',
								?,
								'${ipaddress}',
								CURRENT_DATE,
								CURRENT_TIME,
								'${getTransaction.rows[0].styleCode}',
								0,
								'${sessionId}',
								'${status}'
							);
							<sql:param value="${requestedTransaction}" />
							<sql:param value="${getTransaction.rows[0].EmailAddress}" />
						</sql:update>
					</c:catch>

					<c:if test="${not empty error}"><go:log>${error}</go:log></c:if>

					<c:if test="${empty error}">
						<%-- Still good, let update the new record with the correct rootId --%>
						<c:catch var="error">
							<sql:query var="results">
								SELECT LAST_INSERT_ID() AS tranId
								FROM aggregator.transaction_header;
							</sql:query>

							<c:set var="tranId" value="${results.rows[0].tranId}" />
						</c:catch>

						<c:if test="${not empty error}"><go:log>${error}</go:log></c:if>

						<c:if test="${empty error}">
							<%-- Going strong, now we can duplicate the old transaction details for the new transaction --%>
							<c:catch var="error">
								<sql:query var="details">
									SELECT * FROM aggregator.transaction_details WHERE transactionId = ?;
									<sql:param value="${requestedTransaction}" />
								</sql:query>
							</c:catch>

							<c:if test="${not empty error}"><go:log>${error}</go:log></c:if>

							<c:if test="${empty error and not empty details and details.rowCount > 0}">
								<c:set var="counter" value="0" />
								<c:forEach var="row" items="${details.rows}" varStatus="status">
									<c:set var="counter" value="${status.count}" />
									<sql:update>
										INSERT INTO aggregator.transaction_details
										(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
										values ((?),(?),(?),(?),(?),(?));
										<sql:param value="${tranId}" />
										<sql:param value="${row.sequenceNo}" />
										<sql:param value="${row.xpath}" />
										<sql:param value="${row.textValue}" />
										<sql:param value="${row.numericValue}" />
										<sql:param value="${row.dateValue}" />
									</sql:update>
								</c:forEach>

								<%-- Finally we'll replace the requestedTransaction var with the new ID --%>
								<c:set var="requestedTransaction" value="${tranId}" />

								<go:log>Duplicated all transactions details...</go:log>

							</c:if>
						</c:if>
					</c:if>
				</c:if>

				<c:set var="transactionId">${requestedTransaction}</c:set>
			</c:when>
			<c:otherwise>
				<go:log>===== Starting a NEW transaction id</go:log>

				<%-- Remove any previous save content for the new quote --%>
				<go:setData dataVar="data" xpath="save" value="*DELETE" />

				<sql:setDataSource dataSource="jdbc/aggregator"/>

				<c:catch var="error">
					<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
					<c:set var="sessionId" 		value="${pageContext.session.id}" />
					<c:set var="status" 		value="" />

					<sql:update var="ownerCheck">
						INSERT INTO aggregator.transaction_header
						(TransactionId,rootId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCode,advertKey,sessionId,status)
						values (
							0,
							'0',
							'0',
							?,
							'${isOperator}',
							'${ipAddress}',
							CURRENT_DATE,
							CURRENT_TIME,
							'CTM',
							0,
							'${sessionId}',
							'${status}'
							<sql:param value="${fn:toUpperCase(param.quoteType)}" />
						);
					</sql:update>
				</c:catch>

				<c:if test="${not empty error}"><go:log>${error}</go:log></c:if>

				<c:if test="${empty error}">
					<%-- Still good, let's update the new record with the correct rootId --%>
					<c:catch var="error">
						<sql:query var="results">
							SELECT LAST_INSERT_ID() AS tranId
							FROM aggregator.transaction_header;
						</sql:query>

						<c:set var="tranId" value="${results.rows[0].tranId}" />

						<sql:update>
							UPDATE aggregator.transaction_header
							SET rootId = '${tranId}'
							WHERE TransactionId = '${tranId}';
						</sql:update>
					</c:catch>
				</c:if>

				<c:set var="transactionId">${tranId}</c:set>

			</c:otherwise>
		</c:choose>
		<go:log>get_transactionid outcome: ${transactionId}</go:log>
		<go:setData dataVar="data" xpath="current/transactionId" value="${transactionId}" />
		{"transactionId":"${transactionId}"}
	</c:when>
	<c:otherwise>
		<c:choose>
			<%-- Only preserve the transaction ID if loading an existing transaction --%>
			<c:when test="${(not empty data.current.transactionId or not empty param.transactionId) and ((empty param.id_handler and not empty param.action and (param.action eq 'amend' or param.action eq 'latest' or param.action eq 'confirmation')) or (not empty param.id_handler && param.id_handler eq 'preserve_tranId'))}">
				<go:log>===== Preserving the original DISC transaction id</go:log>
				<go:log>Current: ${data.current}</go:log>
				<go:log>Param: ${param}</go:log>
				<c:set var="transactionId">
					<c:choose>
						<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
						<c:otherwise>${data.current.transactionId}</c:otherwise>
					</c:choose>
				</c:set>
			</c:when>
			<c:otherwise>
				<go:log>===== Getting NEW DISC transaction id</go:log>
				<go:call pageId="AGGTID" wait="TRUE" resultVar="tranXml" transactionId="${data['current/transactionId']}" style="CTM"/>
				<go:log>+++++ ${tranXml} +++++</go:log>
				<go:setData dataVar="data" xpath="current/transactionId" value="${tranXml}" />
			</c:otherwise>
		</c:choose>
		<go:log>get_transactionid outcome: ${data.current.transactionId}</go:log>
		{"transactionId":"${data['current/transactionId']}"}
	</c:otherwise>
</c:choose>