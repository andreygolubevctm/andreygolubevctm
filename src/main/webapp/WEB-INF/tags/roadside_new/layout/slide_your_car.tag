<%@ tag description="Journey slide 1" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="Get Quotes">

    <layout_v1:slide_columns sideHidden="false">
        <jsp:attribute name="rightColumn"></jsp:attribute>
        <jsp:body>
            <layout_v1:slide_content>

                <roadside_new:your_car />

            </layout_v1:slide_content>
        </jsp:body>
    </layout_v1:slide_columns>
</layout_v1:slide>