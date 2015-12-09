<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_new_layout:slide_new formId="benefitsForm" firstSlide="false" nextLabel="Next Step">

	<layout_new_layout:slide_content >

		<health_new:benefits xpath="${pageSettings.getVerticalCode()}/situation" />

	</layout_new_layout:slide_content>

</layout_new_layout:slide_new>