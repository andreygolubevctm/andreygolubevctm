<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<%-- Load in preselected factory options and accessories --%>
<car:options_preselections />

<layout:slide formId="optionsForm" nextLabel="Next Step">

    <layout:slide_content>

        <car:snapshot_row />

        <car:options xpath="${xpath}" />

    </layout:slide_content>

</layout:slide>