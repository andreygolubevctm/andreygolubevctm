<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />
<!-- This is a temporary overwrite since we are disabling the A/B testing during Dual pricing time -->
<%-- <c:set var="useOldCtaBtn" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 3)}" scope="request" /> --%>
<c:set var="useOldCtaBtn" value="true"/>

<c:if test="${useOldCtaBtn}">
	<c:set var="oldCtaClass" value="old-cta" scope="request"/>
</c:if>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

	<layout_v3:slide_content>
		<simples:dialogue id="38" vertical="health" mandatory="true" className="hidden new-quote-only" />
		<simples:dialogue id="28" vertical="health" mandatory="true" />
		<simples:dialogue id="33" vertical="health" />

		<health_v1:results />
		<health_v1:more_info />
		<health_v1:prices_have_changed_notification />

		<simples:dialogue id="24" vertical="health" mandatory="true" />
		<simples:dialogue id="39" vertical="health" />
		<simples:dialogue id="34" vertical="health" />
	</layout_v3:slide_content>

</layout_v3:slide>