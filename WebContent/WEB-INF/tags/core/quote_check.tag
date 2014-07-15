<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Check whether is a new quote or existing and sets the isNEWQuote variable"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="quoteType" 	required="true"		rtexprvalue="true"	description="The vertical this quote is for"%>

<go:log source="core:quote_check">Quote Check Started: ${quoteType}</go:log>

<c:if test="${not empty quoteType}">
	<c:set var="isNewQuote" scope="session">
		<c:choose>
			<c:when test="${not empty param.action and (param.action eq 'amend' or param.action eq 'latest' or param.action eq 'confirmation' or param.action eq 'start-again')}">${false}</c:when>
			<c:when test="${empty data['current/transactionId']}">true</c:when>
			<c:otherwise>${true}</c:otherwise>
		</c:choose>
	</c:set>

	<c:choose>
		<c:when test="${isNewQuote eq true}">
			<go:log source="core:quote_check">Treated as NEW quote</go:log>
			<core:transaction touch="N" noResponse="true" />
		</c:when>
		<c:otherwise>
			<go:log source="core:quote_check">Treated as EXISTING quote</go:log>
		</c:otherwise>
	</c:choose>

	<%-- This rubbish dumps into the page above the DOCTYPE. It is now stored on meerkat.site.isNewQuote (health_new/settings.tag) --%>
	<c:if test="${quoteType != 'health'}">
		<script type="text/javascript">
			var quoteCheck = new Object();
			quoteCheck = {
		<c:choose>
			<c:when test="${isNewQuote eq true}">
					_new_quote: true
			</c:when>
			<c:otherwise>
					_new_quote: false
			</c:otherwise>
		</c:choose>
			};
		</script>
	</c:if>
</c:if>