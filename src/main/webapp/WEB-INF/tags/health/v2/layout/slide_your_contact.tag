<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="contactForm" nextLabel="Get Prices" className="contactSlide">

	<layout_v3:slide_content>
		<c:choose>
			<c:when test="${not empty worryFreePromo35 or not empty worryFreePromo36}">
				<health_v2:contact_details_optin_competition xpath="${pageSettings.getVerticalCode()}/contactDetails" />
			</c:when>
			<c:otherwise>
				<health_v2:contact_details_optin xpath="${pageSettings.getVerticalCode()}/contactDetails" />
			</c:otherwise>
		</c:choose>

	</layout_v3:slide_content>

</layout_v3:slide>