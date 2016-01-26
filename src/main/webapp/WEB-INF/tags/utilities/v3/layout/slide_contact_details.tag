<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>

<layout_v3:slide formId="contactForm" firstSlide="false" nextLabel="Get Quotes" prevStepId="0">
    <layout_v3:slide_columns>

         <jsp:attribute name="rightColumn">
            <utilities_v3_content:sidebar />
		</jsp:attribute>

        <jsp:body>
            <layout_v3:slide_content>
                <utilities_v3_fieldset:preferences xpath="${xpath}/resultsDisplayed" />
                <utilities_v3_fieldset:contact_details xpath="${xpath}/resultsDisplayed" />

                <utilities_v3:not_provided />
            </layout_v3:slide_content>
        </jsp:body>

    </layout_v3:slide_columns>

</layout_v3:slide>