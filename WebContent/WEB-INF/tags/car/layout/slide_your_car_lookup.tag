<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

    <layout:slide_content>

        <car:snapshot_row />

        <car:vehicle_selection_lookup xpath="${xpath}/vehicle" />

    </layout:slide_content>

</layout:slide>