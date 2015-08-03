<%@ tag description="Fuel Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout:slide formId="resultsForm">
    <layout:slide_content>
        <fuel_new:results />
    </layout:slide_content>
</layout:slide>