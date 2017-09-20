<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v2:no_cache_header/>

<session:get settings="true" authenticated="true" throwCheckAuthenticatedError="true" verticalCode="${fn:toUpperCase(param.quoteType)}"/>

<c:set var="proceedinator"><core_v1:access_check quoteType="${param.quoteType}" /></c:set>
<c:if test="${empty proceedinator}">
	<c:set var="proceedinator">${0}</c:set>
</c:if>

<%--
	These are the touch types that are allowed via ajax.
	All other touches need to be done using <core_v1:transaction touch="?" />
--%>
<c:set var="valid_touches" value="A.E.F.H.S.X.CB.EC.R.CONF." />
<c:set var="validate_touch" value="${param.touchtype}." />
<c:if test="${empty param.touchtype or !fn:contains(valid_touches, validate_touch)}">
	<c:set var="proceedinator">99</c:set>
</c:if>

<c:set var="result">
<result>
	<success>${proceedinator}</success>
	<c:choose>
		<c:when test="${proceedinator eq 0}">
			<message><core_v1:access_get_reserved_msg isSimplesUser="${not empty authenticatedData.login.user.uid}" /></message>
		</c:when>
		<c:when test="${proceedinator eq 99}">
			<message>Invalid touch type.</message>
		</c:when>
		<c:otherwise>

			<%-- TODO: This is dirty (we know) however CAR doesn't use the same label
				for it's XPATH so we must massage the vertical code a little. --%>
			<c:set var="verticalCode">
				<c:choose>
					<c:when test="${pageSettings.getVerticalCode() eq 'car'}">quote</c:when>
					<c:otherwise>${pageSettings.getVerticalCode()}</c:otherwise>
				</c:choose>
			</c:set>

			<c:choose>
				<c:when test="${param.touchtype == 'R' || param.touchtype == 'S'}">
					<security:populateDataFromParams rootPath="${verticalCode}" />
				</c:when>
				<%-- Generic HIT is used by multiple verticals - which may or may not be submitting the questionset form
					so let's not delete the bucket. Eg. Comparing policies in Health doesn't submit the form so will delete
					the calcSequence from the bucket... which we need --%>
				<c:when test="${param.touchtype == 'H'}">
					<security:populateDataFromParams rootPath="${verticalCode}" delete="false" />
				</c:when>
			</c:choose>
			<core_v1:transaction touch="${param.touchtype}" comment="${param.comment}" noResponse="true" productId="${param.productId}" />
		</c:otherwise>
	</c:choose>
	<transactionId>${data.current.transactionId}</transactionId>
</result>
<timeout>${sessionDataService.getClientSessionTimeout(pageContext.getRequest())}</timeout>
</c:set>

<c:choose>
<c:when test="${pageSettings.getSetting('rememberMeEnabled') eq 'Y' and
				pageSettings.getVerticalCode() eq 'health' and
                param.touchtype eq 'H' and
                param.comment eq 'HLT results' and
                empty authenticatedData.login.user.uid}">
<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />
<c:set var="rememberMe" value="${rememberMeService.setCookie(pageSettings.getVerticalCode(), data.current.transactionId, pageContext.response)}" scope="request"  />
</c:when>
</c:choose>

<%-- Return the results as json --%>
<c:set var="accessTouchResponse" >${go:XMLtoJSON(result)}</c:set>
${sessionDataService.updateTokenWithNewTransactionIdResponse(pageContext.request, accessTouchResponse, data.current.transactionId)}