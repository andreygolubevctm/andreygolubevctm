<%@ tag description="Fuel Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout_v1:slide formId="resultsForm">
    <layout_v1:slide_content>
        <fuel_new:results />
    </layout_v1:slide_content>
</layout_v1:slide>