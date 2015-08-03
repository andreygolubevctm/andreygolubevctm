<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="newWebServiceSplitTest" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 40)}" />

<c:set var="defaultToCarQuote"><content:get key="makeCarQuoteMainJourney" /></c:set>

<layout:slide formId="resultsForm" className="resultsSlide">

	<layout:slide_content>

		<c:choose>
			<c:when test="${newWebServiceSplitTest || defaultToCarQuote eq 'true'}">
				<car:results_ws />
			</c:when>
			<c:otherwise>
				<car:results />
			</c:otherwise>
		</c:choose>

	</layout:slide_content>

</layout:slide>