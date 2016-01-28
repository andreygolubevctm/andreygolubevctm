<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Check whether is a new quote or existing and sets the isNEWQuote variable"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="logger"  value="${log:getLogger('tag.core.quote_check')}" />

<%@ attribute name="quoteType" 	required="true"		rtexprvalue="true"	description="The vertical this quote is for"%>

<c:if test="${not empty quoteType}">
	<c:set var="isNewQuote" scope="session">
		<c:choose>
			<c:when test="${not empty param.action and not empty data.current.transactionId and (param.action eq 'amend' or param.action eq 'latest' or param.action eq 'confirmation' or param.action eq 'start-again' or param.action eq 'load' or param.action eq 'expired' or param.action eq 'promotion')}">${false}</c:when>
			<c:when test="${empty data['current/transactionId']}">true</c:when>
			<c:otherwise>${true}</c:otherwise>
		</c:choose>
	</c:set>

	<c:choose>
		<c:when test="${isNewQuote eq true}">
			<core_v1:transaction touch="N" noResponse="true" />
		</c:when>
		<c:otherwise>
		${logger.debug('Treated as EXISTING quote')}
		</c:otherwise>
	</c:choose>

	<%-- This rubbish dumps into the page above the DOCTYPE. It is now stored on meerkat.site.isNewQuote (settings.tag) --%>
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