<%@ tag description="Journey slide 1" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="startForm" firstSlide="true" nextLabel="Get Quotes">

    <layout:slide_columns sideHidden="false">
        <jsp:attribute name="rightColumn"></jsp:attribute>
        <jsp:body>
            <layout:slide_content>

                <roadside_new:your_car />

            </layout:slide_content>
        </jsp:body>
    </layout:slide_columns>
</layout:slide>