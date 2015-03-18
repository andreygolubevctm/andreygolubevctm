<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Handover Form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" scope="request" />

<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<div class="row handover-container">
	<c:choose>
		<c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 1)}">
			<creditcard:details />
		</c:when>
		<c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}">
			<%-- Also do A touch --%>
			<core:transaction touch="A" noResponse="true" writeQuoteOverride="Y" />
			<div id="loading">
				<img src="brand/ctm/graphics/spinner-burp.gif" alt="Loading" />
				<h4>Securely transferring you to <c:out value="${productBrand}" />...</h4>
				<noscript><a href="${productHandoverUrl}">Click here to continue if you are not redirected within 5 seconds</a></noscript>
			</div>
		</c:when>
		<c:otherwise>
			<creditcard:competition />
		</c:otherwise>
	</c:choose>
</div>