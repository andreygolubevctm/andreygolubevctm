<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:import var="loadQuoteUrl" url="/ajax/json/load_quote.jsp">
	<c:param name="id" value="${param.transactionId}" />
	<c:param name="action" value="amend" />
	<c:param name="vertical" value="${param.verticalCode}" />
	<c:param name="simples" value="true" />
	<c:param name="dataFormat" value="xml" />
</c:import>

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
		<c:if test="${errorReason == 'reserved'}">
			<div>
				<span>Locked by: </span><x:out select="$output/result/errorDetails/operator" escapeXml="false"/>
			</div>
			<div>
				<span>Last action: </span><x:out select="$output/result/errorDetails/type" escapeXml="false"/>
			</div>
			<div>
				<span>Time locked: </span><x:out select="$output/result/errorDetails/datetime" escapeXml="false"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:redirect url="/${redirectUrl}"/>
	</c:otherwise>
</c:choose>

