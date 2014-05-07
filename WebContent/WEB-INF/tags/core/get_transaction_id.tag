<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- #WHITELABEL styleCodeID --%>
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="styleCode">${pageSettings.getBrandCode()}</c:set>

<%-- ATTRIBUTES --%>
<%@ attribute name="transactionId"	required="false" rtexprvalue="true"	description="" %>
<%@ attribute name="id_handler"		required="false" rtexprvalue="true"	description="" %>
<%@ attribute name="emailAddress"	required="false" rtexprvalue="true"	description="" %>
<%@ attribute name="quoteType"		required="false" rtexprvalue="true"	description="The vertical this quote is associated with" %>


<c:set var="serverIp"><%
	String ip = request.getLocalAddr();
	try {
		java.net.InetAddress address = java.net.InetAddress.getLocalHost();
		ip = address.getHostAddress();
	}
	catch (Exception e) {}
%><%= ip %></c:set>

<%-- Fetch and store the transaction id --%>
<go:log source="core:get_transactionid">transactionId: ${transactionId} id_handler: ${id_handler} emailAddress: ${emailAddress}  quoteType: ${quoteType}</go:log>

<%-- Current TransId Test --%>
<c:choose>
	<c:when test="${not empty transactionId}">
		<c:set var="hasTransId" value="${true}" />
		<go:setData dataVar="data" value="${fn:trim(transactionId)}" xpath="current/transactionId" />
	</c:when>
	<c:when test="${not empty data.current.transactionId}">
		<c:set var="hasTransId" value="${true}" />
	</c:when>
	<c:otherwise>
		<c:set var="hasTransId" value="${false}" />
	</c:otherwise>
</c:choose>

<%-- MAIN METHOD --%>
<c:choose>
	<%-- PRESERVE TEST --%>
	<c:when test="${ (hasTransId && not empty id_handler && id_handler == 'preserve_tranId' ) ||
					(hasTransId && ((empty id_handler and not empty param.action and (param.action == 'amend' || param.action == 'latest' || param.action == 'confirmation')) ))}">
		<go:log  source="core:get_transactionid">var="method" value="PRESERVE"</go:log>
		<c:set var="method" value="PRESERVE" />
	</c:when>
	<%-- INSTA FAIL --%>

	<c:when test="${empty applicationService.getVerticalCodeFromPageContext(pageContext) || applicationService.getVerticalCodeFromPageContext(pageContext) == ''}">

		<%-- Check if we have known session data --%>
		<c:set var="dataNodes" value="unknown" />


		<%-- IF WE HAVE A QUOTE TYPE - LOAD IN THE VERTICAL --%>
		<c:set var="method" value="ERROR: NO VERTICAL" />

		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="core:get_transaction_id VERTICAL EMPTY" />
			<c:param name="description" value="${error}" />
			<c:param name="data" value="hasTransId=${hasTransId} transactionId=${transactionId} id_handler=${id_handler} quoteType=${quoteType} emailAddress=${emailAddress} ipAddress=${pageContext.request.remoteAddr} serverAddress=${serverIp} dataNodes=${dataNodes} " />
		</c:import>

		<go:setData dataVar="data" value="" xpath="current/transactionId" />
	</c:when>

	<%-- INCREMENT TRANS ID --%>
	<c:when test="${hasTransId && not empty id_handler && id_handler == 'increment_tranId'}">

		<c:set var="requestedTransaction" value="${data.current.transactionId}" />
		<go:setData dataVar="data" value="${requestedTransaction}" xpath="current/previousTransactionId" />

		<%-- Start by getting the transaction in question --%>
		<sql:setDataSource dataSource="jdbc/aggregator"/>

		<sql:query var="getTransaction" dataSource="jdbc/aggregator">
			SELECT `ProductType`,`EmailAddress`,`styleCodeId`,`styleCode`,`rootId`
			FROM aggregator.transaction_header
			WHERE TransactionId = ?;
			<sql:param value="${requestedTransaction}" />
		</sql:query>

		<%-- Proceed if Operator doesn't own the quote - we need to duplicate it and assign to the operator --%>
		<c:if test="${not empty getTransaction and getTransaction.rowCount > 0}">

			<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
			<c:set var="sessionId" 		value="${pageContext.session.id}" />
			<c:set var="status" 		value="" />

			<go:log source="core:get_transactionid" >[with id_handler] Found transactionId in db. IDs for Get TransactionID = ipAddress: ${pageContext.request.remoteAddr}, sessionID = ${pageContext.session.id}</go:log>

			<c:catch var="error">
				<%-- New Transaction Header using the older values to help populate--%>
				<sql:update dataSource="jdbc/aggregator">
						INSERT INTO aggregator.transaction_header
						(TransactionId,rootId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCodeId, styleCode, advertKey,sessionId,status)
						values (
							0,?,?,?,?,?,CURRENT_DATE,CURRENT_TIME,?,?,0,?,?
						);
						<sql:param value="${getTransaction.rows[0].rootId}" />
						<sql:param value="${requestedTransaction}" />
						<sql:param value="${getTransaction.rows[0].ProductType}" />
					<c:choose>
						<c:when test="${not empty emailAddress}">
							<sql:param value="${emailAddress}" />
						</c:when>
						<c:otherwise>
							<sql:param value="${getTransaction.rows[0].EmailAddress}" />
						</c:otherwise>
					</c:choose>
					<sql:param value="${ipAddress}" />
					<sql:param value="${getTransaction.rows[0].styleCodeId}" />
					<sql:param value="${getTransaction.rows[0].styleCode}" />
					<sql:param value="${sessionId}" />
					<sql:param value="${status}" />
				</sql:update>

				<%-- Retrieve the last result --%>

				<c:set var="rootId" value="${getTransaction.rows[0].rootId}"/>
				<sql:query var="results">
					SELECT transactionID
					FROM aggregator.transaction_header
					WHERE rootId = ?
					ORDER BY transactionID DESC
					LIMIT 1
					<sql:param value="${rootId}" />
				</sql:query>
				<c:choose>
					<c:when test="${results.rowCount == 0 || empty results.rows[0].transactionID}">
						<c:set var="method" value="ERROR: INCREMENT" />
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="property" value="${styleCodeId}" />
							<c:param name="transactionId" value="${transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="core:get_transaction_id NEW" />
							<c:param name="description" value="${error}" />
							<c:param name="data" value="hasTransId=${hasTransId} transactionId=${transactionId} id_handler=${id_handler} quoteType=${quoteType}" />
						</c:import>
						<go:setData dataVar="data" value="" xpath="current/transactionId" />
					</c:when>
					<c:otherwise>
						<c:set var="tranId" value="${results.rows[0].transactionID}" />
						<%-- Duplicate the transaction details --%>
						<sql:update>
							INSERT INTO aggregator.transaction_details
							SELECT ${tranId} as transactionId, sequenceNo, xpath, textValue, numericValue, dateValue
							FROM aggregator.transaction_details
							WHERE transactionId = ?;
							<sql:param value="${requestedTransaction}" />
						</sql:update>

						<%-- Finally we'll replace the requestedTransaction var with the new ID --%>
						<go:setData dataVar="data" value="${tranId}" xpath="current/transactionId" />
						<go:setData dataVar="data" value="${rootId}" xpath="current/rootId" />
						<c:set var="method" value="INCREMENT" />
						<go:log  source="core:get_transactionid">CHOSEN TRANS ID = ${tranId}, DATA.CURRENT.TRANID = ${data.current.transactionId}</go:log>
					</c:otherwise>
				</c:choose>
			</c:catch>
			<%-- ERROR CHECK --%>
			<c:choose>
				<c:when test="${not empty error}">
					<go:log  source="core:get_transactionid" level="ERROR">${error}</go:log>
					<c:set var="method" value="ERROR: INCREMENT" />

					<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
						<c:param name="transactionId" value="${transactionId}" />
						<c:param name="page" value="${pageContext.request.servletPath}" />
						<c:param name="message" value="core:get_transaction_id INCREMENT" />
						<c:param name="description" value="${error}" />
						<c:param name="data" value="hasTransId=${hasTransId} transactionId=${transactionId} id_handler=${id_handler} quoteType=${quoteType}" />
					</c:import>

					<go:setData dataVar="data" value="" xpath="current/transactionId" />
				</c:when>
				<c:otherwise>
					<go:setData dataVar="data" value="${tranId}" xpath="current/transactionId" />
					<c:if test="${fn:toLowerCase(quoteType) == 'car' || fn:toLowerCase(data.current.vertical) == 'car'}">
						<c:set var="method"><core:save_transaction_to_disc previousTransactionId="${requestedTransaction}" /></c:set>
					</c:if>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:when>
	<%-- NEW TRANS ID --%>
	<c:otherwise>
		<%-- Remove any previous save content for the new quote --%>

		<c:set var="previousRootId" value="${data.current.rootId}" />


		<go:log source="core:get_transactionid">Delete data bucket and create new transaction id. PreviousRootId: '${previousRootId}'</go:log>

		<go:setData dataVar="data" xpath="save" value="*DELETE" />

		<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
		<c:set var="sessionId" 		value="${pageContext.session.id}" />
		<c:set var="status" 		value="" />
		<c:catch var="error">
			<sql:update dataSource="jdbc/aggregator">
				INSERT INTO aggregator.transaction_header
				(TransactionId,rootId,PreviousId,ProductType,emailAddress,ipAddress,startDate,startTime,styleCodeId,styleCode,advertKey,sessionId,status,prevRootId)
				values (
					0,'0','0',?,?,?,CURRENT_DATE,CURRENT_TIME,?,?,0,?,?,?
				);
				<sql:param value="${fn:toUpperCase(quoteType)}" />
				<c:choose>
					<c:when test="${not empty emailAddress}">
						<sql:param value="${emailAddress}" />
					</c:when>
					<c:otherwise>
						<sql:param value=" " />
					</c:otherwise>
					</c:choose>
				<sql:param value="${ipAddress}" />
				<sql:param value="${styleCodeId}" />
				<sql:param value="${styleCode}" />
				<sql:param value="${sessionId}" />
				<sql:param value="${status}" />
				<sql:param value="${previousRootId}" />
			</sql:update>

			<%-- Retrieve the last result to update rootId with the transaction id --%>
			<sql:query var="results" dataSource="jdbc/aggregator">
				SELECT transactionID
				FROM aggregator.transaction_header
				WHERE sessionid = ?
				ORDER BY transactionID DESC
				LIMIT 1
				<sql:param value="${sessionId}" />
			</sql:query>
			<c:choose>
				<c:when test="${results.rowCount == 0 || empty results.rows[0].transactionID}">
					<c:set var="method" value="ERROR: NEW" />
					<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
						<c:param name="transactionId" value="${transactionId}" />
						<c:param name="page" value="${pageContext.request.servletPath}" />
						<c:param name="message" value="core:get_transaction_id NEW" />
						<c:param name="description" value="${error}" />
						<c:param name="data" value="hasTransId=${hasTransId} transactionId=${transactionId} id_handler=${id_handler} quoteType=${quoteType}" />
					</c:import>
					<go:setData dataVar="data" value="" xpath="current/transactionId" />
				</c:when>
				<c:otherwise>
					<c:set var="tranId" value="${results.rows[0].transactionID}" />
					<sql:update dataSource="jdbc/aggregator">
						UPDATE aggregator.transaction_header
						SET rootId = ?
						WHERE TransactionId = ?;
						<sql:param value="${tranId}" />
						<sql:param value="${tranId}" />
					</sql:update>
					<go:setData dataVar="data" value="${tranId}" xpath="current/transactionId" />
					<go:setData dataVar="data" value="${tranId}" xpath="current/rootId" />
				</c:otherwise>
			</c:choose>
		</c:catch>

		<%-- ERROR CHECK --%>
		<c:choose>
			<c:when test="${not empty error}">
				<c:set var="method" value="ERROR: NEW" />

				<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
					<c:param name="transactionId" value="${transactionId}" />
					<c:param name="page" value="${pageContext.request.servletPath}" />
					<c:param name="message" value="core:get_transaction_id NEW" />
					<c:param name="description" value="${error}" />
					<c:param name="data" value="hasTransId=${hasTransId} transactionId=${transactionId} id_handler=${id_handler} quoteType=${quoteType}" />
				</c:import>

				<go:setData dataVar="data" value="" xpath="current/transactionId" />
			</c:when>
			<c:otherwise>
				<c:set var="method" value="NEW" />
				<go:setData dataVar="data" value="${tranId}" xpath="current/transactionId" />
				<c:if test="${fn:toLowerCase(quoteType) == 'car' || fn:toLowerCase(data.current.vertical) == 'car'}">
					<c:set var="ignoreMe">
						<core:save_transaction_to_disc
							previousTransactionId="${data['current/transactionId']}"/>
					</c:set>
				</c:if>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<go:log source="core:get_transactionid">Transaction ID outcome: {"transactionId":"${data.current.transactionId}","rootId":"${data.current.rootId}","Method":"${method}"}</go:log>

{"transactionId":"${data.current.transactionId}","Method":"${method}"}