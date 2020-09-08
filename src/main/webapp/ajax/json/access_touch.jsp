<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v2:no_cache_header/>

<session:get settings="true" authenticated="true" throwCheckAuthenticatedError="true" verticalCode="${fn:toUpperCase(param.quoteType)}"/>

<c:set var="proceedinator"><core_v1:access_check quoteType="${param.quoteType}" /></c:set>
<c:if test="${empty proceedinator}">
	<c:set var="proceedinator">${0}</c:set>
</c:if>

<c:set var="lastKnownTransactionId" value="${param.lastKnownTransactionId}" />
<c:set var="selectedProductId" value="${param.productId}" />
<c:set var="currentTransactionId" value="${data.current.transactionId}" />

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
<%-- Removed call to delay lead to reduce dialler interactions however keeping code as may wish to re-instate this later --%>
<%--
				<c:when test="${verticalCode eq 'health' and empty authenticatedData.login.user.uid and param.touchtype eq 'A' and not empty param.phone and pageSettings.hasSetting('delayLeadOnApplicationStep') and pageSettings.getSetting('delayLeadOnApplicationStep') eq 'Y'}">
					<jsp:useBean id="simplesLeadService" class="com.ctm.web.health.services.HealthSimplesLeadService" scope="application" />
					<c:set var="delayResult" value="${simplesLeadService.delayLeadAsEnteredApplicationStep(pageContext.request, param.phone)}" />
				</c:when>
--%>
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

            <%-- RECOVER: if things have gone pear shaped --%>
            <c:if test="${empty data.current.transactionId}">
                <c:choose>
                    <c:when test="${verticalCode.compareToIgnoreCase('health') eq 0 and not empty lastKnownTransactionId and not empty selectedProductId}">
                        <error:recover origin="ajax/json/access_touch.jsp" quoteType="${verticalCode}" lastKnownTransactionId="${lastKnownTransactionId}" selectedProductId="${selectedProductId}" />
                    </c:when>
                    <c:otherwise>
                        <error:recover origin="ajax/json/access_touch.jsp" quoteType="${verticalCode}" />
                    </c:otherwise>
                </c:choose>
            </c:if>

            <%-- Perform vertical specific recovery operations if current transactionId and last known transactionId don't match --%>
            <c:if test="${data.current.transactionId ne lastKnownTransactionId}">
                <c:choose>
                    <%-- For HEALTH we want to recover the selected product data if available --%>
                    <c:when test="${verticalCode.compareToIgnoreCase('health') eq 0 and not empty lastKnownTransactionId and not empty selectedProductId}">
                        <jsp:useBean id="selectedProductService" class="com.ctm.web.health.services.HealthSelectedProductService" scope="application" />
                        ${selectedProductService.cloneSelectedProduct(lastKnownTransactionId, data.current.transactionId, selectedProductId)}
                    </c:when>
                </c:choose>
            </c:if>

			<core_v1:transaction touch="${param.touchtype}" comment="${param.comment}" noResponse="true" productId="${param.productId}" productName="${param.productName}" providerCode="${param.providerCode}" />
		</c:otherwise>
	</c:choose>
	<transactionId>${data.current.transactionId}</transactionId>
</result>
<timeout>${sessionDataService.getClientSessionTimeout(pageContext.getRequest())}</timeout>
</c:set>

<%-- Return the results as json --%>
<c:set var="accessTouchResponse" >${go:XMLtoJSON(result)}</c:set>
${sessionDataService.updateTokenWithNewTransactionIdResponse(pageContext.request, accessTouchResponse, data.current.transactionId)}
