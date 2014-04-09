<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="resultsForm" className="resultsSlide">

	<layout:slide_content>

		<simples:dialogue id="28" vertical="health" mandatory="true" />
		<simples:dialogue id="32" vertical="health" className="green" />
		<simples:dialogue id="33" vertical="health" className="purple" />
		<simples:dialogue id="34" vertical="health" />

		<health:results />
		<health:more_info />

	</layout:slide_content>

</layout:slide>