<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide_new formId="benefitsForm" firstSlide="false" nextLabel="Next Step">

	<layout_v1:slide_content >

		<health_new:benefits xpath="${pageSettings.getVerticalCode()}/situation" />

	</layout_v1:slide_content>

</layout_v1:slide_new>