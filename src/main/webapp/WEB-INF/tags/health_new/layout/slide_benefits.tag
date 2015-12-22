<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide_new formId="benefitsForm" firstSlide="false" nextLabel="Next Step">

	<layout:slide_content >

		<health_new:benefits xpath="${pageSettings.getVerticalCode()}/situation" />

	</layout:slide_content>

</layout:slide_new>