<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.restart_quote')}" />

<jsp:useBean id="verticalSettings" class="com.ctm.web.core.model.settings.VerticalSettings" scope="session" />

<session:delete transactionId="${param.transactionId}" />
${logger.debug('RESTART QUOTE. {}',log:kv('param',param ))}

<c:set var="vertical" value="${param.quoteType}" />

<c:set var="result">
	<result>
		<destUrl>${verticalSettings.getHomePageJsp(vertical)}</destUrl>
	</result>
</c:set>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}