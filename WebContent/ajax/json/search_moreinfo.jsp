<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<go:setData dataVar="data" xpath="moreinfo" value="*DELETE" />

<go:log>More Info: ${param}</go:log>

<c:set var="errorPool" value="" /> 

<%-- Store flag as to whether Simples Operator or Other --%>
<c:set var="isOperator"><c:if test="${not empty data['login/user/uid']}">${data['login/user/uid']}</c:if></c:set>
<go:log>isOperator: ${isOperator}</go:log>	

<c:choose>
	<c:when test="${empty isOperator}">
		<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
		<c:set var="errorPool">${errorPool}{"error":"login"}</c:set>
	</c:when>
	<c:otherwise>
		<c:choose>
			<%-- Fail if no search terms provided --%>
			<c:when test="${empty param.transactionid}">
				<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
				<c:set var="errorPool">${errorPool}{"error":"No transactionId provided."}</c:set>
			</c:when>
			<c:otherwise>
		
				<%-- Execute the search and locate relevant transactions --%>	
				<c:catch var="error">
					<sql:transaction>
						<%-- Get confirmation ID --%>
						<sql:query var="confirmation">
							SELECT KeyID FROM ctm.confirmations
							WHERE TransID = ?
						<sql:param value="${param.transactionid}" />
					</sql:query>

						<%-- Retrieve the latest activity on this, and related, transactions --%>
						<sql:query var="touches">

							SELECT DISTINCT t2.transaction_id, t2.date, t2.time,
							t2.operator_id, t2.type, CONCAT(deets2.textValue, ' ', deets.textValue) AS product

							FROM ctm.touches t

								INNER JOIN aggregator.transaction_header AS th
									ON th.transactionid  = t.transaction_id

								INNER JOIN aggregator.transaction_header AS th2
									ON th.rootId = th2.rootId

								INNER JOIN ctm.touches AS t2
								ON t2.transaction_id = th2.transactionid
								AND t2.type IN ('N', 'R', 'L', 'A', 'P', 'F', 'C', 'S')

								LEFT JOIN aggregator.transaction_details AS deets
								ON deets.transactionId = t2.transaction_id
								AND deets.xpath = 'health/application/productTitle'

								LEFT JOIN aggregator.transaction_details AS deets2 ON deets2.transactionId = t2.transaction_id
								AND deets2.xpath = 'health/application/provider'

								WHERE t.transaction_id  = ?
								ORDER BY t2.id DESC, t2.date DESC, t2.time DESC LIMIT 50
							<sql:param value="${param.transactionid}" />
						</sql:query>
					</sql:transaction>
				</c:catch>
				
				<%-- Test for DB issue and handle - otherwise move on --%>
				<c:choose>
					<c:when test="${not empty error}">
						<go:log level="ERROR" error="${error}" >${error}</go:log>
						<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
						<c:set var="errorPool">${errorPool}{"error":"A database error occurred while retrieving the quote."}</c:set>
					</c:when>
					<c:otherwise>
						<%-- Inject base quote details the quote --%>
						<c:set var="quoteXml">
							<quote>
								<%-- Process confirmation --%>
							<c:choose>
									<c:when test="${confirmation.rowCount > 0}">
										<confirmationId><c:out value="${confirmation.rows[0].KeyID}" /></confirmationId>
									</c:when>
									<c:otherwise><confirmationId /></c:otherwise>
							</c:choose>

								<%-- Process touches results --%>
								<c:if test="${touches.rowCount > 0}">
									<touches>
										<c:forEach var="rr" items="${touches.rows}" varStatus="status">
											<touch>
												<id><c:out value="${rr.transaction_id}" /></id>
												<datetime><c:out value="${rr.date} ${rr.time}" /></datetime>
												<operator><c:out value="${rr.operator_id}" /></operator>
												<type>
													<c:choose>
														<c:when test="${rr.type eq 'N'}">New Quote</c:when>
														<c:when test="${rr.type eq 'R'}">Price Presentation</c:when>
														<c:when test="${rr.type eq 'A'}">Apply</c:when>
														<c:when test="${rr.type eq 'P'}">Submit</c:when>
														<c:when test="${rr.type eq 'F'}">Join failed</c:when>
														<c:when test="${rr.type eq 'C'}">Policy sold: <c:out value="${rr.product}" /></c:when>
														<c:when test="${rr.type eq 'L'}">Load quote</c:when>
														<c:when test="${rr.type eq 'S'}">Saved quote</c:when>
													</c:choose>
												</type>
											</touch>
										</c:forEach>
									</touches>
								</c:if>
							</quote>
						</c:set>

						<go:setData dataVar="data" xpath="moreinfo" xml="${quoteXml}" />
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>	
	</c:otherwise>
</c:choose>

<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		${go:XMLtoJSON(go:getEscapedXml(data['moreinfo/quote']))}
		<go:setData dataVar="data" xpath="moreinfo" value="*DELETE" />	
	</c:when>
	<c:otherwise>
		{errors:[${errorPool}]}
	</c:otherwise>
</c:choose>