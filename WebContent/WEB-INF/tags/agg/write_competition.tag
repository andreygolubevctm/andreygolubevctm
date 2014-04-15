<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	write_competition inserts a new competition entry to the competition_master table and
	inserts entry properties to the competition_data table.

	Returns the outcome of the entry as a boolean
--%>

<%@ attribute name="competition_id"	required="true"	 rtexprvalue="true"	 description="ID of the competition" %>
<%@ attribute name="email_id"		required="true"	 rtexprvalue="true"	 description="The entrants emailId" %>
<%@ attribute name="items" 			required="true"  rtexprvalue="true"  description="comma seperated list of values in propertyId=value format" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Get the next entry_id to use --%>
<c:set var="entry_id">
	<c:catch var="error">
		<sql:transaction>
			<sql:update>
				INSERT INTO ctm.competition_master
				(competition_id, email_id)
				VALUES (?,?);
				<sql:param>${competition_id}</sql:param>
				<sql:param>${email_id}</sql:param>
			</sql:update>
			<sql:query var="entry">
				SELECT MAX(entry_Id) AS id
				FROM ctm.competition_master;
			</sql:query>
		</sql:transaction>
	</c:catch>
	<c:choose>
		<c:when test="${not empty error}">
			<go:log level="ERROR" error="${error}">Error adding to competition_master: ${error}</go:log>
			<c:out value="0" />
		</c:when>
		<c:when test="${not empty entry and entry.rowCount > 0}">
			<c:out value="${entry.rows[0].id}" />
		</c:when>
		<c:otherwise>
			<go:log  level="ERROR">Failed to retrieve the entry ID.</go:log>
			<c:out value="0" />
		</c:otherwise>
	</c:choose>
</c:set>

<c:choose>
	<c:when test="${entry_id > 0}">
		<%-- Write entry to DB --%>
		<c:forTokens items="${items}" delims="::" var="itemValue">
			<c:set var="propertyId" value="${fn:substringBefore(itemValue,'=')}" />
			<c:set var="value" value="${fn:substringAfter(itemValue,'=')}" />

			<c:if test="${not empty propertyId}">
				<sql:update>
					INSERT INTO ctm.competition_data
					(entry_id, property_id, value)
					VALUES (?,?,?)
					ON DUPLICATE KEY UPDATE
						value = ?;
					<sql:param value="${entry_id}" />
					<sql:param value="${propertyId}" />
					<sql:param value="${value}" />
					<sql:param value="${value}" />
				</sql:update>
			</c:if>
		</c:forTokens>
		<c:out value="${true}" />
	</c:when>
	<c:otherwise>
		<c:out value="${false}" />
	</c:otherwise>
</c:choose>