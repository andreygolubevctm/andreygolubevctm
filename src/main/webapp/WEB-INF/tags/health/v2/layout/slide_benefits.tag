<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide_new formId="benefitsForm" firstSlide="false" nextLabel="Next Step">

	<layout_v1:slide_content >

		<form_v2:fieldset legend="Choose which benefits are important to you" postLegend="Knowing what's important to you will help us display policies relevant to your needs" />

		<%--Split test this--%>
		<health_v3:benefits xpath="${pageSettings.getVerticalCode()}/situation" />

	</layout_v1:slide_content>

</layout_v1:slide_new>