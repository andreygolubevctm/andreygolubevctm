<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Load the confirmation page info based on the key passed in the URL"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="token"><c:out value="${param.token}" escapeXml="true" /></c:set>

<%-- Try and find the transaction in the confirmations table first, if it fails, look for a pending one (see further in the code)

<%-- SQL call to query confirmation, make a different one to easily find a confirmation for Call Centre users --%>
<c:choose>
	<c:when test="${empty token}">
		<c:set var="errors" value="No confirmation token was provided" />
	</c:when>
	<c:otherwise>
		<sql:query var="result">
			SELECT h.StyleCodeId,c.XMLdata
			FROM `confirmations` c
                INNER JOIN aggregator.transaction_header h on c.transid = h.transactionid
			WHERE KeyID = ?
			LIMIT 1
			<sql:param value="${token}" />
		</sql:query>
	</c:otherwise>
</c:choose>

<c:choose>
	<%-- check for errors --%>
	<c:when test="${empty result}">
		<c:set var="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<data>
				<status>Error</status>
				<message><c:out value="${errors}" /></message>
			</data>
		</c:set>
	</c:when>
	<%-- success, we found a confirmation --%>
	<c:when test="${result.rowCount ne 0}">
		<c:set var="xmlData">${result.rows[0]['XMLdata']}</c:set>
	</c:when>
	<%-- no confirmation found, let's look for a pending transaction --%>
	<c:otherwise>

		<c:choose>
			<%-- Try and load the pending transaction if the token is formatted properly --%>
			<c:when test="${fn:contains(token, '-')}">

				<c:set var="xmlData"><health:load_confirmation_pending /></c:set>

			</c:when>

			<%-- the token is not formatted properly --%>
			<c:otherwise>

				<c:set var="xmlData">
					<?xml version="1.0" encoding="UTF-8"?>
					<data>
						<status>Error</status>
						<message>The provided token does not seem to be valid</message>
					</data>
				</c:set>

			</c:otherwise>
		</c:choose>

	</c:otherwise>
</c:choose>

${xmlData}