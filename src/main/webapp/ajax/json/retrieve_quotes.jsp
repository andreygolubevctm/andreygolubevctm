<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.retrieve_quotes')}" />
<settings:setVertical verticalCode="GENERIC" />
<session:getAuthenticated />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<%--
	retrieve_quotes.jsp

	Calls NTAGGTPQ to retrieve a list of previous quotes completed by the client as a JSON object.
	If no quotes are available or the password is incorrect, errors are returned in the JSON object

	@param email - The client's email address
	@param password - The client's password as salted sha1

--%>
<c:set var="validCredentials" value="${not empty authenticatedData.userData && not empty authenticatedData.userData.authentication && authenticatedData.userData.authentication.validCredentials}" />
<c:set var="maxLoginAttempts" value="${pageSettings.getSettingAsInt('maxLoginAttempts')}" />
<c:set var="loginAttempts"><security:log_audit identity="${param.login_email}" result="" action="" method="loginattempts"></security:log_audit></c:set>
<c:choose>
	<c:when test="${loginAttempts >= maxLoginAttempts}">
		[{"error":"exceeded-attempts"}]
	</c:when>
	<c:otherwise>

	<c:if test="${!validCredentials}">
			${logger.info('have not validated credentials authenticating. {}', log:kv('email',param.login_email))}
			<c:set var="password"><go:HmacSHA256 username="${param.login_email}" password="${param.login_password}" brand="${pageSettings.getBrandCode()}" /></c:set>
			${logger.debug('have not validated credentials. {},{}', log:kv('password',password), log:kv('email',param.login_email))}
			<security:authentication
				emailAddress="${param.login_email}"
				password="${password}"
				hashedEmail="${param.hashedEmail}"
				/>
			<go:setData dataVar="authenticatedData" xpath="userData/authentication/validCredentials" value="${userData.validCredentials}" />
			<go:setData dataVar="authenticatedData" xpath="userData/authentication/emailAddress" value="${userData.emailAddress}" />
			<go:setData dataVar="authenticatedData" xpath="userData/emailAddress" value="${userData.emailAddress}" />
			
			<c:set var="validCredentials" value="${userData.validCredentials}" />
	</c:if>
	${logger.info('About to retrieve quote {},{}', log:kv('validCredentials',validCredentials), log:kv('email',param.login_email))}
	<c:choose>
		<c:when test="${validCredentials}">
			<c:set var="emailAddress" value="${authenticatedData.userData.authentication.emailAddress}" />
			${logger.info('login of successful. {},{}', log:kv('loginAttempts',loginAttempts ), log:kv('email',emailAddress))}
			<c:set var="password"><go:HmacSHA256 username="${authenticatedData.userData.authentication.emailAddress}" password="${authenticatedData.userData.authentication.password}" brand="${pageSettings.getBrandCode()}" /></c:set>
			<sql:setDataSource dataSource="${datasource:getDataSource()}" />
			<go:setData dataVar="authenticatedData" xpath="tmp" value="*DELETE" />

			<%-- Load in quotes from MySQL --%>
			<%-- Find the latest transactionIds for the user.  --%>
			<sql:query var="transactions">
				SELECT * FROM
				(
					(SELECT DISTINCT th.TransactionId AS id, th.ProductType AS productType,
							th.EmailAddress AS email, DATE(th.StartDate) AS quoteDate, TIME(th.StartTime) AS quoteTime,
							COALESCE(t1.type,t2.type,1) AS editable,
							COALESCE(MAX(th2.transactionid),th.TransactionId) AS latestID,
							td.textValue as pendingID
						FROM aggregator.transaction_header As th
						INNER JOIN ctm.touches AS tch ON tch.transaction_id = th.TransactionId AND tch.type = 'S'
						LEFT JOIN ctm.touches t1 ON th.TransactionId = t1.transaction_id AND t1.type = 'C'
						LEFT JOIN ctm.touches t2 ON th.TransactionId = t2.transaction_id AND t2.type = 'F'
						LEFT JOIN aggregator.transaction_header th2 ON th2.rootId = th.rootId
						LEFT JOIN aggregator.transaction_details td ON th.TransactionId = td.TransactionId AND sequenceNo = -7
						WHERE th.EmailAddress = ?
						AND th.styleCodeId = ?
						GROUP BY id
						ORDER BY th.transactionId DESC
						LIMIT 20
					)
					UNION ALL
					(SELECT te.transactionId AS id,
						(SELECT verticalCode FROM ctm.vertical_master WHERE verticalID = th2c.verticalId) AS productType,
						(SELECT emailAddress FROM aggregator.email_master WHERE emailId = te.emailId) AS email,
						DATE(DATE_FORMAT(th2c.transactionStartDateTime,'%Y-%m-%d')) AS quoteDate,
						TIME(DATE_FORMAT(th2c.transactionStartDateTime,'%T')) AS quoteTime,
						COALESCE(t1.type,t2.type,1) AS editable,
						(SELECT max(transactionId) AS id FROM aggregator.transaction_header
							WHERE rootId = th2c.rootId
							UNION ALL
							SELECT max(transactionId) AS id FROM aggregator.transaction_header2_cold
							WHERE rootId = th2c.rootId
							ORDER BY id DESC
						LIMIT 1) AS latestID,
						td.textValue as pendingID
					FROM aggregator.transaction_emails te
						JOIN aggregator.transaction_header2_cold th2c USING (transactionId)
						INNER JOIN ctm.touches AS tch ON tch.transaction_id = te.TransactionId AND tch.type = 'S'
						LEFT JOIN ctm.touches t1 ON te.TransactionId = t1.transaction_id AND t1.type = 'C'
						LEFT JOIN ctm.touches t2 ON te.TransactionId = t2.transaction_id AND t2.type = 'F'
						LEFT JOIN aggregator.transaction_details2_cold td ON te.TransactionId = td.TransactionId AND fieldID = 861
						LEFT JOIN aggregator.transaction_header2_cold th2 ON th2.rootId = th2c.rootId
					WHERE te.emailId = (SELECT emailId FROM aggregator.email_master
							WHERE styleCodeId = ?
							AND EmailAddress = ?)
						GROUP BY id
						ORDER BY te.transactionId DESC
						LIMIT 20
					)
				) AS savedQuotes
				GROUP BY id
				ORDER BY id DESC
				LIMIT 20
				<sql:param>${emailAddress}</sql:param>
				<sql:param>${styleCodeId}</sql:param>
				<sql:param>${styleCodeId}</sql:param>
				<sql:param>${emailAddress}</sql:param>
			</sql:query>

			<%-- Test for DB issue and handle - otherwise move on --%>
			<c:if test="${(not empty transactions) || (transactions.rowCount > 0) || (not empty transactions.rows[0].id)}">
				${logger.info('mysql transactions. {},{}', log:kv('transactions.rowCount', transactions.rowCount), log:kv('email',emailAddress))}
				<%--Store the transactionIds found in comma delimetered list --%>
				<c:set var="tranIds" value="" />
				<c:forEach var="tranIdRow" items="${transactions.rows}">
					<c:set var="tranId" value="${tranIdRow.id}" />
					<%-- TODO: remove this once we are away from disc --%>
					<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${tranId}]" value="*DELETE" />
					<c:if test="${not empty tranIds}"><c:set var="tranIds" value="${tranIds}," /></c:if>
					<c:set var="tranIds" value="${tranIds}${tranId}" />
					<c:set var="dataPrefix">
						<c:choose>
							<c:when test="${tranIdRow.productType eq 'CAR'}">quote</c:when>
							<c:otherwise>${fn:toLowerCase(tranIdRow.productType)}</c:otherwise>
						</c:choose>
					</c:set>
					${logger.info('Retrieved transaction. {},{},{}' , log:kv('dataPrefix', 'dataPrefix'),log:kv('transactionId',tranId), log:kv('email',emailAddress))}
					<%-- Inject base quote details the quote --%>
					<c:if test="${not empty dataPrefix}">
						<c:set var="quoteXml">
							<${dataPrefix}>
								<id>${tranId}</id>
								<email><c:out value="${tranIdRow.email}" /></email>
								<quoteDate><fmt:formatDate value="${tranIdRow.quoteDate}" pattern="dd/MM/yyyy" type="both"/></quoteDate>
								<quoteTime><fmt:formatDate value="${tranIdRow.quoteTime}" pattern="hh:mm a" type="time"/></quoteTime>
								<quoteType>${dataPrefix}</quoteType>
								<editable><c:out value="${tranIdRow.editable}" /></editable>
								<pendingID><c:out value="${tranIdRow.pendingID}" /></pendingID>
								<fromDisc>false</fromDisc>
							</${dataPrefix}>
						</c:set>
						<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${tranId}]" xml="${quoteXml}" />
					</c:if>
				</c:forEach>
				${logger.debug('Parsed retrieved transaction ids. {},{}' , log:kv('transactionIds',tranIds), log:kv('email',emailAddress))}

				<%-- Get the details for each transaction found --%>
				<c:catch var="error">

					<sql:query var="details">
						SELECT details.transactionId,
						details.xpath,
						header.ProductType AS productType,
						details.textValue
						FROM aggregator.transaction_details AS details
						RIGHT JOIN aggregator.transaction_header AS header
							ON details.transactionId = header.TransactionId
						WHERE details.transactionId IN (${tranIds})
						AND styleCodeId = ?
						UNION ALL
						SELECT details.transactionId,
						tf.fieldCode AS xpath,
						(SELECT verticalCode FROM ctm.vertical_master WHERE verticalID = details.verticalId) AS productType,
						details.textValue
						FROM aggregator.transaction_details2_cold AS details
							RIGHT JOIN aggregator.transaction_header2_cold header USING(transactionId)
							JOIN aggregator.transaction_fields tf USING(fieldId)
						WHERE details.transactionId IN (${tranIds})
						AND header.styleCodeId = ?
						ORDER BY transactionId DESC, xpath ASC;
						<sql:param>${styleCodeId}</sql:param>
						<sql:param>${styleCodeId}</sql:param>
					</sql:query>
				</c:catch>

				<%-- Test for DB issue and handle - otherwise move on --%>
				<c:if test="${empty error}">
					<c:set var="group" value="" />

					<%-- No way to know if we'll have any health results to let's
						just retrieve health cover codes and descriptions --%>

					<%-- Inject all the new quote details found --%>
					<c:forEach var="row" items="${details.rows}" varStatus="status">
						<c:if test="${row.xpath != 'small-env'}">
							<c:if test="${empty group or row.transactionId != group}">
								<c:set var="group" value="${row.transactionId}" />
							</c:if>

							<c:if test="${fn:startsWith(row.xpath, fn:toLowerCase(row.productType)) or (fn:toLowerCase(row.productType) eq 'car' and fn:startsWith(row.xpath, 'quote/'))}">
								<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${row.textValue}" />
								<c:if test="${row.xpath == 'quote/options/commencementDate' }">
									<c:set var="commencementDate" value="${row.textValue}" />
									<%
										Calendar cal = Calendar.getInstance();
										cal.set(Calendar.HOUR_OF_DAY, 0);
																		cal.set(Calendar.MINUTE, 0);
																		cal.set(Calendar.SECOND, 0);
																		cal.set(Calendar.MILLISECOND, 0);

										Date now = cal.getTime();
										Date commencementDate = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH).parse((String)pageContext.getAttribute("commencementDate"));

										if (commencementDate.before(now)) {
											pageContext.setAttribute("inPast" , "Y");
										} else {
											pageContext.setAttribute("inPast" , "N");
										}
									%>
									<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/quote/inPast" value="${pageContext.getAttribute('inPast')}" />
								</c:if>

								<c:if test="${fn:toLowerCase(row.productType) eq 'home' and fn:startsWith(row.xpath, 'home/')}">
									<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${row.textValue}" />
									<c:if test="${row.xpath == 'home/startDate' }">
										<c:set var="startDate" value="${row.textValue}" />
										<%
											Calendar cal = Calendar.getInstance();
											cal.set(Calendar.HOUR_OF_DAY, 0);
																			cal.set(Calendar.MINUTE, 0);
																			cal.set(Calendar.SECOND, 0);
																			cal.set(Calendar.MILLISECOND, 0);

											Date now = cal.getTime();
											Date startDate = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH).parse((String)pageContext.getAttribute("startDate"));

											if (startDate.before(now)) {
												pageContext.setAttribute("inPast" , "Y");
											} else {
												pageContext.setAttribute("inPast" , "N");
											}
										%>
										<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/home/inPast" value="${pageContext.getAttribute('inPast')}" />
									</c:if>
								</c:if>

								<c:if test="${fn:toLowerCase(row.productType) eq 'health'}">
									<c:choose>
										<%-- Replace the health situation code with description --%>
										<c:when test="${row.xpath == 'health/situation/healthSitu'
														or row.xpath == 'health/benefits/healthSitu'
														or row.xpath == 'health/benefits/benefits/healthSitu'}">

											<sql:query var="health_situ">
												SELECT description FROM aggregator.general
												WHERE type = "healthSitu"
												AND code=?
												ORDER BY orderSeq
												LIMIT 1;
												<sql:param>${row.textValue}</sql:param>
											</sql:query>
											<c:if test="${not empty health_situ && health_situ.rowCount > 0}">
												<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${health_situ.rows[0].description}" />
											</c:if>
										</c:when>

										<%-- Replace the health cover codes with description --%>
										<c:when test="${row.xpath == 'health/situation/healthCvr' }">

											<sql:query var="health_cover">
												SELECT description FROM aggregator.general
												WHERE type = "healthCvr"
												AND code=?
												ORDER BY orderSeq
												LIMIT 1;
												<sql:param>${row.textValue}</sql:param>
											</sql:query>
											<c:if test="${not empty health_cover && health_cover.rowCount > 0}">
												<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${health_cover.rows[0].description}" />
											</c:if>
										</c:when>
									</c:choose>
								</c:if>
							</c:if>
						</c:if>
					</c:forEach>

					<c:forEach var="tranIdRow" items="${transactions.rows}">
						<c:set var="tranId" value="${tranIdRow.id}" />
						<c:set var="dataPrefix">
							<c:choose>
								<c:when test="${tranIdRow.productType eq 'CAR'}">quote</c:when>
								<c:otherwise>${fn:toLowerCase(tranIdRow.productType)}</c:otherwise>
							</c:choose>
						</c:set>
						<c:if test="${dataPrefix eq 'life' || dataPrefix eq 'ip'}">
							<c:import url="/WEB-INF/aggregator/life/formatLifeOrIp.xsl" var="lifeorIpXSL" />
							<c:set var="xpath" value="tmp/previousQuotes/result[@id=${tranId}]/${dataPrefix}" />
							<c:set var="tempXml" value="${go:getEscapedXml(authenticatedData[xpath])}" />
							<c:set var="quoteXml">
								<x:transform doc="${tempXml}"  xslt="${lifeorIpXSL}" >
									<x:param name="vertical" value="${dataPrefix}" />
								</x:transform>
							</c:set>
							<go:setData dataVar="authenticatedData" xpath="tmp/previousQuotes/result[@id=${tranId}]/${dataPrefix}" xml="${quoteXml}" />
						</c:if>
					</c:forEach>

					<%-- TODO: Do some xsl magic to order the quotes by date --%>
				</c:if>
			</c:if>
			${logger.debug('RETRIEVE QUOTES COMPILED. {},{},{}', log:kv('tmp',authenticatedData.tmp ), log:kv('tmp/previousQuotes',authenticatedData['tmp/previousQuotes'] ), log:kv('email',emailAddress))}
			<%-- Return the results as json --%>
			${go:XMLtoJSON(go:getEscapedXml(authenticatedData['tmp/previousQuotes']))}
			<go:setData dataVar="authenticatedData" xpath="tmp" value="*DELETE" />

		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${loginAttempts < maxLoginAttempts}">
					<c:choose>
						<c:when test="${(maxLoginAttempts - loginAttempts) == 1}">
							<c:set var="attemptsMessage" value="You have one (1) more login attempt and then you will be required to reset your password." />
						</c:when>
						<c:otherwise>
							<c:set var="attemptsMessage" value="You have ${maxLoginAttempts - loginAttempts} attempts remaining." />
						</c:otherwise>
					</c:choose>
					[{"error":"The email address or password that you entered was incorrect. ${attemptsMessage}"}]
				</c:when>
			</c:choose>
		</c:otherwise>
	</c:choose>

	</c:otherwise>
</c:choose>