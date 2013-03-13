<%@ tag trimDirectiveWhitespaces="true" %>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Enables the IP to be checked and possibly blocked. Note: Beans may be lost during server calls, so enable a bean data on the IP logging page."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="service" 	required="true"		description="The service name to record data against"%>
<%@ attribute name="ip" 		required="false"	description="Pass in a custom IP address"%>


<%--
=======
PROCESS
=======
  |--get the IP address of user
  |--check if it exists (take the IP end first, and order by this, return one result only)
  |---parse the results (if any)
  |---update the database with conclusion
  |----return the response
  
Note: an individuals IP address in the DB will always over-ride an IP range in the DB.
  
=======
ROLES
======= 
  |- T = Temporary User (general user type)
  |- A = Full over-ride (Admin type user) 
  |- P = Permanently Banned (0 searches allowed)  
  |- E = Editor (Checking, testing type user)
  
 --%>
 
<%-- Pull out the IP Address --%>
<c:if test="${empty ip}">
	<c:set var="ip" value="${pageContext.request.remoteAddr}" />
</c:if>
  
<c:set var="ipInteger"><field:ip_number ip="${ip}" /></c:set>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Look for a match --%>
<sql:query var="getSQL">
	SELECT * FROM aggregator.ip_address
	WHERE Service = ?
	AND ipStart <= ?
	AND ipEND >= ?
	ORDER BY ipEnd
	LIMIT 1;
	<sql:param value="${service}" />
	<sql:param value="${ipInteger}" />
	<sql:param value="${ipInteger}" />
</sql:query>

<c:choose>
	<c:when test="${empty getSQL}">
		<go:log>EMPTY</go:log>
	</c:when>
	<c:when test="${empty getSQL || getSQL.rowCount == 0}">
		<c:set var="ipStart" value="${ipInteger}" />
		<c:set var="ipEnd" value="${ipInteger}" />
		<c:set var="role" value="T" />
		<c:set var="total" value="${0}" />			
	</c:when>
	<c:otherwise>		
		<c:set var="ipStart" value="${getSQL.rows[0]['ipStart']}" />
		<c:set var="ipEnd" value="${getSQL.rows[0]['ipEnd']}" />
		<c:set var="role" value="${getSQL.rows[0]['Role']}" />
		<c:set var="total" value="${getSQL.rows[0]['Total']}" />	
	</c:otherwise>
</c:choose>

<%-- stability for possible null value --%>
<c:if test="${empty total}">
	<c:set var="total" value="${0}" />
</c:if>


<%-- SQL Update - if duplicate, update the date and total --%>
<sql:update var="postSQL">
	INSERT INTO aggregator.ip_address
  	(ipStart, ipEnd, Date, Service, Role, Total) VALUES
  	(?,?,CURRENT_DATE,?,?,1)
  	ON DUPLICATE KEY UPDATE
  	`Total` = CASE WHEN `DATE` = CURRENT_DATE THEN ? WHEN `DATE` != CURRENT_DATE THEN 1 END,
  	`Date` = CURRENT_DATE;
  	<sql:param value="${ipStart}" />
  	<sql:param value="${ipEnd}" />
  	<sql:param value="${service}" />
  	<sql:param value="${role}" />
  	<sql:param value="${total +1}" />
</sql:update>

<%-- PARSE: the return response --%>
<c:set var="dataURL" value="settings/ip[@idx=${service}]/role[@idx=${role}]" />
<c:set var="limit" value="${data[dataURL]}" />

<%--
<go:log>
	IP: ${ip}
	NUMBER: ${ipInteger}
	SERVICE: ${service}
	ROLE: ${role}
	TOTAL: ${total}
	LIMIT: ${limit}
	
	SETTINGS
	--------
	URL: '${dataURL}'
	TOTAL: ${data[dataURL]}
</go:log>
 --%>


<%-- RESPONSE --%>
<c:choose>
	<c:when test="${total <= limit}">
		<c:set var="result" value="${1}" /> <%-- OK --%>
	</c:when>
	<c:otherwise>
		<c:set var="result" value="${0}" /> <%-- FAIL --%>
	</c:otherwise>
</c:choose>

${result}