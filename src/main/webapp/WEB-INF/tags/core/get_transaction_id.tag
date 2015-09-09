<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="styleCode">${pageSettings.getBrandCode()}</c:set>

<%-- ATTRIBUTES --%>
<%@ attribute name="transactionId"	required="false" rtexprvalue="true"	description="" %>
<%@ attribute name="id_handler"		required="false" rtexprvalue="true"	description="" %>
<%@ attribute name="emailAddress"	required="false" rtexprvalue="true"	description="" %>
<%@ attribute name="quoteType"		required="false" rtexprvalue="true"	description="The vertical this quote is associated with" %>

<jsp:useBean id="sessionDataUtils" class="com.ctm.utils.SessionDataUtils" scope="page" />

<c:set var="serverIp"><%
	String ip = request.getLocalAddr();
	try {
		java.net.InetAddress address = java.net.InetAddress.getLocalHost();
		ip = address.getHostAddress();
	}
	catch (Exception e) {}
%><%= ip %></c:set>

<%-- Fetch and store the transaction id --%>

<%-- Current TransId Test --%>
<c:choose>
	<c:when test="${not empty transactionId}">
		<c:set var="hasTransId" value="${true}" />
		${sessionDataUtils.setTransactionId(data,fn:trim(transactionId) )}
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
		<c:set var="method" value="PRESERVE" />
	</c:when>
	<%-- INSTA FAIL --%>

	<c:when test="${empty applicationService.getVerticalCodeFromRequest(pageContext.getRequest()) || applicationService.getVerticalCodeFromRequest(pageContext.getRequest()) == ''}">

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

		${sessionDataUtils.setTransactionId(data, '' )}
	</c:when>

	<%-- INCREMENT TRANS ID --%>
	<c:when test="${hasTransId && not empty id_handler && id_handler == 'increment_tranId'}">

		<c:set var="requestedTransaction" value="${data.current.transactionId}" />
		<go:setData dataVar="data" value="${requestedTransaction}" xpath="current/previousTransactionId" />

		<%-- Start by getting the transaction in question --%>
		<sql:setDataSource dataSource="jdbc/ctm"/>

		<sql:query var="getTransaction" dataSource="jdbc/ctm">
			SELECT `ProductType`,`EmailAddress`,`styleCodeId`,`styleCode`,`rootId`
			FROM aggregator.transaction_header
			WHERE TransactionId = ? AND styleCodeId = ?
			UNION ALL
			SELECT vm.verticalCode AS productType, em.emailAddress AS EmailAddress,th2c.`styleCodeId`,sc.styleCode,`rootId`
			FROM aggregator.transaction_header2_cold th2c
			JOIN ctm.vertical_master vm USING(verticalId)
			JOIN ctm.stylecodes sc USING(styleCodeId)
			LEFT JOIN aggregator.transaction_emails te USING(transactionId)
			LEFT JOIN aggregator.email_master em ON em.styleCodeId = th2c.styleCodeId AND em.emailId = te.emailId
			WHERE th2c.TransactionId = ? AND th2c.styleCodeId = ?
			LIMIT 1;
			<sql:param value="${requestedTransaction}" />
			<sql:param value="${styleCodeId}" />
			<sql:param value="${requestedTransaction}" />
			<sql:param value="${styleCodeId}" />
		</sql:query>

		<%-- Proceed if Operator doesn't own the quote - we need to duplicate it and assign to the operator --%>
		<c:choose>
			<c:when test="${not empty getTransaction and getTransaction.rowCount > 0}">

				<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
				<c:set var="sessionId" 		value="${pageContext.session.id}" />
				<c:set var="status" 		value="" />

				<go:log source="core:get_transactionid" >[with id_handler] Found transactionId in db. IDs for Get TransactionID = ipAddress: ${pageContext.request.remoteAddr}, sessionID = ${pageContext.session.id}</go:log>

				<c:catch var="error">
					<%-- New Transaction Header using the older values to help populate--%>
					<sql:update dataSource="jdbc/ctm">
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
							${sessionDataUtils.setTransactionId(data, '' )}
						</c:when>
						<c:otherwise>
							<c:set var="tranId" value="${results.rows[0].transactionID}" />
							<%-- Duplicate the transaction details --%>
							<sql:update>
								INSERT INTO aggregator.transaction_details
								SELECT ${tranId} as transactionId, sequenceNo, xpath, textValue, numericValue, dateValue
								FROM aggregator.transaction_details
								WHERE transactionId = ?
								UNION ALL
								SELECT ${tranId} as transactionId, (@sequence := @sequence + 1) AS sequenceNo, tf.fieldCode AS xpath, td2c.textValue, 0.00, CURDATE()
								FROM aggregator.transaction_details2_cold td2c
								JOIN aggregator.transaction_fields tf USING(fieldId)
								JOIN (SELECT @sequence := 0) AS sequencer
								WHERE transactionId = ?;
								<sql:param value="${requestedTransaction}" />
								<sql:param value="${requestedTransaction}" />
							</sql:update>

							<%-- Finally we'll replace the requestedTransaction var with the new ID --%>
							${sessionDataUtils.setTransactionId(data, tranId )}
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

						${sessionDataUtils.setTransactionId(data, '' )}
					</c:when>
					<c:otherwise>
						${sessionDataUtils.setTransactionId(data, tranId )}
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<go:log source="core:get_transactionid">TRANSACTION ID NOT FOUND: '${requestedTransaction}' EITHER THE TRANSACTION DOES NOT EXIST, OR NOT LINKED WITH THIS BRAND: '${styleCodeId}'</go:log>
				<go:setData dataVar="data" xpath="current" value="*DELETE" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<%-- NEW TRANS ID --%>
	<c:otherwise>
		<%-- Remove any previous save content for the new quote --%>

		<c:set var="previousRootId" value="${data.current.rootId}" />

		<go:setData dataVar="data" xpath="save" value="*DELETE" />

		<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
		<c:set var="sessionId" 		value="${pageContext.session.id}" />
		<c:set var="status" 		value="" />
		<c:catch var="error">
			<sql:update dataSource="jdbc/ctm">
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
			<sql:query var="results" dataSource="jdbc/ctm">
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
					${sessionDataUtils.setTransactionId(data, '' )}
				</c:when>
				<c:otherwise>
					<c:set var="tranId" value="${results.rows[0].transactionID}" />
					<sql:update dataSource="jdbc/ctm">
						UPDATE aggregator.transaction_header
						SET rootId = ?
						WHERE TransactionId = ?;
						<sql:param value="${tranId}" />
						<sql:param value="${tranId}" />
					</sql:update>
					${sessionDataUtils.setTransactionId(data, tranId )}
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

				${sessionDataUtils.setTransactionId(data, '' )}
			</c:when>
			<c:otherwise>
				<c:set var="method" value="NEW" />
				${sessionDataUtils.setTransactionId(data, tranId )}
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<go:log source="core:get_transactionid">Transaction ID outcome: {"transactionId":"${data.current.transactionId}","rootId":"${data.current.rootId}","Method":"${method}"}</go:log>

{"transactionId":"${data.current.transactionId}","rootId":"${data.current.rootId}","Method":"${method}"}