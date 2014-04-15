<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="GENERIC" />

<c:set var="login"><core:login uid="" asim="N" /></c:set>


<c:choose>
	<c:when test="${ login == 'OK' }">
		<c:set var="loginData" value="${authenticatedData.login}" />
		<c:set var="pageTitle" value="User Details" />
		<%@ include file="/WEB-INF/security/pageHeader.jsp" %>
		<div class="fieldrow"><div class="fieldrow_label"></div><div class="fieldrow_value">You are currently logged in as:</div></div>
		<ul>
			<li class="fieldrow"><strong class="fieldrow_label">Real Name </strong><span class="fieldrow_value"><c:out value="${loginData.user.displayName}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">Email Address </strong><span class="fieldrow_value"><c:out value="${loginData.user.emailAddress}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">User ID </strong><span class="fieldrow_value"><c:out value="${loginData.user.uid}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">Logged in at </strong><span class="fieldrow_value"><c:out value="${loginData.user.loginTimestamp}" /> AEST</span></li>
			<li class="fieldrow"><strong class="fieldrow_label">Call Centre user? </strong><span class="fieldrow_value"><c:out value="${loginData.security.callCentre}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">IT user? </strong><span class="fieldrow_value"><c:out value="${loginData.security.IT}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">Supervisor? </strong><span class="fieldrow_value"><c:out value="${loginData.security.supervisor}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">User Type </strong><span class="fieldrow_value"><c:out value="${loginData.security.description}" /></span></li>
			<li class="fieldrow"><strong class="fieldrow_label">Password Note </strong><span class="fieldrow_value">To change your password, update your Windows Network login details.</span></li>

		<c:if test="${ loginData.security.IT == 'Y' }">
			<li class="fieldrow"><strong class="fieldrow_label">Member Of<br>(IT Users Only) </strong>
				<span class="fieldrow_value">
				<c:forEach var="mr" varStatus="mrStatus" items="${loginData.roles.role}">
					<c:if test="${ !mrStatus.first }"><br></c:if><c:out value="${mr}" />
				</c:forEach>
				</span>
			</li>
			<li class="fieldrow"><strong class="fieldrow_label">Distinguished Name<br>(IT Users Only) </strong>
				<span class="fieldrow_value">
				<c:forTokens items="${loginData.user.dn}" delims="," var="dnPart" varStatus="dnStatus">
					<c:out value="${dnPart}" /><c:if test="${ !dnStatus.last }"><br></c:if>
				</c:forTokens>
				</span>
			</li>
		</c:if>

		</ul>
		<div class="clearfix"></div>
		<div class="fieldrow button-wrapper"><a id="next-step" href="<c:url value="/security/simples_logout.jsp" />"><span>Log Out</span></a></div>
		<%@ include file="/WEB-INF/security/pageFooter.jsp" %>
	</c:when>

	<c:otherwise>
		<%-- Not logged in; redirect to force login prompt --%>
		<c:redirect url="${pageSettings.getBaseUrl()}simples.jsp" />
	</c:otherwise>
</c:choose>
