<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout_v1:slide formId="optionsForm" nextLabel="Next Step">

    <layout_v1:slide_content>

        <car:snapshot_row />

        <car:options xpath="${xpath}" />

    </layout_v1:slide_content>

</layout_v1:slide>