<%@ tag description="Journey slide - Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="newWebServiceSplitTest" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 40)}" />

<layout:slide formId="resultsForm" className="resultsSlide">

	<layout:slide_content>
		<c:choose>
			<c:when test="${newWebServiceSplitTest}">
				<home_new:results_ws />
			</c:when>
			<c:otherwise>
				<home_new:results />
			</c:otherwise>
		</c:choose>
	</layout:slide_content>

</layout:slide>