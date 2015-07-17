<%@ tag description="LMI Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />
<layout:slide formId="resultsForm" className="resultsSlide">
    <layout:slide_content>
        <lmi:results />
    </layout:slide_content>
</layout:slide>