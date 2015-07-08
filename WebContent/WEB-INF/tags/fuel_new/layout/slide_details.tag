<%@ tag description="Fuel Details Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout:slide formId="startForm" firstSlide="true" nextLabel="Get Prices">
    <layout:slide_columns>
        <jsp:attribute name="rightColumn"></jsp:attribute>
        <jsp:body>
            <form_new:fieldset legend="Select up to 2 fuel types" className="no-heading-margin">
                <fuel_new:fuel_checkboxes xpath="${xpath}" />
            </form_new:fieldset>

            <form_new:fieldset legend="Enter your postcode / suburb">
                <fuel_new:location xpath="${xpath}" />
            </form_new:fieldset>
        </jsp:body>
    </layout:slide_columns>
</layout:slide>
