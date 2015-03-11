<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="useOldCtaBtn" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 3)}" scope="request" />

<c:if test="${useOldCtaBtn}">
	<c:set var="oldCtaClass" value="old-cta" scope="request"/>
</c:if>

<layout:slide formId="resultsForm" className="resultsSlide">

	<layout:slide_content>
		<simples:dialogue id="38" vertical="health" mandatory="true" className="hidden new-quote-only" />
		<simples:dialogue id="28" vertical="health" mandatory="true" />
		<simples:dialogue id="33" vertical="health" />

		<health:results />
		<health:more_info />
		<health:prices_have_changed_notification />

		<simples:dialogue id="24" vertical="health" mandatory="true" />
		<simples:dialogue id="39" vertical="health" />
		<simples:dialogue id="34" vertical="health" />
	</layout:slide_content>

</layout:slide>