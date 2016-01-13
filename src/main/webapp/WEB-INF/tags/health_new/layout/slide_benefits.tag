<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide_new formId="benefitsForm" firstSlide="false" nextLabel="Next Step">

	<layout:slide_content >
		<form_new:fieldset legend="Choose which benefits are important to you" postLegend="Knowing what's important to you will help us display policies relevant to your needs" ></form_new:fieldset>
		<div id="${name}-selection" class="health-benefits">
			<health_new:benefits xpath="${pageSettings.getVerticalCode()}/situation" />
		</div>


	</layout:slide_content>

</layout:slide_new>