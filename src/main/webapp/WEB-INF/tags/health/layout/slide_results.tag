<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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