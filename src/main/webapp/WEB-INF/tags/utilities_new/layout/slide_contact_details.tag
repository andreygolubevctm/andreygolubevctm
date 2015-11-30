<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>

<layout:slide formId="contactForm" firstSlide="false" nextLabel="Get Quotes" prevStepId="0">
    <layout:slide_columns>

         <jsp:attribute name="rightColumn">

		</jsp:attribute>

        <jsp:body>
            <layout:slide_content>
                <utilities_new_fieldset:preferences xpath="${xpath}/resultsDisplayed" />
                <utilities_new_fieldset:contact_details xpath="${xpath}/resultsDisplayed" />

                <utilities_new:not_provided />
            </layout:slide_content>
        </jsp:body>

    </layout:slide_columns>

</layout:slide>