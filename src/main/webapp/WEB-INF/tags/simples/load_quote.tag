<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="GENERIC" forceNew="true" authenticated="true" />

<jsp:useBean id="accessCheckService" class="com.ctm.web.core.services.AccessCheckService" scope="page" />

<c:set var="env" value="${environmentService.getEnvironmentAsString()}" />

<c:choose>
	<c:when test="${accessCheckService.isLocked(param.transactionId , authenticatedData.login.user.uid, param.verticalCode)}">
		<c:set var="accessTouch"  value="${accessCheckService.getLatestTouch()}" scope="request" />
		<h1>Error</h1>
		<p>This quote has been reserved by another user. Please try again later.</p>
		<div>
			<span>Locked by: </span><c:out value="${accessTouch.getOperator()}" escapeXml="true"/>
		</div>
		<div>
			<span>Last action: </span><c:out value="${accessTouch.getLastTouch().getType().getDescription()}" escapeXml="true"/>
		</div>
		<div>
			<span>Time locked: </span><fmt:formatDate value="${accessTouch.getLockDateTime()}" pattern="dd/MM/yyyy hh:mm:ss aa"/>
		</div>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${env eq 'PRO'}">
				<%--Only add brandCode param in PRO, adding this breaks in dev, nxi, nxq environment--%>
				<c:import var="loadQuoteUrl" url="/ajax/json/load_quote.jsp">
					<c:param name="id" value="${param.transactionId}" />
					<c:param name="action" value="amend" />
					<c:param name="vertical" value="${param.verticalCode}" />
					<c:param name="simples" value="true" />
					<c:param name="dataFormat" value="xml" />
					<c:param name="brandCode" value="${param.brandCode}" />
				</c:import>
			</c:when>
			<c:otherwise>
				<c:import var="loadQuoteUrl" url="/ajax/json/load_quote.jsp">
					<c:param name="id" value="${param.transactionId}" />
					<c:param name="action" value="amend" />
					<c:param name="vertical" value="${param.verticalCode}" />
					<c:param name="simples" value="true" />
					<c:param name="dataFormat" value="xml" />
				</c:import>
			</c:otherwise>
		</c:choose>

		<x:parse xml="${loadQuoteUrl}" var="output"/>

		<c:set var="redirectUrl">
			<x:out select="$output/result/destUrl" escapeXml="false"/>
		</c:set>

		<c:choose>
			<c:when test="${empty redirectUrl}">
				<c:set var="errorMessage">
					<x:out select="$output/result/error" escapeXml="false"/>
				</c:set>
				<c:set var="errorReason">
					<x:out select="$output/result/errorDetails/reason" escapeXml="false"/>
				</c:set>
				<h1>Error</h1>
				<p>${errorMessage}</p>
			</c:when>
			<c:otherwise>
				<c:redirect url="${pageSettings.getBaseUrl()}${redirectUrl}"/>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

