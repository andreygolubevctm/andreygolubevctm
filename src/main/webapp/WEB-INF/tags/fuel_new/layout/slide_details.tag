<%@ tag description="Fuel Details Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="Get Prices">
    <layout_v1:slide_columns>
        <jsp:attribute name="rightColumn"></jsp:attribute>
        <jsp:body>
            <form_v2:fieldset legend="Select up to 2 fuel types" className="no-heading-margin">
                <fuel_new:fuel_checkboxes xpath="${xpath}" />
            </form_v2:fieldset>

            <form_v2:fieldset legend="Enter your postcode / suburb">
                <fuel_new:location xpath="${xpath}" />
            </form_v2:fieldset>
        </jsp:body>
    </layout_v1:slide_columns>
</layout_v1:slide>
