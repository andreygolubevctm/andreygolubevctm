<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

	<layout_v3:slide_content>
		<simples:dialogue id="38" vertical="health" mandatory="true" className="hidden new-quote-only" />
		<simples:dialogue id="28" vertical="health" mandatory="true" />
		<simples:dialogue id="33" vertical="health" />

		<health_v1:results />
		<health_v1:more_info />
		<health_v1:prices_have_changed_notification />

		<simples:dialogue id="24" vertical="health" mandatory="true" />
	</layout_v3:slide_content>

</layout_v3:slide>