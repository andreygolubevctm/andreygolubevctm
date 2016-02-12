<%@ page import="com.ctm.web.core.email.model.EmailMode" %>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.life_submit_application')}" />

<session:get settings="true" authenticated="true" />
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />

<c:set var="vertical">${pageSettings.getVerticalCode()}</c:set>
<c:set var="continueOnValidationError" value="${false}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core_v1:access_check quoteType="life" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		${logger.debug('PROCEEDINATOR PASSED. {}' , log:kv('proceedinator',proceedinator ))}

		<%-- Processing --%>
		<core_v1:transaction touch="P" noResponse="true" />
		<go:setData dataVar="data" xpath="current/transactionId" value="${data.current.transactionId}" />
		<c:set var="writeQuoteResponse"><agg_v1:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${vertical}" source="REQUEST-CALL" dataObject="${data[vertical]}" /></c:set>
		<jsp:forward page="/spring/rest/life/apply/apply.json"/>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core_v1:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></error>
		</c:set>
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}