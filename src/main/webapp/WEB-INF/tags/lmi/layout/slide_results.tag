<%@ tag description="LMI Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout_v1:slide formId="resultsForm" className="resultsSlide">
    <layout_v1:slide_content>
        <lmi:results />
    </layout_v1:slide_content>
</layout_v1:slide>