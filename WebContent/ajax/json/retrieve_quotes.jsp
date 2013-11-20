<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	retrieve_quotes.jsp

	Calls NTAGGTPQ to retrieve a list of previous quotes completed by the client as a JSON object.
	If no quotes are available or the password is incorrect, errors are returned in the JSON object

	@param email - The client's email address
	@param password - The client's password

--%>

<c:if test="${empty data.userData || !data.userData.validCredentials}">
	<security:authentication
			emailAddress="${param.email}"
			password="${param.password}"
			hashedEmail="${param.hashedEmail}"
			brand="CTM" />
</c:if>

<c:choose>
	<c:when test="${data.userData.validCredentials}">
<sql:setDataSource dataSource="jdbc/aggregator"/>
		<go:setData dataVar="data" xpath="tmp" value="*DELETE" />

		<%--
			TODO: remove this once we are away from disc

			Calls NTAGGTPQ to retrieve a list of previous quotes completed by the client as a JSON object.
			If no quotes are available or the password is incorrect, errors are returned in the JSON object

			@param email - The client's email address
			@param password - The client's password

		--%>
		<c:catch var="error">
		<c:set var="parm" value="<data><email>${data.userData.emailAddress}</email><password>${data.userData.password}</password></data>" />
		<go:log>DISC PARAMS: ${parm}</go:log>
		<go:call pageId="AGGTPQ" wait="TRUE" xmlVar="${parm}" resultVar="quoteList" mode="P" style="CTM"/>
		<go:setData dataVar="data" xpath="tmp" xml="${quoteList}" />
		<go:log>DISC QUOTELIST: ${quoteList}</go:log>

		<c:if test="${data.tmp.previousQuotes.getClass().name != 'java.lang.String'}">
			<c:set var="quotes" value="${data.tmp.previousQuotes.quote}" />
<c:choose>
				<c:when test="${quotes.getClass().name eq 'com.disc_au.web.go.xml.XmlNode'}">
					<c:set var="quote" value="${quotes}" />

					<fmt:parseNumber var="id" integerOnly="true"
						type="number" value="${quote.getAttribute('id')}" />
					<fmt:parseDate value="${quote.quoteDate}" var="date" pattern="dd.MM.yyyy" type="both" />
					<c:set var="date"><fmt:formatDate value="${date}" pattern="dd/MM/yyyy" type="both"/></c:set>
					<fmt:parseDate value="${quote.quoteTime}" var="time" pattern="HH.mm.ss" type="time" />
					<c:set var="time"><fmt:formatDate value="${time}" pattern="hh:mm a" type="time"/></c:set>

						<c:set var="tempXml" value="${go:getEscapedXml(quote)}" />
					<c:import url="/WEB-INF/aggregator/car/formatFromDisc.xsl" var="carXSL" />
						<c:set var="quoteXml">
							<x:transform doc="${tempXml}" xslt="${carXSL}" >
								<x:param name="time" value="${time}" />
								<x:param name="date" value="${date}" />
								<x:param name="email" value="${data.userData.emailAddress}" />
								<x:param name="id" value="${id}" />
							</x:transform>
					</c:set>
					<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${id}]" xml="${quoteXml}" />
				</c:when>
				<c:otherwise>
					<c:forEach var="quote" items="${quotes}">
						<fmt:parseNumber var="id" integerOnly="true"
								type="number" value="${quote.getAttribute('id')}" />
						<fmt:parseDate value="${quote.quoteDate}" var="date" pattern="dd.MM.yyyy" type="both" />
						<c:set var="date"><fmt:formatDate value="${date}" pattern="dd/MM/yyyy" type="both"/></c:set>
						<fmt:parseDate value="${quote.quoteTime}" var="time" pattern="HH.mm.ss" type="time" />
						<c:set var="time"><fmt:formatDate value="${time}" pattern="hh:mm a" type="time"/></c:set>

							<c:set var="tempXml" value="${go:getEscapedXml(quote)}" />
						<c:import url="/WEB-INF/aggregator/car/formatFromDisc.xsl" var="carXSL" />
						<c:set var="quoteXml">
							<x:transform doc="${tempXml}" xslt="${carXSL}" >
								<x:param name="time" value="${time}" />
								<x:param name="date" value="${date}" />
								<x:param name="email" value="${data.userData.emailAddress}" />
								<x:param name="id" value="${id}" />
							</x:transform>
						</c:set>
						<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${id}]" xml="${quoteXml}" />
					</c:forEach>
				</c:otherwise>
			</c:choose>
			<go:setData dataVar="data" value="*DELETE" xpath="tmp/previousQuotes/quote" />
		</c:if>
		</c:catch>
		<%-- Load in quotes from MySQL --%>

		<%--Find the latest transactionIds for the user. DISC returns 9, so lets return 11 here to make 20 for the frontend --%>
		<sql:query var="transactions">
			SELECT DISTINCT th.TransactionId AS id, th.ProductType AS productType,
				th.EmailAddress AS email, th.StartDate AS quoteDate, th.StartTime AS quoteTime,
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
			GROUP BY id
			ORDER BY th.TransactionId DESC
			LIMIT 11
			<sql:param>${data.userData.emailAddress}</sql:param>
		</sql:query>

		<%-- Test for DB issue and handle - otherwise move on --%>
		<c:if test="${(not empty transactions) || (transactions.rowCount > 0) || (not empty transactions.rows[0].id)}">
			<go:log>mysql transactions: ${transactions.rowCount}</go:log>
			<%--Store the transactionIds found in comma delimetered list --%>
			<c:set var="tranIds" value="" />
			<c:forEach var="tranIdRow" items="${transactions.rows}">
				<c:set var="tranId" value="${tranIdRow.id}" />
				<%-- TODO: remove this once we are away from disc --%>
				<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${tranId}]" value="*DELETE" />
				<c:if test="${not empty tranIds}"><c:set var="tranIds" value="${tranIds}," /></c:if>
				<c:set var="tranIds" value="${tranIds}${tranId}" />
				<c:set var="dataPrefix">
					<c:choose>
						<c:when test="${tranIdRow.productType eq 'CAR'}">quote</c:when>
						<c:otherwise>${fn:toLowerCase(tranIdRow.productType)}</c:otherwise>
					</c:choose>
				</c:set>

				<c:if test="${empty dataPrefix}">
					<go:log>UNKNOWN VERTICAL FOR SAVED QUOTE #### ${tranId}</go:log>
				</c:if>

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
				<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${tranId}]" xml="${quoteXml}" />
				</c:if>
			</c:forEach>

			<go:log>TranIDs: ${tranIds}</go:log>

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
					ORDER BY transactionId DESC, sequenceNo ASC;
				</sql:query>
			</c:catch>

			<%-- Test for DB issue and handle - otherwise move on --%>
			<c:if test="${empty error}">
				<c:set var="group" value="" />

				<%-- No way to know if we'll have any health results to let's
					just retrieve health cover codes and descriptions --%>
				<sql:setDataSource dataSource="jdbc/test"/>

				<%-- Inject all the new quote details found --%>
				<c:forEach var="row" items="${details.rows}" varStatus="status">
					<c:if test="${row.xpath != 'small-env'}">
						<c:if test="${empty group or row.transactionId != group}">
							<c:set var="group" value="${row.transactionId}" />
						</c:if>

						<c:if test="${fn:startsWith(row.xpath, fn:toLowerCase(row.productType)) or (fn:toLowerCase(row.productType) eq 'car' and fn:startsWith(row.xpath, 'quote/'))}">
							<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${row.textValue}" />
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
								<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/quote/inPast" value="${inPast}" />
							</c:if>

							<c:if test="${fn:toLowerCase(row.productType) eq 'health'}">
								<c:choose>
									<%-- Replace the health situation code with description --%>
									<c:when test="${row.xpath == 'health/situation/healthSitu'
													or row.xpath == 'health/benefits/healthSitu'
													or row.xpath == 'health/benefits/benefits/healthSitu'}">

										<sql:query var="health_situ">
											SELECT description FROM test.general
											WHERE type = "healthSitu"
											AND code=?
											LIMIT 1
											<sql:param>${row.textValue}</sql:param>
										</sql:query>
										<c:if test="${not empty health_situ && health_situ.rowCount > 0}">
											<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${health_situ.rows[0].description}" />
										</c:if>
									</c:when>

									<%-- Replace the health cover codes with description --%>
									<c:when test="${row.xpath == 'health/situation/healthCvr' }">

										<sql:query var="health_cover">
											SELECT description FROM test.general
											WHERE type = "healthCvr"
											AND code=?
											LIMIT 1
											<sql:param>${row.textValue}</sql:param>
										</sql:query>
										<c:if test="${not empty health_cover && health_cover.rowCount > 0}">
											<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${row.transactionId}]/${row.xpath}" value="${health_cover.rows[0].description}" />
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
						<c:set var="tempXml" value="${go:getEscapedXml(data[xpath])}" />
						<c:set var="quoteXml">
							<x:transform doc="${tempXml}"  xslt="${lifeorIpXSL}" >
								<x:param name="vertical" value="${dataPrefix}" />
							</x:transform>
						</c:set>
						<go:setData dataVar="data" xpath="tmp/previousQuotes/result[@id=${tranId}]/${dataPrefix}" xml="${quoteXml}" />
					</c:if>
				</c:forEach>

				<%-- TODO: Do some xsl magic to order the quotes by date --%>
			</c:if>
		</c:if>
		<go:log>RETRIEVE QUOTES COMPILED: ${data.tmp}</go:log>

		<%-- <go:log>XML at 2: ${go:getEscapedXml(data['tmp/previousQuotes'])}</go:log> --%>
		<%-- Return the results as json --%>
		${go:XMLtoJSON(go:getEscapedXml(data['tmp/previousQuotes']))}
		<go:setData dataVar="data" xpath="tmp" value="*DELETE" />

	</c:when>
	<c:otherwise>[{"error":"Failed to locate any quotes with those credentials"}]</c:otherwise>
</c:choose>

<go:setData dataVar="data" value="*UNLOCK" xpath="userData" />
<go:setData dataVar="data" xpath="userData/hashedEmail" value="*DELETE" />
<%-- TODO: remove this once we have migrated car away from disc --%>
<go:setData dataVar="data" xpath="userData/password" value="*DELETE" />
<go:setData dataVar="data" value="*LOCK" xpath="userData" />