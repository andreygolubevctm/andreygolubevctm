<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home Loan database updates for confirmation. "%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="confirmationId" required="true" rtexprvalue="true" description="The confirmation id"%>
<%@ attribute name="returnedDataObj" required="true" rtexprvalue="true" description="The confirmation id"%>

<%-- VARIABLES --%>
<c:set var="secretKey" value="kD0axgKXQ5HixuWsJ8-2BA" />
<c:set var="transactionId" value="${data.current.transactionId}" />
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="isValid" value="false" />

<sql:setDataSource dataSource="jdbc/ctm" />

<%-- CHECK IF CONFIRMATION TOUCH ALREADY EXISTS --%>
<c:catch var="error">
	<sql:query var="touchCheck">
		SELECT id FROM ctm.touches
		WHERE transaction_id = ? AND type = 'C'
		LIMIT 1;
		<sql:param value="${transactionId}" />
	</sql:query>
</c:catch>
<c:choose>
	<c:when test="${empty error}">

		<%-- FLAG IF FIRST LOADING OF CONFIRMATION ENTRY PAGE --%>
		<c:set var="hasNoConfirmationTouch">
			<c:choose>
				<c:when test="${touchCheck.rowCount == 0}">${true}</c:when>
				<c:otherwise>${false}</c:otherwise>
			</c:choose>
		</c:set>

		<c:choose>
			<c:when test="${returnedDataObj eq 'repopulate'}">
			<%-- To Re-populate from ctm.confirmations.xmlData as we don't have the data object anymore --%>
				<c:catch var="error">
					<sql:query var="result">
						SELECT XMLdata
							FROM ctm.confirmations AS c
							RIGHT JOIN aggregator.transaction_header AS h
								ON h.TransactionId = c.TransID
							WHERE KeyID = ?
							AND h.styleCodeId = ?
						LIMIT 1
						<sql:param value="${confirmationId}" />
						<sql:param value="${pageSettings.getBrandId()}" />
					</sql:query>
				</c:catch>
				<c:choose>
					<c:when test="${not empty result && empty error}">
						<c:set var="xmlData" value="${result.rows[0]['XMLdata']}" />
						<c:catch var="error">
							<x:parse doc="${xmlData}" var="parsedXml" />
						</c:catch>
						<c:if test="${empty error}">
							<go:setData dataVar="data" xpath="homeloan" xml="${xmlData}" />
							<go:setData dataVar="data" xpath="homeloan/confirmation/confirmationOptIn" value="*DELETE" />
							<c:set var="emailAddress">
								<x:out select="$parsedXml/confirmation/confirmationOptIn/emailAddress" />
							</c:set>
							<go:setData dataVar="data" xpath="confirmationOptIn/emailAddress" value="${emailAddress}" />
							<c:set var="isValid" value="true" />
						</c:if>
					</c:when>
					<c:otherwise>
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="Unable to repopulate data bucket from ctm.confirmations xmlData" />
							<c:param name="description" value="${error}" />
							<c:param name="data" value="confirmationId=${confirmationId},data=${xmlData}" />
						</c:import>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${not empty returnedDataObj && returnedDataObj ne 'repopulate'}">
				<%-- When coming directly from AFG's side --%>
				<%-- DECRYPT THE DATA OBJECT RECEIVED FROM PROVIDER --%>
				<c:catch var="error">
					<c:set var="jsonData">
						<go:AESEncryptDecrypt action="decrypt" key="${secretKey}" content="${returnedDataObj}" />
					</c:set>
					<c:set var="xmlData" value="<data>${go:JSONtoXML(jsonData)}</data>" />
				</c:catch>

				<c:choose>
					<c:when test="${empty error}">

						<%-- PULL VALUES OUT OF XML DATA --%>
						<x:parse doc="${xmlData}" var="parsedXml" />
						<c:set var="firstName">
							<x:out select="$parsedXml/data/firstName" />
						</c:set>
						<c:set var="emailAddress">
							<x:out select="$parsedXml/data/emailAddress" />
						</c:set>
						<c:set var="flexOpportunityId">
							<x:out select="$parsedXml/data/flexOpportunityId" />
						</c:set>

						<c:choose>
							<c:when test="${not empty flexOpportunityId}">

								<%-- If there's an empty email address from AFG, check if one
									Was entered on step 1 in CTM's form. --%>
								<c:if test="${empty emailAddress}">
									<c:catch var="error">
										<sql:query var="result">
											SELECT `textValue`
												FROM aggregator.transaction_details
												WHERE transactionId = ?
												AND xpath = 'homeloan/contact/email'
											<sql:param value="${transactionId}" />
											<sql:param value="${pageSettings.getBrandId()}" />
										</sql:query>
									</c:catch>
									<c:if test="${not empty result && empty error}">
										<c:set var="emailAddress" value="${result.rows[0]['textValue']}" />
									</c:if>
								</c:if>
								<%-- Can't figure out how to store 2 root nodes and be able to parse it in the repopulate phase... --%>
								<%-- Store emailAddress twice so we know what AFG returned, and what was opted in with --%>
								<c:set var="xmlData">
									<confirmation>
										<firstName>${firstName}</firstName>
										<emailAddress>${emailAddress}</emailAddress>
										<flexOpportunityId>${flexOpportunityId}</flexOpportunityId>
										<confirmationOptIn>
											<emailAddress>${emailAddress}</emailAddress>
										</confirmationOptIn>
									</confirmation>
								</c:set>
								<go:setData dataVar="data" xpath="homeloan" xml="${xmlData}" />
								<%-- This particular xPath isn't needed anymore --%>
								<go:setData dataVar="data" xpath="homeloan/confirmation/confirmationOptIn" value="*DELETE" />

								<go:setData dataVar="data" xpath="confirmationOptIn/emailAddress" value="${emailAddress}" />
								<go:setData dataVar="data" xpath="homeloan/confirmation/flexOpportunityId" value="${flexOpportunityId}" />

								<c:if test="${hasNoConfirmationTouch eq true}">

									<%-- ADD CONFIRMATION TOUCH EVENT --%>
									<agg:write_touch transaction_id="${transactionId}" touch="C"></agg:write_touch>

									<%-- UPDATE CONFIRMATION RECORD WITH THE XMLDATA --%>
									<c:catch var="error">
										<sql:update>
											UPDATE ctm.confirmations SET XMLdata = ?
											WHERE TransID = ? AND KeyID = ? AND XMLdata  = 'none'
											LIMIT 1;
											<sql:param value="${xmlData}" />
											<sql:param value="${transactionId}" />
											<sql:param value="${confirmationId}" />
										</sql:update>
									</c:catch>

									<c:choose>
										<c:when test="${not empty error}">
											<go:log level="ERROR" source="homeloan:confirmation_update">Failed Updating Confirmations Table for ${confirmationId} with error: ${error}</go:log>
										</c:when>
										<c:otherwise>
											<go:log level="INFO" source="homeloan:confirmation_update">UPDATED: ${flexOpportunityId}</go:log>
										</c:otherwise>
									</c:choose>

									<sql:transaction>
										<c:catch var="error">
											<sql:query var="lastSN">
												SELECT Max(sequenceNo) AS lastSN
												FROM aggregator.transaction_details
												WHERE transactionId = ?;
												<sql:param>${transactionId}</sql:param>
											</sql:query>
										</c:catch>

										<c:if test="${empty error && lastSN.rowCount > 0}">
											<sql:update>
												INSERT INTO aggregator.transaction_details
												(transactionId,sequenceNo,xpath,textValue)
												VALUES (?, ?, ?, ?);
												<sql:param>${transactionId}</sql:param>
												<sql:param>${lastSN.rows[0].lastSN + 1}</sql:param>
												<sql:param>homeloan/flexOpportunityId</sql:param>
												<sql:param>${flexOpportunityId}</sql:param>
											</sql:update>
										</c:if>
									</sql:transaction>

									<c:choose>
										<c:when test="${not empty error}">
											<go:log level="ERROR" source="homeloan:confirmation_update">Failed Updating Transaction Details Table for ${transactionId} with error: ${error}</go:log>
										</c:when>
										<c:otherwise>
											<go:log level="INFO" source="homeloan:confirmation_update">UPDATED TRANSACTION: ${flexOpportunityId}</go:log>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:set var="isValid" value="true" />
							</c:when>
							<c:otherwise>
								<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
									<c:param name="transactionId" value="${transactionId}" />
									<c:param name="page" value="${pageContext.request.servletPath}" />
									<c:param name="message" value="Flex Opporunity ID property missing in the data param received from AFG." />
									<c:param name="description" value="Flex Opporunity ID property missing in the data param received from AFG." />
									<c:param name="data" value="confirmationId=${confirmationId},jsondata:${jsonData},data=${returnedDataObj}" />
								</c:import>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
							<c:param name="transactionId" value="${transactionId}" />
							<c:param name="page" value="${pageContext.request.servletPath}" />
							<c:param name="message" value="Invalid data param received from AFG." />
							<c:param name="description" value="${error}" />
							<c:param name="data" value="confirmationId=${confirmationId},data=${returnedDataObj}" />
						</c:import>
					</c:otherwise>
				</c:choose>

			</c:when>
			<c:otherwise>
				<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
					<c:param name="transactionId" value="${transactionId}" />
					<c:param name="page" value="${pageContext.request.servletPath}" />
					<c:param name="message" value="No data param received from AFG." />
					<c:param name="description" value="No data param received from AFG. ConfirmationID: ${confirmationId}" />
					<c:param name="data" value="confirmationId=${confirmationId}" />
				</c:import>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<go:log level="ERROR" source="homeloan:confirmation_update">Failed Checking Touches ${error}</go:log>
	</c:otherwise>
</c:choose>
${isValid}