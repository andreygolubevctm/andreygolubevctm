<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout_v1:slide formId="detailsForm" nextLabel="Next Step">

    <layout_v1:slide_content>

        <car:snapshot_row />

        <car:drivers_regular_lookup xpath="${xpath}/drivers/regular" />

        <car:drivers_regular_cont xpath="${xpath}/drivers/regular" />

        <car:drivers_young xpath="${xpath}/drivers/young" />

    </layout_v1:slide_content>

</layout_v1:slide>