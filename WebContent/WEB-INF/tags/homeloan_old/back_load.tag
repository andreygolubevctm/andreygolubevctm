<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="qsdata"><c:out value="${param.data}" escapeXml="true" /></c:set>
<c:set var="secret_key" value="kD0axgKXQ5HixuWsJ8-2BA" />

<%-- PROCEED ONLY IF DATA PARAM RECEIVED --%>
<c:if test="${not empty data}">

	<%-- DECRYPT THE DATA OBJECT RECEIVED FROM AFG --%>
	<c:catch var="error">
		<c:set var="jsondata">
			<go:AESEncryptDecrypt action="decrypt" key="${secret_key}" content="${qsdata}" />
		</c:set>
		<c:set var="xmldata" value="<form>${go:JSONtoXML(jsondata)}</form>" />
	</c:catch>

	<c:choose>
		<c:when test="${empty error}">

			<%-- PULL VALUES OUT OF XML DATA --%>
			<x:parse doc="${xmldata}" var="obj" />
			<c:set var="reference_id"><x:out select="$obj/form/referenceId" /></c:set>

			<c:if test="${not empty reference_id}">

				<sql:setDataSource dataSource="jdbc/ctm"/>

				<%-- ATTEMPT TO VERIFY TRANSACTION IN THE CONFIRMATIONS TABLE --%>
				<%-- QUOTES OLDER THAN 2 HOURS CANNOT BE LOADED --%>
				<c:catch var="error">
					<sql:query var="confirmationQuery">
						SELECT c.TransID As transaction_id, h.rootId AS root_id
						FROM ctm.confirmations AS c
						RIGHT JOIN aggregator.transaction_header AS h
							ON h.TransactionId = c.TransID
						WHERE
							h.styleCodeId = ? AND
							h.ProductType = 'homeloan' AND
							c.KeyID = ? AND
							c.Time > DATE_SUB(NOW(), INTERVAL 2 HOUR)
						LIMIT 1;
						<sql:param value="${pageSettings.getBrandId()}" />
						<sql:param value="${reference_id}" />
					</sql:query>
				</c:catch>

				<c:choose>
					<c:when test="${empty error and confirmationQuery.rowCount > 0}">

						<c:set var="transaction_id" value="${confirmationQuery.rows[0].transaction_id}" />
						<c:set var="root_id" value="${confirmationQuery.rows[0].root_id}" />

						<c:catch var="error">

							<sql:setDataSource dataSource="jdbc/ctm"/>

							<%-- ATTEMPT TO LOAD THE TRANSACTION DATA --%>
							<sql:query var="transactionQuery">
								SELECT th.styleCodeId, td.transactionId, xpath, textValue
								FROM aggregator.transaction_details td
								INNER JOIN aggregator.transaction_header th ON td.transactionId = th.transactionId
								WHERE th.transactionId = ?
								ORDER BY sequenceNo ASC;
								<sql:param value="${transaction_id}" />
							</sql:query>
						</c:catch>

						<c:choose>
							<c:when test="${empty error and transactionQuery.rowCount > 0}">

								<%-- ADD THE TRANSACTION DETAILS TO THE SESSION --%>
								<go:setData dataVar="data" value="*DELETE" xpath="homeloan" />
								<c:forEach var="row" items="${transactionQuery.rows}" varStatus="status">
										<go:log>xpath: ${row.xpath}, val: ${row.textValue}</go:log>
										<c:set var="textVal">
											<c:choose>
												<c:when test="${fn:contains(row.textValue,'Please choose')}"></c:when>
												<c:otherwise>${row.textValue}</c:otherwise>
											</c:choose>
										</c:set>
										<go:setData dataVar="data" xpath="${row.xpath}" value="${textVal}" />
								</c:forEach>
								<go:setData dataVar="data" xpath="current/transactionId" value="${transaction_id}" />
								<go:setData dataVar="data" xpath="current/rootId" value="${root_id}" />

								<%-- REDIRECT TO THE PAGE  --%>
								<c:redirect url="${pageSettings.getBaseUrl()}homeloan_quote.jsp?action=load&transactionId=${transaction_id}" />

							</c:when>
							<c:when test="${not empty error}">
								<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
									<c:param name="transactionId" value="${transactionId}" />
									<c:param name="page" value="${pageContext.request.servletPath}" />
									<c:param name="message" value="Error occured attempting to reload a homeloan quote request (back from AFG)." />
									<c:param name="description" value="${error.rootCause}" />
									<c:param name="data" value="transaction_id=${transaction_id}" />
								</c:import>
							</c:when>
							<c:otherwise>
								<error:non_fatal_error origin="homeloan_quote.jsp"
									errorMessage="Invalid homeloan Transaction ID received (${transaction_id}) to reload the quote." errorCode="INVALID_TRANSACTIONID"
								/>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${not empty error}">
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="Error occured attempting to validate the transaction reference for homeloan quote request (back from AFG)." />
							<c:param name="description" value="${error.rootCause}" />
							<c:param name="data" value="reference_id=${reference_id}" />
						</c:import>
					</c:when>
					<c:otherwise>
						<error:non_fatal_error origin="homeloan_quote.jsp"
							errorMessage="Invalid homeloan Reference ID received (${reference_id}) to reload the quote." errorCode="INVALID_CONFIRMATIONID"
						/>
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:when>
		<c:otherwise>
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="Invalid data received to reload a homeloan quote request (back from AFG)." />
				<c:param name="description" value="${error}" />
				<c:param name="data" value="data=${data}" />
			</c:import>
		</c:otherwise>
	</c:choose>
</c:if>