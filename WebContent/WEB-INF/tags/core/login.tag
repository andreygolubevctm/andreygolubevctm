<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="This is the login procedure, which adds the user to the data bucket"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="uid" 		required="true"	rtexprvalue="true"	description="The user id" %>
<%@ attribute name="asim" 		required="false" rtexprvalue="true" description="Attempt to assimilate the uid (true/false)" %>

<%-- Assume anonymous by default --%>
<c:set var="out" value="Not logged in." />



<c:set var="userId" value="" />
<c:if test="${ sessionScope != null and not empty(sessionScope.isLoggedIn) and sessionScope.isLoggedIn == 'true' and not empty(sessionScope.userDetails) }">
	<c:set var="userId" value="${sessionScope.userDetails['uid']}" />

	<%-- Support "user assimilation" (if required? - :NOTE: was in prototype, being removed for final) --%>
	<%-- c:if test="${ not empty(param.uid) and not empty(asim) and asim == true and empty(data.login.asim) }">
		<c:set var="userId" value="${param.uid}" />
	</c:if --%>
</c:if>

<c:choose>
	<c:when test="${ not empty(userId) }">
		<%-- User ID (from session) not empty --%>
		<c:choose>
			<c:when test="${ empty(data.login.user) }">
				<%-- data.login.user empty; initial login --%>

				<%-- Determine whether this is a call centre user, IT user, or supervisor (may be used later) --%>
				<c:set var="securityDescGroup" value="Unknown" />
				<c:set var="securityDescLevel" value="User" />
				<c:set var="callCentre" value="N" />
				<c:if test="${ pageContext.request.isUserInRole('CTM-Simples') or pageContext.request.isUserInRole('BD-HCC-USR') or pageContext.request.isUserInRole('BD-HCC-MGR') }">
					<c:set var="callCentre" value="Y" />
					<c:set var="securityDescGroup" value="Call Centre" />
				</c:if>
				<c:set var="IT" value="N" />
				<c:if test="${ pageContext.request.isUserInRole('BC-IT-ECOM') or pageContext.request.isUserInRole('BC-IT-ECOM-RPT') }">
					<c:set var="IT" value="Y" />
					<c:set var="securityDescGroup" value="IT" />
				</c:if>
				<c:set var="supervisor" value="N" />
				<c:if test="${ pageContext.request.isUserInRole('BD-HCC-MGR') or pageContext.request.isUserInRole('BC-IT-ECOM-RPT') }">
					<c:set var="supervisor" value="Y" />
					<c:set var="securityDescLevel" value="Supervisor" />
				</c:if>
				<c:set var="securityDesc" value="${securityDescGroup} ${securityDescLevel}" />

				<go:log>CTM Simples Login Success: ${userId} (${securityDesc}) - ${sessionScope.userDetails['distinguishedName']}</go:log>

				<%-- Set up the user, roles and security data XML fragments --%>
				<go:setData dataVar="data" xpath="login" value="*DELETE" />

				<c:set var="userXML">
					<user>
						<uid><c:out value="${sessionScope.userDetails['uid']}" /></uid>
						<agentId><c:out value="${sessionScope.userDetails['postalCode']}" /></agentId><%-- Postal Code is the LDAP alias for Agent ID --%>
						<displayName><c:out value="${sessionScope.userDetails['displayName']}" /></displayName>
						<emailAddress><c:out value="${sessionScope.userDetails['mail']}" /></emailAddress>
						<loginTimestamp><c:out value="${sessionScope.userDetails['loginTimestamp']}" /></loginTimestamp>
						<dn><c:out value="${sessionScope.userDetails['distinguishedName']}" /></dn>
						<!-- Removing as Extension can be called via the verint code <extension><c:out value="${sessionScope.extension}"/></extension>  -->
					</user>
				</c:set>
				<go:setData dataVar="data" xpath="login" xml="${userXML}" />

				<c:set var="rolesXML">
					<roles>
						<c:forTokens items="${sessionScope.userDetails['memberOf']}" delims="," var="dnPart" varStatus="dnStatus">
							<c:set var="dnPart" value="${dnPart.trim()}" />
							<c:if test="${fn:startsWith(dnPart, 'CN=') }">
								<role><c:out value="${fn:substring(dnPart,3,fn:length(dnPart))}" /></role>
							</c:if>
						</c:forTokens>
					</roles>
				</c:set>
				<go:setData dataVar="data" xpath="login" xml="${rolesXML}" />

				<c:set var="securityXML">
					<security>
						<description>${securityDesc}</description>
						<callCentre>${callCentre}</callCentre>
						<IT>${IT}</IT>
						<supervisor>${supervisor}</supervisor>
					</security>
				</c:set>
				<go:setData dataVar="data" xpath="login" xml="${securityXML}" />

				<%-- Logged in and data bean updated successfully; update success state --%>
				<c:set var="out" value="OK" />

			</c:when>

			<c:when test="${ not empty(data.login.user) and not empty(data.login.user.uid) and data.login.user.uid != userId }">
				<%-- Session and current user mismatch for some reason (suspicious activity?); enforce logout --%>
				<go:setData dataVar="data" xpath="login" value="*DELETE" />
				<c:redirect url="${data['settings/root-url']}${data.settings.styleCode}/security/simples_logout.jsp" />
			</c:when>

			<c:otherwise>
				<%-- Already logged in and matched: update success state --%>
				<c:set var="out" value="OK" />
			</c:otherwise>
		</c:choose>
	</c:when>

	<c:otherwise>
		<c:if test="${ not empty(data.login.user) }">
			<%-- Not logged in; remove user login data just for completeness --%>
			<go:setData dataVar="data" xpath="login" value="*DELETE" />
		</c:if>
	</c:otherwise>
</c:choose>



<%-- :NOTE: The below was the original MySQL-based login protoype code; --%>
<%--   just skipping it all for now, leaving here for reference for a little while --%>

<c:if test="${ false and not empty(userId) }">
	<%-- Get the user --%>
	<sql:setDataSource dataSource="jdbc/ctm"/>
	<sql:query var="result">
		SELECT *
		FROM ctm.users
		WHERE `uid` = ?
		AND `effectiveStart` <= now()
		AND `effectiveEnd` > now()
		LIMIT 1;
		<sql:param value="${userId}" />
	</sql:query>
	<go:log>User Logged in:${userId}</go:log>
	<%-- Handle all of the login procedures including security and asim --%>
	<c:choose>
		<c:when test="${result.rowCount > 0}">

			<%-- Handle the ASIM --%>
			<c:if test="${asim == true && empty data.login.asim && not empty data.login.user}">
				<go:setData dataVar="data" xpath="login/asim" xml="${data.login.user}" />
			</c:if>

			<c:set var="userXML">
				<user>
					<uid>${result.rows[0]['uid']}</uid>
					<division>${result.rows[0]['division']}</division>
					<department>${result.rows[0]['department']}</department>
					<branch>${result.rows[0]['branch']}</branch>
				</user>
			</c:set>

			<go:setData dataVar="data" xpath="login/user" value="*DELETE" />
			<go:setData dataVar="data" xpath="login" xml="${userXML}" />

			<%-- See if the user security needs to be set --%>
			<c:if test="${empty data.login.security}">
				<sql:query var="resultSecurity">
					SELECT *
					FROM ctm.security
					WHERE `uid` = ?;
					<sql:param value="${result.rows[0]['uid']}" />
				</sql:query>

				<c:set var="securityXML">
					<security>
						<callCentre>Y</callCentre>
						<c:if test="${resultSecurity.rowCount > 0}">
							<c:forEach var="row" items="${resultSecurity.rows}" varStatus="status">
								<${row.key}>${row.grant}</${row.key}>
							</c:forEach>
						</c:if>
					</security>
				</c:set>

				<go:setData dataVar="data" xpath="login" xml="${securityXML}" />
			</c:if>

			<%-- Update success state --%>
			<c:set var="out" value="OK" />
		</c:when>
	</c:choose>
</c:if>

<%-- Output the login success state --%>
<c:out value="${out}" />