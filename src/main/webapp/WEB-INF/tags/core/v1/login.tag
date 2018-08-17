<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="This is the login procedure, which adds the user to the data bucket"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="simplesUserService" class="com.ctm.web.simples.services.SimplesUserService" scope="application" />
<jsp:useBean id="phoneService" class="com.ctm.web.simples.phone.verint.CtiPhoneService" scope="page" />

<c:set var="logger" value="${log:getLogger('tag.core.login')}" />

<%-- ATTRIBUTES --%>
<%@ attribute name="uid" 		required="true"	rtexprvalue="true"	description="The user id" %>

<%-- Assume anonymous by default --%>
<c:set var="out" value="Not logged in." />

<c:set var="userId" value="" />
<c:if test="${ sessionScope != null and not empty sessionScope.isLoggedIn and sessionScope.isLoggedIn == 'true' and not empty sessionScope.userDetails }">
	<c:set var="userId" value="${sessionScope.userDetails['uid']}" />
</c:if>

<c:choose>
	<c:when test="${ not empty userId }">
		
		<%-- User ID (from session) not empty --%>
		
		<c:choose>
			<c:when test="${ empty authenticatedData.login.user }">

				<%-- Determine whether this is a call centre user, IT user, or supervisor (may be used later) --%>
				<c:set var="securityDescGroup" value="Unknown" />
				<c:set var="securityDescLevel" value="User" />

				<c:set var="callCentre" value="N" />
                <c:set var="ccRewardsGroup" value="N" />

                <c:if test="${ pageContext.request.isUserInRole('CTM-CC-REWARDS') }">
                    <c:set var="callCentre" value="Y" />
                    <c:set var="ccRewardsGroup" value="Y" />
                </c:if>

				<c:if test="${ pageContext.request.isUserInRole('CTM-Simples') or pageContext.request.isUserInRole('BD-HCC-USR') or pageContext.request.isUserInRole('BD-HCC-MGR') }">
					<c:set var="callCentre" value="Y" />
					<c:set var="securityDescGroup" value="Call Centre" />
				</c:if>
				
				<c:set var="IT" value="N" />
				<c:if test="${ pageContext.request.isUserInRole('BC-IT-ECOM')  or pageContext.request.isUserInRole('CTM-IT-USR')  }">
					<c:set var="IT" value="Y" />
					<c:set var="securityDescGroup" value="IT" />
				</c:if>
				
				<c:set var="supervisor" value="N" />
				<c:if test="${ pageContext.request.isUserInRole('BD-HCC-MGR') or pageContext.request.isUserInRole('BC-IT-ECOM-RPT') or pageContext.request.isUserInRole('CTM-IT-USR') or pageContext.request.isUserInRole('jira-ctm-projmgr') }">
					<c:set var="supervisor" value="Y" />
					<c:set var="securityDescLevel" value="Supervisor" />
				</c:if>

				<c:set var="editAdminMenuAuth" value="N" />
				<c:if test="${ pageContext.request.isUserInRole('CTM-HLT-SIMPLES-EDIT-ADMIN-MENU')}">
					<c:set var="editAdminMenuAuth" value="Y" />
				</c:if>

				<!-- Restricting 'browsertest' accessing simples in production environment. -->
				<c:if test="${userId == 'browsertest' and com.ctm.web.core.services.EnvironmentService.getEnvironmentAsString() == 'PRO'}">
					<c:set var="callCentre" value="N" />
					<c:set var="supervisor" value="N" />
					<c:set var="IT" value="N" />
					<c:set var="editAdminMenuAuth" value="N" />
					<c:set var="securityDescGroup" value="Unknown" />
				</c:if>

				<c:set var="securityDesc" value="${securityDescGroup} ${securityDescLevel}" />
				<c:set var="distinguishedName" value="${sessionScope.userDetails['distinguishedName']}" />
				${logger.info('CTM Simples login success: {},{},{}',log:kv('userId', userId), log:kv('securityDesc', securityDesc), log:kv('distinguishedName',distinguishedName))}
				<%-- Set up the user, roles and security data XML fragments --%>
				<go:setData dataVar="authenticatedData" xpath="login" value="*DELETE" />

				<%-- Get the operator's phone extension --%>
				<%-- This is retrieved via the Verint recording/auditing service --%>
				<%-- Only try to get the extention when Inin is not enabled --%>
				<c:if test="${!pageSettings.getSetting('inInEnabled')}">
					<c:catch var="extensionError">
						<c:set var="extension" value="${phoneService.getExtensionByAgentId(pageSettings, sessionScope.userDetails['postalCode'])}" />
					</c:catch>
				</c:if>

				<c:set var="simplesChatUserGroup" value="N" />
				<c:set var="simplesChatUser"><content:get key="simplesChatUser" suppKey="${userId}"/></c:set>

				<c:if test="${not empty simplesChatUser and simplesChatUser eq 'simplesChatUser'}">
					<c:set var="simplesChatUserGroup" value="Y" />
				</c:if>

				<c:set var="userXML">
					<user>
						<uid><c:out value="${sessionScope.userDetails['uid']}" /></uid>
						<agentId><c:out value="${sessionScope.userDetails['postalCode']}" /></agentId><%-- Postal Code is the LDAP alias for Agent ID --%>
						<displayName><c:out value="${sessionScope.userDetails['displayName']}" /></displayName>
						<emailAddress><c:out value="${sessionScope.userDetails['mail']}" /></emailAddress>
						<loginTimestamp><c:out value="${sessionScope.userDetails['loginTimestamp']}" /></loginTimestamp>
						<dn><c:out value="${distinguishedName}" /></dn>
						<extension><c:out value="${extension}"/></extension>
					</user>
				</c:set>
				<go:setData dataVar="authenticatedData" xpath="login" xml="${userXML}" />

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
				<go:setData dataVar="authenticatedData" xpath="login" xml="${rolesXML}" />

				<c:set var="securityXML">
					<security>
						<description>${securityDesc}</description>
						<callCentre>${callCentre}</callCentre>
                        <ccRewardsGroup>${ccRewardsGroup}</ccRewardsGroup>
						<IT>${IT}</IT>
						<supervisor>${supervisor}</supervisor>
						<editAdminMenuAuth>${editAdminMenuAuth}</editAdminMenuAuth>
						<simplesChatGroup>${simplesChatUserGroup}</simplesChatGroup>
					</security>
				</c:set>
				<go:setData dataVar="authenticatedData" xpath="login" xml="${securityXML}" />



				<%-- Register the user into our database; fetch the database UID --%>
				<c:if test="${callCentre == 'Y'}">
					<c:set var="simplesUser" value="${ simplesUserService.loginUser(sessionScope.userDetails['uid'], extension, sessionScope.userDetails['displayName'])  }" />
					<go:setData dataVar="authenticatedData" xpath="login/user/simplesUid" value="${simplesUser.getId()}" />
					${authenticatedData.setSimplesUserRoles(simplesUser.getRoles())}
					${authenticatedData.setGetNextMessageRules(simplesUser.getRules())}
				</c:if>

				<c:set var="out" value="OK" />
			</c:when>

			<c:when test="${ not empty authenticatedData.login.user and not empty authenticatedData.login.user.uid and authenticatedData.login.user.uid != userId }">
				<%-- Session and current user mismatch for some reason (suspicious activity?); enforce logout --%>
				<c:remove var="authenticatedData"/>
				<c:redirect url="/security/simples_logout.jsp" />
			</c:when>

			<c:otherwise>
				<%-- Already logged in and matched: update success state --%>
				<c:set var="out" value="OK" />
			</c:otherwise>
		</c:choose>
	</c:when>

	<c:otherwise>
		<c:if test="${ not empty authenticatedData.login.user }">
			<%-- Not logged in; remove user login data just for completeness --%>
			<c:remove var="authenticatedData"/>
		</c:if>
	</c:otherwise>

</c:choose>



<%-- Output the login success state --%>
<c:out value="${out}" />