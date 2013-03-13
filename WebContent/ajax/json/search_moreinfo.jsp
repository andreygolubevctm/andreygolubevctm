<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
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
					<sql:query var="quote">
						SELECT d.*, h.StartDate AS startDate, h.StartTime AS startTime, h.rootId, h.editable, c.KeyID AS confirmationId,
							(SELECT GROUP_CONCAT(xpath) FROM aggregator.health_transaction_benefits WHERE transactionId=?) AS benefits
						FROM aggregator.health_moreinfo_transaction_details AS d
						LEFT JOIN aggregator.health_search_transaction_header_inc_status AS h
							ON h.TransactionId = d.transactionId
						LEFT JOIN ctm.confirmations AS c
							ON h.editable = 0 AND c.TransID = ?
						WHERE d.transactionId = ?
						LIMIT 1;
						<sql:param value="${param.transactionid}" />
						<sql:param value="${param.transactionid}" />
						<sql:param value="${param.transactionid}" />
					</sql:query>
				</c:catch>
				
				<%-- Test for DB issue and handle - otherwise move on --%>
				<c:choose>
					<c:when test="${not empty error}">
						<go:log>${error}</go:log>
						<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
						<c:set var="errorPool">${errorPool}{"error":"A database error occurred while retrieving the quote."}</c:set>
					</c:when>
					<c:when test="${not empty quote and quote.rowCount > 0}">
					
						<%-- Build the address --%>
						<c:set var="aUnit">
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressUnit}">${quote.rows[0].addressUnit},</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
						<c:set var="aNo">
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressNo}">${quote.rows[0].addressNo}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
						<c:set var="aStreet">
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressStreet}">${quote.rows[0].addressStreet}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
						<c:set var="aSuburb">
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressSuburb}">${quote.rows[0].addressSuburb}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
						<c:set var="aState">
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressState}">${quote.rows[0].addressState}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
						<c:set var="aPostcode">
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressPostcode}">${quote.rows[0].addressPostcode}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:set>
					
						<%-- Inject base quote details the quote --%>
						<c:set var="quoteXml">
							<quote>
								<benefits>${quote.rows[0].benefits}</benefits>
								<id>${quote.rows[0].transactionId}</id>
								<rootid>${quote.rows[0].rootId}</rootid>
								<startDate>${quote.rows[0].startDate}</startDate>
								<startTime>${quote.rows[0].startTime}</startTime>
								<editable>${quote.rows[0].editable}</editable>
								<confirmationId>${quote.rows[0].confirmationId}</confirmationId>
								<cover>
							<c:choose>
								<c:when test="${not empty quote.rows[0].healthCover}">${quote.rows[0].healthCover}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</cover>
								<state>
							<c:choose>
								<c:when test="${not empty quote.rows[0].addressState}">${quote.rows[0].addressState}</c:when>
								<c:when test="${not empty quote.rows[0].quoteState}">${quote.rows[0].quoteState}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</state>
								<primaryName>
							<c:choose>
								<c:when test="${not empty quote.rows[0].appPrimaryName}">${quote.rows[0].appPrimaryName}</c:when>
								<c:when test="${not empty quote.rows[0].quotePrimaryName}">${quote.rows[0].quotePrimaryName}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</primaryName>
								<primaryDOB>
							<c:choose>
								<c:when test="${not empty quote.rows[0].appPrimaryDOB}">${quote.rows[0].appPrimaryDOB}</c:when>
								<c:when test="${not empty quote.rows[0].quotePrimaryDOB}">${quote.rows[0].quotePrimaryDOB}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</primaryDOB>
								<partnerName>
							<c:choose>
								<c:when test="${not empty quote.rows[0].appPartnerName}">${quote.rows[0].appPartnerName}</c:when>
								<c:when test="${not empty quote.rows[0].quotePartnerName}">${quote.rows[0].quotePartnerName}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</partnerName>
								<partnerDOB>
							<c:choose>
								<c:when test="${not empty quote.rows[0].appPartnerDOB}">${quote.rows[0].appPartnerDOB}</c:when>
								<c:when test="${not empty quote.rows[0].quotePartnerDOB}">${quote.rows[0].quotePartnerDOB}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</partnerDOB>
								<phone>
							<c:choose>
								<c:when test="${not empty quote.rows[0].appMobile}">${quote.rows[0].appMobile}</c:when>
								<c:when test="${not empty quote.rows[0].appOther}">${quote.rows[0].appOther}</c:when>
								<c:when test="${not empty quote.rows[0].quotePhone}">${quote.rows[0].quotePhone}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</phone>
								<email>
							<c:choose>
								<c:when test="${not empty quote.rows[0].appMobile}">${quote.rows[0].appEmail}</c:when>
								<c:when test="${not empty quote.rows[0].appOther}">${quote.rows[0].quoteEmail}</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
								</email>
								<address1><c:if test="${not empty aUnit}">${aUnit}<c:out value=" "/></c:if>${aNo}<c:out value=" "/>${aStreet}</address1>
								<address2>${aSuburb}<c:out value=" "/>${aState}<c:out value=" "/>${aPostcode}</address2>
							</quote>
						</c:set>
						<go:setData dataVar="data" xpath="moreinfo" xml="${quoteXml}" />
						
					</c:when>
					<c:otherwise>
						<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
						<c:set var="errorPool">${errorPool}{"error":"Could not find a quote with transaction id: ${param.transactionid}."}</c:set>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>	
	</c:otherwise>
</c:choose>

<%-- Return output as json --%>
<c:choose>
	<c:when test="${empty errorPool}">
		${go:XMLtoJSON(data.xml['moreinfo'])}
		<go:setData dataVar="data" xpath="moreinfo" value="*DELETE" />	
	</c:when>
	<c:otherwise>
		{errors:[${errorPool}]}
	</c:otherwise>
</c:choose>	